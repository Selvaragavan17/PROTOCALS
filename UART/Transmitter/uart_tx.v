module transmitter (
    input clk,
    input reset,
    input [7:0] data_in,
    input intx,
    output reg [10:0] out_tx
);

reg [3:0] count;
reg [1:0] parity_sel = 2'b01; 
reg parity;
reg [2:0] next_state, state;
reg [7:0] data_reg;

parameter idle = 3'd0;
parameter tx_start = 3'd1;
parameter tx_data = 3'd2;
parameter tx_parity = 3'd3;
parameter tx_stop = 3'd4;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= idle;
        out_tx <= 11'b11111111111;
        count <= 0;
        data_reg <= 0;
    end else if (intx) begin
        state <= next_state;

        case (state)
            idle: begin
                out_tx <= {10'b1111111111, 1'b0};
                data_reg <= data_in;
                count <= 0;
            end
            tx_start: begin
                out_tx <= {out_tx[9:0], data_reg[0]};
                data_reg <= data_reg >> 1;
                count <= count + 1;
            end
            tx_parity: begin
                case (parity_sel)
                    2'b00: parity = 1'b0;
                    2'b10: parity = ~(^data_in);
                    2'b01: parity = ^data_in;
                    default: parity = 1'b0;
                endcase
                out_tx <= {out_tx[9:0], parity};
            end
            tx_stop: begin
                out_tx <= {out_tx[9:0], 1'b1};
            end
        endcase
    end
end

always @(*) begin
    case (state)
        idle:      next_state = tx_start;
        tx_start:  next_state = (count == 8) ? tx_parity : tx_start;
        tx_parity: next_state = tx_stop;
        tx_stop:   next_state = idle;
        default:   next_state = idle;
    endcase
end

endmodule
