module uart_top (
    input clk,
    input reset,
    input [7:0] data_in,
    input [1:0] baud_sel,
    output [7:0] out_rx,
    output [10:0] out_tx
);

wire intx, inrx;
wire [10:0] tx_line;

baud_generator u_baud_gen (
    .clk(clk),
    .reset(reset),
    .baud_sel(baud_sel),
    .intx(intx),
    .inrx(inrx)
);

transmitter u_transmitter (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .intx(intx),
    .out_tx(tx_line)
);

receiver u_receiver (
    .clk(clk),
    .reset(reset),
    .out_tx(tx_line),
    .inrx(inrx),
    .out_rx(out_rx)
);

// Output to observe
assign out_tx = tx_line;

endmodule
