module fifo(
     din_a, // Input data bus used when writing the FIFO
     wen_a, // Write enable signal
     clk_a, // Clock signal for writing operation
     dout_b, // Output data bus used when reading from the FIFO
     ren_b, // Read enable signal
     clk_b, // Clock signal for reading operation
     rst, // Active high synchronous reset signal
     full, // Full flag signal
     empty // Empty flag signal
);

parameter FIFO_WIDTH = 16; // Data width
parameter FIFO_DEPTH = 512; // FIFO depth

input wire [FIFO_WIDTH-1:0] din_a; // Input data bus used when writing the FIFO
    input wire wen_a; // Write enable signal
    input wire clk_a; // Clock signal for writing operation
    output reg [FIFO_WIDTH-1:0] dout_b; // Output data bus used when reading from the FIFO
    input wire ren_b; // Read enable signal
    input wire clk_b; // Clock signal for reading operation
    input wire rst; // Active high synchronous reset signal
    output reg full; // Full flag signal
    output reg empty; // Empty flag signal

reg [FIFO_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];
reg [FIFO_WIDTH-1:0] read_pointer;
reg [FIFO_WIDTH-1:0] write_pointer;

always @(posedge clk_a) begin
    if (rst) begin
        read_pointer <= 0;
        write_pointer <= 0;
        full <= 0;
        empty <= 1;
    end else begin
        // Write operation
        if (wen_a && !full) begin
            fifo[write_pointer] <= din_a;
            write_pointer <= write_pointer + 1;
            if (write_pointer == FIFO_DEPTH-1)
                write_pointer <= 0;
            if (write_pointer == read_pointer)
                full <= 1;
            empty <= 0;
        end
    end
end

always @(posedge clk_b) begin
    if (rst) begin
        read_pointer <= 0;
        write_pointer <= 0;
        full <= 0;
        empty <= 1;
    end else begin
        // Read operation
        if (ren_b && !empty) begin
            dout_b <= fifo[read_pointer];
            read_pointer <= read_pointer + 1;
            if (read_pointer == FIFO_DEPTH-1)
                read_pointer <= 0;
            if (read_pointer == write_pointer)
                empty <= 1;
            full <= 0;
        end
    end
end

endmodule




/*module fifo(
    din_a,wen_a,ren_b,clk_a,clk_b,rst,data_out,full,empty
);

parameter FIFO_WIDTH = 16 ;
parameter FIFO_DEPTH = 512;

input [FIFO_WIDTH-1:0]din_a;
input wen_a,ren_b,clk_a,clk_b,rst;
output  [FIFO_WIDTH-1:0] data_out;
output reg full,empty ;

reg [FIFO_DEPTH-1:0] Wpointer;
reg [FIFO_DEPTH-1:0] Rpointer;
reg [FIFO_DEPTH-1:0] next_Wpointer;
reg [FIFO_DEPTH-1:0] next_Rpointer;
reg [FIFO_WIDTH-1:0] dout_b;


reg [FIFO_WIDTH-1:0] fifo [FIFO_DEPTH-1:0];

always @(posedge clk_a) begin
    if (rst) begin
        dout_b <= 0;
        Wpointer <=0;
        Rpointer <=0;
        full <=0;
        empty <=1;
    end
    else begin
        if(wen_a && !full)begin
            fifo[Wpointer] <= din_a;
            Wpointer <= next_Wpointer;
        end
    end
end

always @(posedge clk_b) begin
    /*if (rst) begin
        //dout_b <= 0;
        //Wpointer <=0;
        //Rpointer <=0;
        full <=0;
        empty <=1;
    end
        if(ren_b && !empty)begin
            dout_b <= fifo[Wpointer] ;
            Rpointer <= next_Rpointer;
        end
end

always @(*) begin
    next_Wpointer = Wpointer +1;
    next_Rpointer = Rpointer +1;
    if(next_Rpointer == FIFO_DEPTH) next_Rpointer = 0;
    if(next_Wpointer == FIFO_DEPTH) next_Wpointer = 0;
end

always @(*) begin
    if (Wpointer == next_Wpointer) full = 1;
    //else full = 0;
    if (Rpointer == next_Rpointer) empty = 1;
    //else empty = 0;
end
assign data_out = dout_b;
endmodule*/