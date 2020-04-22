`timescale 1ns / 1ps

`define SHA_QUANSHI0_RESULT 256'hbd03ac1428f0ea86f4b83a731ffc7967bb82866d8545322f888d2f6e857ffc18

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
    //wire [31:0]  digest;
    wire [7:0]  digest;
    wire output_enable;

    // temp 
    reg [7:0] tmp;
    reg [255:0] result;
    reg flag;
    //integer i;

//data:00000000000000000000000000000000000000000000000000000000(0 ASCII:8'h30)
//加密后：bd03ac1428f0ea86f4b83a731ffc7967bb82866d8545322f888d2f6e857ffc18
//需要加密的内容是56个0，长度为448位，刚好模512余448，所以被补全，补全到448+512位，补全第一位为1，其余位为0。
//因为448位二进制表示为111000000，所以最后再加补全64位，64位开始为0，结尾为111000000
    initial begin
        // Inputs
        // two blocks
        result <=`SHA_QUANSHI0_RESULT;
        flag<=0;
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

    always@(posedge clk)
    if(output_enable == 1'b0)
    begin
        flag <= 1'b0;
    end
    else
    if(output_enable == 1'b1)
        if(flag == 1'b0)
        begin
            flag <= 1'b1;
        end
        else 
        begin
        tmp = result[32*8-1:31*8];
        //tmp = result[(8-i)*32-1:(7-i)*32];
        if(digest==tmp)
            begin
                $display("OK! Expected %x. Got %x.",tmp,digest);
                //flag <= 1'b1;
            end
        else
            begin
                $display("ERROR! Expected %x. Got %x.",tmp,digest);
                //flag <= 1'b0;
            end
        result = result << 8;
//        case(flag)
//            3'b000: flag => 3'b001;
//            3'b001: flag <= 3'b010;
//            3'b010: flag <= 3'b011;
//            3'b011: flag <= 3'b100;
//            3'b100: flag <= 3'b101;
//            3'b101: flag <= 3'b110;
//            3'b110: flag <= 3'b111;
//            3'b111: flag <= 3'b000;
//        endcase
        end
        
            

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