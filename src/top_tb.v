`timescale 1ns / 1ps

`define SHA_QUANSHI0_RESULT 256'hbd03ac1428f0ea86f4b83a731ffc7967bb82866d8545322f888d2f6e857ffc18

module top_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [7:0] data;
    reg write_enable;
    reg  last_block;
    reg first_block;

    // Outputs
    wire busy;
    wire [3:0]  digest;
    wire output_valid;

    // temp 
    reg [3:0] tmp;
    reg [255:0] result;


//data:00000000000000000000000000000000000000000000000000000000(0 ASCII:8'h30)
//加密后：bd03ac1428f0ea86f4b83a731ffc7967bb82866d8545322f888d2f6e857ffc18
//需要加密的内容是56个0，长度为448位，刚好模512余448，所以被补全，补全到448+512位，补全第一位为1，其余位为0。
//因为448位二进制表示为111000000，所以最后再加补全64位，64位开始为0，结尾为111000000
    initial 
    begin
        // Inputs
        // two blocks
        result <=`SHA_QUANSHI0_RESULT;
        clk<=1'b1;
        reset<=1'b1;
        data<=8'b0;
        last_block<=1'b0;
        first_block<=1'b0;
        write_enable<=1'b0;

//=========================signal begins here=============================
        #8
        // 0 cycle
            reset<=1'b0;
            first_block<=1'b1;
        #8    
        // 1st cycle
            write_enable<=1'b1;
            data<=8'h30;
        #8
        // the data input begins
        // 2nd-56th cycle
            first_block<=1'b0; 
        #440       
        // 57th cycle
            data<=8'h80; 
        #8    
        // 58th-64th cycle
            data<=8'b00;
        #56    
        // 65th cycle
            write_enable<=1'b0;
        #8
        // 66th cycle
            last_block<=1'b1;  
            write_enable<=1'b1; 
        #8    
        // 67th-127th cycle
            last_block<=1'b0;
        #488       
        // 128th cycle 
            data<=8'h01;
        #8
        // 129th cycle
            data<=8'hc0;
        #8
        // 130th cycle
            write_enable<=1'b0; 
            data<=8'b0;
    end

    always #4 clk=~clk;

    always@(negedge clk)
    if(output_valid == 1'b0)
        begin
        
        end
    else 
        begin
        tmp = result[64*4-1:63*4];
        if(digest==tmp)
            begin
                $display("OK! Expected %x. Got %x.",tmp,digest);
            end
        else
            begin
                $display("ERROR! Expected %x. Got %x.",tmp,digest);
            end
        result = result << 4;
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
        .output_valid(output_valid)
    );
    
endmodule