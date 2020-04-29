`timescale 1ns / 1ps

`define SHA_56GE0_RESULT 256'hbd03ac1428f0ea86f4b83a731ffc7967bb82866d8545322f888d2f6e857ffc18
`define SHA_120GE0_RESULT 256'h09719c55365a950c92a06122b6ce2634e3ce9b6dbcde1827171941658c7eedab

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
    reg [255:0] result1;
    reg [255:0] result2;
    reg checktime;
    reg [7:0] count;


//data:00000000000000000000000000000000000000000000000000000000(0 ASCII:8'h30)
//加密后：bd03ac1428f0ea86f4b83a731ffc7967bb82866d8545322f888d2f6e857ffc18
//需要加密的内容是56个0，长度为448位，刚好模512余448，所以被补全，补全到448+512位，补全第一位为1，其余位为0
//因为448位二进制表示为111000000，所以最后再加补全64位，64位开始为0，结尾为111000000

//data:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
//加密后：09719c55365a950c92a06122b6ce2634e3ce9b6dbcde1827171941658c7eedab
//第二次加密内容56+64个0，长度为448+512位，模512余448，所以被补全到448+512+512位，补全第一位为1，其余位为0
//因为448+512位二进制表示为1111000000，所以最后再加补全的64位，64位开始为0，结尾为1111000000
    initial 
    begin
        // Inputs
        // two blocks
        result1 <=`SHA_56GE0_RESULT;
        result2 <=`SHA_120GE0_RESULT;
        clk<=1'b1;
        reset<=1'b1;
        data<=8'b0;
        last_block<=1'b0;
        first_block<=1'b0;
        write_enable<=1'b0;
        checktime<=1'b0;

//=========================signal begins here=============================
        #8
        // 0 cycle
            reset<=1'b0;
            first_block<=1'b1;
        #8    
        // first block begins
        // 1st cycle
            write_enable<=1'b1;
            data<=8'h30;
        #8
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
            data<=8'h00;
        #520 // 1*65cycle, input when output
        #8
        #8
            first_block<=1'b1;
        #8
        // second check
        // 131st cycle(1st)
            write_enable<=1'b1;
            data<=8'h30;
        #8
        // 132nd-194th cycle(2nd-64th)
            first_block<=1'b0;
        #504
        // 195th cycle(65th)
            write_enable<=1'b0;
        #8
        // 196th-251st cycle(66th-121st)
            write_enable<=1'b1;
        #448
        // 252nd cycle(122nd)
            data<=8'h80;
        #8
        // 253th-259th cycle(123th-129th)
            data<=8'h00;
        #56
        // 260th cycle(130th)
            write_enable<=1'b0;
        #8
        // 261st cycle(131st)
            last_block<=1'b1;
        #8
        // 262nd-322nd cycle(132nd-192nd)
            last_block<=1'b0;
            write_enable<=1'b1;
        #488
        // 323th cycle(193th)
            data<=8'h03;
        #8
        // 324th cycle(194th)
            data<=8'hc0;
        #8
        // 325th cycle(195th)
            write_enable<=1'b0;
            data<=8'h00;
    end

    always #4 clk=~clk;

    always@(negedge clk)
    if(output_valid == 1'b0)
        begin
            count=8'b0;
        end
    else 
        if(checktime == 1'b0)
            begin
                tmp = result1[64*4-1:63*4];
                if(digest==tmp)
                    begin
                        $display("Check1, OK! Expected %x. Got %x.",tmp,digest);
                    end
                else
                    begin
                        $display("Check1, ERROR! Expected %x. Got %x.",tmp,digest);
                    end
                result1 = result1 << 4;
                count = count+1;
                if(count == 8'b01000000)
                    begin
                        checktime = 1'b1;
                    end
            end
        else 
            begin
                tmp = result2[64*4-1:63*4];
                if(digest==tmp)
                    begin
                        $display("Check2, OK! Expected %x. Got %x.",tmp,digest);
                    end
                else
                    begin
                        $display("Check2, ERROR! Expected %x. Got %x.",tmp,digest);
                    end
                result2 = result2 << 4;
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