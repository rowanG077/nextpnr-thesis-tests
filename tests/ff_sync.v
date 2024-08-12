module ff_sync (
    input wire clk_src,
    input wire rst_src,
    input wire clk_dst,
    input wire rst_dst,
    input wire data_in,
    output wire data_out
);
    reg src_ff;
    reg sync_ff1;
    reg sync_ff2;

    always @(posedge clk_src) begin
        if (rst_src) begin
            src_ff <= 1'b0;
        end else begin
            src_ff <= data_in;
        end
    end

    always @(posedge clk_dst) begin
        if (rst_dst) begin
            sync_ff1 <= 1'b0;
            sync_ff2 <= 1'b0;
        end else begin
            sync_ff1 <= src_ff;
            sync_ff2 <= sync_ff1;
        end
    end

    assign data_out = sync_ff2;

endmodule
