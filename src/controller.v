///////////////////////////////////////
//description:control signal generator(FSM)

//paramter:description
//clk
//reset:hign enable
//first_block:when input is the first bolck,set 1 during the first cycle and
//the last cycle before input
//last_block: when input is the last block,set 1 during the first cycle
//output_enable: when output digest is valid,set 1
//busy:when the module is working,set 1
//inner_busy:set 1 to enable hash_core and message_schedule module
///////////////////////////////////////    


module controller(
    input  wire               clk,
    input  wire               reset,
    input  wire               first_block,
    input  wire               last_block,
    output wire               output_enable,
    output wire               busy,
    output wire               inner_busy
);


reg  [1:0]         state;
reg  [1:0]         next_state;

reg  [6:0]         counter1;
reg  [7:0]         counter2;

parameter s0=2'b00;//idle
parameter s1=2'b01;//read_data
parameter s2=2'b10; //iteration

assign busy             =    (state==s0)? 0 : 1;
assign output_enable    =    (counter2>=8'd132 && counter2<8'd196)? 1 : 0;
assign inner_busy       =    (state==s2)? 1 : 0;


always @(posedge clk)
begin
    if(reset==1'b1)
        state<=s0;
    else
        state<=next_state;
end

always @(*)
begin
    case (state)
      s0:
        if(first_block==1)
            next_state=s1;
        else
            next_state=s0;
      s1:
        if(counter1==7'd64)
            next_state=s2;
        else
            next_state=s1;
      s2:
        if(counter2==8'd131)
            next_state=s0;
        else
            next_state=s2; 
        default: 
            next_state=s0;
    endcase
end


always @ (posedge clk)
begin
    if(reset==1'b1)
        counter1<=7'd0;
    else
        if(state==s1)
            counter1<=counter1+1;
        else
            counter1<=7'd0; 
end

always @ (posedge clk)
begin
    if(reset==1'b1)
        counter2<=8'd0;
    else
        if(counter2==8'd196)
            counter2<=8'd0;
        else
            if(counter2!=8'd0 || last_block==1'b1)
                counter2<=counter2+1;
            else
                counter2<=8'd0;
end

endmodule