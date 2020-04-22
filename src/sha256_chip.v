module sha256_chip(clk,reset,data,write_enable,last_block,first_block,busy,digest,output_enable);

input wire  clk,reset;
input wire  [31:0] data;
input wire  write_enable;
input wire  last_block;
input wire  first_block;

output wire  busy;
output wire  [7:0] digest;
output wire  output_enable;

wire net_clk,net_reset;
wire [31:0] net_data;
wire net_write_enable,net_last_block,net_first_block;
wire net_busy;
wire [7:0] net_digest;
wire net_output_enable;

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
        PIW_data8(.PAD(data[8]),.C(net_data[8])),
        PIW_data9(.PAD(data[9]),.C(net_data[9])),
        PIW_data10(.PAD(data[10]),.C(net_data[10])),
        PIW_data11(.PAD(data[11]),.C(net_data[11])),
        PIW_data12(.PAD(data[12]),.C(net_data[12])),
        PIW_data13(.PAD(data[13]),.C(net_data[13])),
        PIW_data14(.PAD(data[14]),.C(net_data[14])),
        PIW_data15(.PAD(data[15]),.C(net_data[15])),
        PIW_data16(.PAD(data[16]),.C(net_data[16])),
        PIW_data17(.PAD(data[17]),.C(net_data[17])),
        PIW_data18(.PAD(data[18]),.C(net_data[18])),
        PIW_data19(.PAD(data[19]),.C(net_data[19])),
        PIW_data20(.PAD(data[20]),.C(net_data[20])),
        PIW_data21(.PAD(data[21]),.C(net_data[21])),
        PIW_data22(.PAD(data[22]),.C(net_data[22])),
        PIW_data23(.PAD(data[23]),.C(net_data[23])),
        PIW_data24(.PAD(data[24]),.C(net_data[24])),
        PIW_data25(.PAD(data[25]),.C(net_data[25])),
        PIW_data26(.PAD(data[26]),.C(net_data[26])),
        PIW_data27(.PAD(data[27]),.C(net_data[27])),
        PIW_data28(.PAD(data[28]),.C(net_data[28])),
        PIW_data29(.PAD(data[29]),.C(net_data[29])),
        PIW_data30(.PAD(data[30]),.C(net_data[30])),
        PIW_data31(.PAD(data[31]),.C(net_data[31])),
        PIW_write_enable(.PAD(write_enable),.C(net_write_enable)),
        PIW_last_block(.PAD(last_block),.C(net_last_block)),
        PIW_first_block(.PAD(first_block),.C(net_first_block));

PO8W
        PO8W_busy(.I(net_busy),.PAD(busy)),
        PO8W_digest0(.I(net_digest[0]),.PAD(digest[0])),
        PO8W_digest1(.I(net_digest[1]),.PAD(digest[1])),
        PO8W_digest2(.I(net_digest[2]),.PAD(digest[2])),
        PO8W_digest3(.I(net_digest[3]),.PAD(digest[3])),
        PO8W_digest4(.I(net_digest[4]),.PAD(digest[4])),
        PO8W_digest5(.I(net_digest[5]),.PAD(digest[5])),
        PO8W_digest6(.I(net_digest[6]),.PAD(digest[6])),
        PO8W_digest7(.I(net_digest[7]),.PAD(digest[7])),
        PO8W_output_enable(.I(net_output_enable),.PAD(output_enable));

top inst_top(.clk(net_clk),.reset(net_reset),.data(net_data),.write_enable(net_write_enable),.first_block(net_first_block),.last_block(net_last_block),.busy(net_busy),.digest(net_digest),.output_enable(net_output_enable));

endmodule
