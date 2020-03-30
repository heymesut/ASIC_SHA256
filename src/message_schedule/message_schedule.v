//////////////////////////////////////
//description:message schedule top module
//
//parameter:description
//clk
//reset:high enable
//data:input message(32 bits input per cycle)
//write_enable:when input data is valid,set 1
//inner_busy:set 1 to enable message schedule module
//Wt:message schedule module output(to hash core module)
//////////////////////////////////////


module message_shcdule(
    input  wire            clk,
    input  wire            reset,
    input  wire [31:0]     data,
    input  wire            write_enable,
    input  wire            inner_busy,
    output wire [31:0]     Wt
);

wire [31:0]     logic_result;
wire [31:0]     R6;
wire [31:0]     R15;
wire [31:0]     sigma0;
wire [31:0]     sigma1;
wire [31:0]     CLA1_out;
wire [31:0]     CLA2_out;   

schedule_core our_schedule_core(
    .clk(clk),
    .reset(reset),
    .data(data),
    .logic_result(logic_result),
    .write_enable(write_enable),
    .inner_busy(inner_busy),
    .Wt(Wt),
    .R6(R6),
    .R15(R15),
    .sigma0(sigma0),
    .sigma1(sigma1)
);

carry_lookahead_adder our_CLA1(
    
);

carry_lookahead_adder our_CLA2(
    
);

carry_lookahead_adder our_CLA3(
    
);


endmodule