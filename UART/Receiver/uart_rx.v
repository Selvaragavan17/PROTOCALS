module receiver(
    input clk,
    input reset,
    input [10:0] out_tx,
    input inrx,
    output reg [7:0] out_rx
);

reg [3:0] count;
reg [3:0] rx_count;
reg error;
reg [1:0] next_state, state;

parameter idle      = 2'b00;
parameter rx_data   = 2'b01;
parameter rx_parity = 2'b10;
parameter rx_stop   = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 0;
        rx_count <= 0;
        out_rx <= 0;
        state <= idle;
    end else if (inrx) begin
        state <= next_state;

        case (state)
            idle: begin
                if (out_tx[0] == 0) begin
                    count <= 0;
                    rx_count <= 0;
                end
            end
            rx_data: begin
                if (rx_count < 8) begin
                    out_rx[rx_count] <= out_tx[rx_count + 1];
                    rx_count <= rx_count + 1;
                end
            end
            rx_parity: begin
                 if(out_tx[9]!==(^out_rx))
		 error<=1;
	 else
		 error<=0;
                 next_state<= rx_stop;
            end
            rx_stop: begin
                error <= (out_tx[10] != 1);
            end
        endcase
    end
end

always @(*) begin
    case (state)
        idle:      next_state = (out_tx[0] == 0) ? rx_data : idle;
        rx_data:   next_state = (rx_count == 8) ? rx_parity : rx_data;
        rx_parity: next_state = rx_stop;
        rx_stop:   next_state = idle;
        default:   next_state = idle;
    endcase
end

endmodule
