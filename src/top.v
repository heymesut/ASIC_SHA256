//////////////////////////////////////////////////
//description：SHA256 top module

//parameter:description
//clk
//reset:high enable
//data:input message(8 bits input per cycle)
//write_enable:when input data is valid,set 1
//last_block: when input is the last block,set 1 during the first cycle
//first_block:when input is the first bolck,set 1 during the first cycle and
//the last cycle before input
//busy:when the module is working,set 1
//digest:output digest(4 bits output per cycle)
//output_valid: when output digest is valid,set 1
//////////////////////////////////////////////////


module top(
    input  wire                clk,
    input  wire                reset,
    input  wire [7:0]          data,
    input  wire                write_enable,
    input  wire                last_block,
    input  wire                first_block,
    output wire                busy,
    output wire [3:0]          digest,
    output wire                output_valid           
);


wire [31:0]           Wt;
wire                  inner_busy;//enable hash_core and message_schedule
wire                  first_block_core;//when the first cycle of the core dealing with the first block ,set 1
wire                  output_enable;

message_schedule our_message_schedule(
    .clk(clk),
    .reset(reset),
    .data(data),
    .write_enable(write_enable),
    .inner_busy(inner_busy),
    .Wt(Wt)
);

//hash iteration and hash updating
hash_core our_hash_core(
    .clk(clk),
    .reset(reset),
    .Wt(Wt),
    .inner_busy(inner_busy),
    .first_block_core(first_block_core),
    .output_enable(output_enable),
    .digest(digest),
    .output_valid(output_valid)
);

controller our_controller(
    .clk(clk),
    .reset(reset),
    .first_block(first_block),
    .last_block(last_block),
    .output_enable(output_enable),
    .busy(busy),
    .inner_busy(inner_busy),
    .first_block_core(first_block_core)
);


endmodule