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

//data:0000000000000000000000000000000000000000000000000000000(0 ASCII:8'h30)
//加密后：0x9f8ef876f51f5313c91cc3f6b8119af09d8bbdd72098fa149b2780eb3591d6be
//需要加密的内容是56个0，长度为448位，刚好模512余448，所以被补全，补全到448+512位，补全第一位为1，其余位为0。
//因为448位二进制表示为111000000，所以最后再加补全64位，64位开始为0，结尾为111000000
    initial begin
        // Inputs
        //two blocks
        clk<=1'b1;
        reset<=1'b1;
        data<=32'b0;
        last_block<=1'b0;
        first_block<=1'b0;
        write_enable<=1'b0;
        #8  reset<=1'b0;
            first_block<=1'b1;
        #8  write_enable<=1'b1;
            data<=32'h3030_3030;
         //the data input begins
        #8  first_block<=1'b0; 
        #104 data<=32'h8000_0000; // the 15th cycle
        #8 data<=32'b0;
        #8 write_enable<=1'b0; 
        #392 last_block<=1'b1;  
            write_enable<=1'b1; //after 49 cycles,next block
        #8  last_block<=1'b0;   
        #112 data<=32'h0000_01c0;// the last 32bits data
        #8 write_enable<=1'b0; 
            data<=32'b0;
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