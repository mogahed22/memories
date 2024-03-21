module SPSRAM(din,addr,wr_en,rd_en,blk_select,addr_en,dout_en,dout_out,parity_out,clk,rst);
    
    parameter MEM_WIDTH = 16 ;
    parameter MEM_DEPTH = 1024;
    parameter ADDR_SIZE = 10;
    parameter ADDR_PIPELINE = "FALSE";
    parameter DOUT_PIPELINE = "TRUE";
    parameter PARITY_ENABLE = 1;

    input [MEM_WIDTH-1:0] din;
    input [ADDR_SIZE-1:0] addr;
    input wr_en , rd_en , blk_select , addr_en, dout_en ,clk , rst;

    output reg [MEM_WIDTH-1:0] dout_out;
    output reg parity_out;
    
    reg [MEM_WIDTH-1:0]addr_pip;
    reg [MEM_WIDTH-1:0] dout_pip;
    reg [MEM_WIDTH-1:0] addr_in;
    reg [MEM_WIDTH-1:0] dout;

    reg [MEM_WIDTH-1:0] RAM [MEM_DEPTH-1:0];

    always @(posedge clk) begin
        if(addr_en) addr_pip <= addr;
        if(dout_en) dout_pip <= dout; 
    end

    always @(posedge clk) begin
        if(ADDR_PIPELINE == "FALSE") addr_in <=addr;
        else addr_in <= addr_pip;
        if(DOUT_PIPELINE == "FALSE") dout_out <= dout;
        else dout_out <= dout_pip;
    end

    always @(posedge clk) begin
        if(rst) dout <= 0;
        else begin
            if(blk_select) begin
                if(wr_en) RAM[addr_in] <= din;
                else if (rd_en) dout <= RAM[addr_in];
                if(PARITY_ENABLE) begin
                    if((^dout)) parity_out <= 1;
                    else parity_out <= 0; 
                end
                else if (!PARITY_ENABLE) parity_out <= 0;
            end
        end
    end

    // assign addr_in = (ADDR_PIPELINE == "FALSE")? addr : addr_pip ;
    // assign dout_out = (DOUT_PIPELINE == "FALSE")? dout : dout_pip ; 

endmodule