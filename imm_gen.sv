
module imm_gen (
    input  logic [31:0] instr,
    input  logic [2:0]  imm_src,
    output logic [31:0] imm_ext
);

    always_comb begin
        case (imm_src)

            // I-type: ADDI, loads, JALR
            3'b000: begin
                imm_ext = {{20{instr[31]}}, instr[31:20]};
            end

            // S-type: stores
            3'b001: begin
                imm_ext = {{20{instr[31]}},
                           instr[31:25], instr[11:7]};
            end

            // B-type: conditional branches
            3'b010: begin
                imm_ext = {{19{instr[31]}}, instr[31],
                           instr[7], instr[30:25],
                           instr[11:8], 1'b0};
            end

            // U-type: LUI, AUIPC
            3'b011: begin
                imm_ext = {instr[31:12], 12'b0};
            end

            // J-type: JAL
            3'b100: begin
                imm_ext = {{11{instr[31]}}, instr[31],
                           instr[19:12], instr[20],
                           instr[30:21], 1'b0};
            end

            default: begin
                imm_ext = 32'b0;
            end

        endcase
    end

endmodule
