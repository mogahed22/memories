module SPSRAM_tb();

    parameter MEM_WIDTH = 16 ;
    parameter MEM_DEPTH = 1024;
    parameter ADDR_SIZE = 10;
    parameter ADDR_PIPELINE = "FALSE";
    parameter DOUT_PIPELINE = "TRUE";
    parameter PARITY_ENABLE = 1;

    reg [MEM_WIDTH-1:0] din;
    reg [ADDR_SIZE-1:0] addr;
    reg wr_en , rd_en , blk_select , addr_en, dout_en ,clk , rst;

    wire [MEM_WIDTH-1:0] dout_out;
    wire parity_out;

    SPSRAM tb (din,addr,wr_en,rd_en,blk_select,addr_en,dout_en,dout_out,parity_out,clk,rst);

    initial begin
        clk=0;
        forever begin
            #1 clk = ~clk;
        end
    end

    initial begin
        $readmemb("random_data.dat",tb.RAM);
        rst = 1;
        blk_select = 0;
        addr_en=0;
        dout_en = 0;
        #4;
        rst = 0;
        blk_select = 1;
        addr_en = 1;
        dout_en =1;
        //check write operation
        rd_en = 0;
        wr_en = 1;
        repeat (200) begin
            din = $random;
            addr = $random;
            @(negedge clk);
        end
        //check read operation
        wr_en = 0;
        rd_en = 1;
        repeat (200) begin
            addr = $random;
            @(negedge clk);
        end
        $stop;
    end

endmodule 