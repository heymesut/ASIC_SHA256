////////////////////////////////////
//description:register array and sigma calculation of message schedule module
//
//parameter:description
//clk
//reset:high enable
//data:input message(32 bits input per cycle)
//logic_result:Wj after logic calculation
//write_enable:when input data is valid,set 1
//inner_busy:set 1 to enable message_schedule module
//Wt:message schedule module output(the first register(R0) of register array)
//R6,R15:register output for logic calculation
//sigma0: the result after sigma0
//sigma1: the result after sigma1
//////////////////////////////////////


module schedule_core(
    input  wire            clk,
    input  wire            reset,
    input  wire [31:0]     data,
    input  wire [31:0]     logic_result,
    input  wire            write_enable,
    input  wire            inner_busy,
    output reg  [31:0]     Wt,//R0
    output reg  [31:0]     R6,
    output reg  [31:0]     R15,
    output wire [31:0]     sigma0,
    output wire [31:0]     sigma1 
);

reg   [31:0]        R1,R2,R3,R4,R5,R7,R8,R9,R10,R11,R12,R13,R14//register array
reg   [6 :0]        counter;

//sigma calculation
assign sigma0 = {R14[6:0],R14[31:7]} ^ {R14[17:0],R14[31:18]} ^ {3'b000,R14[31:3]};
assign sigma1 = {R1[16:0],R1[31:17]} ^ {R1[18:0],R1[31:19]} ^ {10'b00_0000_0000,R1[31:10]};


//register array
always @ (posedge clk or posedge reset)
begin
    if(reset==1'b1 || counter==7'd64)
        begin
            Wt<=32'b0;
            R1<=32'b0;
            R2<=32'b0;
            R3<=32'b0;
            R4<=32'b0;
            R5<=32'b0;
            R6<=32'b0;
            R7<=32'b0;
            R8<=32'b0;
            R9<=32'b0;
            R10<=32'b0;
            R11<=32'b0;
            R12<=32'b0;
            R13<=32'b0;
            R14<=32'b0;
            R15<=32'b0;
        end
    else
        if(inner_busy==1'b1)
            begin
                if(write_enable==1'b1)
                    Wt<=data;
                else
                    Wt<=logic_result;

                R1<=Wt;
                R2<=R1;
                R3<=R2;
                R4<=R3;
                R5<=R4;
                R6<=R5;
                R7<=R6;
                R8<=R7;
                R9<=R8;
                R10<=R9;
                R11<=R10;
                R12<=R11;
                R13<=R12;
                R14<=R13;
                R15<=R14;
            end
        else
            begin
                Wt<=32'b0;
                R1<=32'b0;
                R2<=32'b0;
                R3<=32'b0;
                R4<=32'b0;
                R5<=32'b0;
                R6<=32'b0;
                R7<=32'b0;
                R8<=32'b0;
                R9<=32'b0;
                R10<=32'b0;
                R11<=32'b0;
                R12<=32'b0;
                R13<=32'b0;
                R14<=32'b0;
                R15<=32'b0;
            end    
end

always @ (posedge clk or posedge reset)
begin
    if(reset==1'b1 || counter==7'd64)
        counter<=7'd0;
    else
        if(inner_busy==1'b1)
            counter<=counter+1;
        else
            counter<=7'd0;
end


endmodule