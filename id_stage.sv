
module id_stage (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] instruction,

    input  logic        reg_write,
    input  logic [4:0]  wb_rd,
    input  logic [31:0] wb_data,

    output logic [31:0] read_data1,
    output logic [31:0] read_data2,

    output logic [31:0] immediate,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,
    output logic [6:0]  opcode,
    output logic [2:0]  funct3,
    output logic [6:0]  funct7
);

    logic [31:0] imm;

    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

    always_comb begin
        case (opcode)
            7'b0010011,
            7'b0000011,
            7'b1100111: begin
                imm = {{20{instruction[31]}}, instruction[31:20]};
            end

            7'b0100011: begin
                imm = {{20{instruction[31]}},
                       instruction[31:25], instruction[11:7]};
            end

            7'b1100011: begin
                imm = {{19{instruction[31]}}, instruction[31],
                       instruction[7], instruction[30:25],
                       instruction[11:8], 1'b0};
            end

            7'b0110111,
            7'b0010111: begin
                imm = {instruction[31:12], 12'b0};
            end

            7'b1101111: begin
                imm = {{11{instruction[31]}}, instruction[31],
                       instruction[19:12], instruction[20],
                       instruction[30:21], 1'b0};
            end

            default: begin
                imm = 32'b0;
            end
        endcase
    end

    assign immediate = imm;

    register_file rf (
        .clk        (clk),
        .reset      (rst),
        .reg_write  (reg_write),
        .rs1        (rs1),
        .rs2        (rs2),
        .rd         (wb_rd),
        .write_data (wb_data),
        .read_data1 (read_data1),
        .read_data2 (read_data2)
    );

endmodule
