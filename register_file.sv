
module register_file (
    input  logic        clk,
    input  logic        reset,
    input  logic        reg_write,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] write_data,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);

    logic [31:0] registers [0:31];
    integer i;

    always_ff @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end
        else if (reg_write && (rd != 5'd0)) begin
            registers[rd] <= write_data;
        end
    end

    always_comb begin
        read_data1 = (rs1 == 5'd0) ? 32'b0 : registers[rs1];
        read_data2 = (rs2 == 5'd0) ? 32'b0 : registers[rs2];
    end

endmodule
