`timescale 1ns / 1ps

module top;

    // Inputs
    wire clk;
    wire reset;
    wire [31:0] data;
    wire write_enable;
    wire last_block;
    wire first_block;

    // Outputs
    wire busy;
    wire digest;
    wire output_enable;

    initial begin
        // Inputs
        //two blocks
        clk=0;
        reset=1;
        data=0;
        last_block=0;
        first_block=1;
        write_enable=0;
        #8  reset=0;
        #8  write_enable=1; //the data input begins
        #8  first_block=0;  //first cycle of first block, the first cycle ends
        #120 write_enable=0; 
        #8                  //prepare for the next block
        #384 last_block=1;  
            write_enable=1; //after 63 cycles, the second block begins
        #8  last_block=0;   
        #120 write_enable=0; 
    end

    always #4 clk=~clk;

    top topt(
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