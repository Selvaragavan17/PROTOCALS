`timescale 1ns/1ps

module uart_tb;

reg clk;
reg reset;
reg [7:0] data_in;
reg [1:0] baud_sel;
wire [7:0] out_rx;
wire [10:0] out_tx;

uart_top uut (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .baud_sel(baud_sel),
    .out_rx(out_rx),
    .out_tx(out_tx)
);

// Generate clock - 50MHz (20ns period)
always #10 clk = ~clk;

initial begin
    // Initialize
    clk = 0;
    reset = 1;
    data_in = 8'b10101010; //  data
    baud_sel = 2'b01; //  19200 baud rate

    #50 reset = 0;


    #5000 $finish;
end

endmodule
