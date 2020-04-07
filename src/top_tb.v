`timescale 1ns / 1ps

module top_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] data;
    reg write_enable;
    reg  last_block;
    reg first_block;

    // Outputs
    wire busy;
    wire [31:0]  digest;
    wire output_enable;

    initial begin
        // Inputs
        //two blocks
        clk=1'b1;
        reset=1'b1;
        data=32'b0;
        last_block=1'b0;
        first_block=1'b0;
        write_enable=1'b0;
        #8  reset=1'b0;
            first_block=1'b1;
        #8  write_enable=1'b1; //the data input begins
        #8  first_block=1'b0;  //first cycle of first block, the first cycle ends
        #120 write_enable=1'b0; 
        #392 last_block=1'b1;  //after 49 cycles,next block
            write_enable=1'b1; //after 63 cycles, the second block begins
        #8  last_block=1'b0;   
        #120 write_enable=1'b0; 
    end

    always #4 clk=~clk;

    top our_top(
        .clk(clk),
        .reset(reset),
        .data(data),
        .write_enable(write_enable),
        .last_block(last_block),
        .first_block(first_block),
        .busy(busy),
        .digest(digest),
        .output_enable(output_enable)
    );
    
endmodule