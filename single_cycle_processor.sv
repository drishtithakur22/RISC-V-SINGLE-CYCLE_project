
module single_cycle_processor (
    input  logic        clk,
    input  logic        reset,

    output logic [31:0] pc_out,
    output logic [31:0] instruction
);

    // Internal signals
    logic [31:0] read_data1;
    logic [31:0] read_data2;
    logic [31:0] immediate;

    logic [4:0] rs1, rs2, rd;
    logic [6:0] opcode, funct7;
    logic [2:0] funct3;

    logic reg_write;
    logic [2:0] imm_src;
    logic alu_src;
    logic mem_write;
    logic [1:0] result_src;
    logic branch, jump;
    logic [1:0] alu_op;

    logic [3:0] alu_control;
    logic [31:0] alu_operand_a;
    logic [31:0] alu_result;
    logic zero;

    logic [31:0] memory_read_data;
    logic [31:0] writeback_data;

    logic [31:0] next_pc;
    logic [31:0] pc_plus4;
    logic [31:0] branch_target;
    logic [31:0] jalr_target;

    logic branch_taken;

    // 1. Instruction Fetch
    if_stage fetch_stage (
        .clk         (clk),
        .reset       (reset),
        .next_pc     (next_pc),
        .pc_out      (pc_out),
        .instruction (instruction)
    );

    assign pc_plus4 = pc_out + 32'd4;

    // 2. Instruction Decode and Register File
    id_stage decode_stage (
        .clk         (clk),
        .rst         (reset),
        .instruction (instruction),

        .reg_write   (reg_write),
        .wb_rd       (rd),
        .wb_data     (writeback_data),

        .read_data1  (read_data1),
        .read_data2  (read_data2),
        .immediate   (immediate),

        .rs1         (rs1),
        .rs2         (rs2),
        .rd          (rd),
        .opcode      (opcode),
        .funct3      (funct3),
        .funct7      (funct7)
    );

    // 3. Main Control Unit
    main_control_unit control_unit (
        .opcode      (opcode),
        .reg_write   (reg_write),
        .imm_src     (imm_src),
        .alu_src     (alu_src),
        .mem_write   (mem_write),
        .result_src  (result_src),
        .branch      (branch),
        .jump        (jump),
        .alu_op      (alu_op)
    );

    // 4. ALU Decoder
    alu_decoder alu_control_unit (
        .alu_op      (alu_op),
        .opcode      (opcode),
        .funct3      (funct3),
        .funct7      (funct7),
        .alu_control (alu_control)
    );

    // AUIPC uses PC as the first ALU operand
    assign alu_operand_a =
        (opcode == 7'b0010111) ? pc_out : read_data1;

    // 5. Execute Stage
    ex_stage execute_stage (
        .operand_a   (alu_operand_a),
        .operand_b   (read_data2),
        .immediate   (immediate),
        .alu_src     (alu_src),
        .alu_control (alu_control),
        .alu_result  (alu_result),
        .zero        (zero)
    );

    // 6. Data Memory
    data_memory data_mem (
        .clk        (clk),
        .mem_write  (mem_write),
        .address    (alu_result),
        .write_data (read_data2),
        .read_data  (memory_read_data)
    );

    // 7. Write-back Selection
    always_comb begin
        case (result_src)
            2'b00: writeback_data = alu_result;
            2'b01: writeback_data = memory_read_data;
            2'b10: writeback_data = pc_plus4;
            default: writeback_data = 32'b0;
        endcase
    end

    // 8. Branch Decision
    always_comb begin
        branch_taken = 1'b0;

        if (branch) begin
            case (funct3)
                3'b000: branch_taken = zero;             // BEQ
                3'b001: branch_taken = !zero;            // BNE
                3'b100: branch_taken = alu_result[0];    // BLT
                3'b101: branch_taken = !alu_result[0];   // BGE
                3'b110: branch_taken = alu_result[0];    // BLTU
                3'b111: branch_taken = !alu_result[0];   // BGEU
                default: branch_taken = 1'b0;
            endcase
        end
    end

    // 9. Branch and Jump Targets
    assign branch_target = pc_out + immediate;

    assign jalr_target =
        (read_data1 + immediate) & 32'hFFFFFFFE;

    // 10. Next PC Selection
    always_comb begin
        next_pc = pc_plus4;

        if (opcode == 7'b1100111) begin
            next_pc = jalr_target;
        end
        else if (jump) begin
            next_pc = branch_target;
        end
        else if (branch_taken) begin
            next_pc = branch_target;
        end
    end

endmodule
