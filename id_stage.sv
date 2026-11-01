
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

    logic [2:0] imm_src;

    // Decode instruction fields
    decode_unit decoder (
        .instr       (instruction),
        .opcode      (opcode),
        .rd          (rd),
        .funct3      (funct3),
        .rs1         (rs1),
        .rs2         (rs2),
        .funct7      (funct7),
        .imm_i_raw   (),
        .imm_s_raw   (),
        .imm_b_raw   (),
        .imm_u_raw   (),
        .imm_j_raw   ()
    );

    // Select immediate format
    always_comb begin
        case (opcode)
            7'b0010011,
            7'b0000011,
            7'b1100111: imm_src = 3'b000;

            7'b0100011: imm_src = 3'b001;
            7'b1100011: imm_src = 3'b010;

            7'b0110111,
            7'b0010111: imm_src = 3'b011;

            7'b1101111: imm_src = 3'b100;

            default: imm_src = 3'b000;
        endcase
    end

    // Generate sign-extended immediate
    imm_gen immediate_generator (
        .instr   (instruction),
        .imm_src (imm_src),
        .imm_ext (immediate)
    );

    // Register file
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
