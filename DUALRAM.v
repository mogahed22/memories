module DUALRAM(din,addr_wr,addr_rd,wr_en,rd_en,blk_select,clk,rst,dout);

parameter MEM_WIDTH = 16;
parameter MEM_DEPTH = 1024;
parameter ADDR_SIZE = 10;

input clk , rst , wr_en ,rd_en,blk_select;
input [MEM_WIDTH-1:0] din;
input [ADDR_SIZE-1:0] addr_wr ,addr_rd;
output reg [MEM_WIDTH-1:0] dout;

reg [MEM_WIDTH-1:0] RAM [MEM_DEPTH-1:0];

always @(posedge clk) begin
    if(rst) dout <= 0;
    else begin
        if (blk_select) begin
            if(wr_en) RAM[addr_wr] <= din;
            else if (rd_en) dout <= RAM[addr_rd];
           end
    end
end

endmodule 