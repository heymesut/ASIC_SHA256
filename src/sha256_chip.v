module sha256_chip(clk,reset,data,write_enable,last_block,first_block,busy,digest,output_valid);

input wire  clk,reset;
input wire  [7:0] data;
input wire  write_enable;
input wire  last_block;
input wire  first_block;

output wire  busy;
output wire  [3:0] digest;
output wire  output_valid;

wire net_clk,net_reset;
wire [7:0] net_data;
wire net_write_enable,net_last_block,net_first_block;
wire net_busy;
wire [3:0] net_digest;
wire net_output_valid;

PIW
        PIW_clk(.PAD(clk),.C(net_clk)),
        PIW_reset(.PAD(reset),.C(net_reset)),
        PIW_data0(.PAD(data[0]),.C(net_data[0])),
        PIW_data1(.PAD(data[1]),.C(net_data[1])),
        PIW_data2(.PAD(data[2]),.C(net_data[2])),
        PIW_data3(.PAD(data[3]),.C(net_data[3])),
        PIW_data4(.PAD(data[4]),.C(net_data[4])),
        PIW_data5(.PAD(data[5]),.C(net_data[5])),
        PIW_data6(.PAD(data[6]),.C(net_data[6])),
        PIW_data7(.PAD(data[7]),.C(net_data[7])),
        PIW_write_enable(.PAD(write_enable),.C(net_write_enable)),
        PIW_last_block(.PAD(last_block),.C(net_last_block)),
        PIW_first_block(.PAD(first_block),.C(net_first_block));

PO8W
        PO8W_busy(.I(net_busy),.PAD(busy)),
        PO8W_digest0(.I(net_digest[0]),.PAD(digest[0])),
        PO8W_digest1(.I(net_digest[1]),.PAD(digest[1])),
        PO8W_digest2(.I(net_digest[2]),.PAD(digest[2])),
        PO8W_digest3(.I(net_digest[3]),.PAD(digest[3])),
        PO8W_output_valid(.I(net_output_valid),.PAD(output_valid));

top inst_top(.clk(net_clk),.reset(net_reset),.data(net_data),.write_enable(net_write_enable),.first_block(net_first_block),.last_block(net_last_block),.busy(net_busy),.digest(net_digest),.output_valid(net_output_valid));

endmodule
