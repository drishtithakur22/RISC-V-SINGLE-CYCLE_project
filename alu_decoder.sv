
module alu_decoder (
    input  logic [1:0] alu_op,
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic [3:0] alu_control
);

    always_comb begin
        case (alu_op)

            // Loads, stores and AUIPC: addition
            2'b00: alu_control = 4'b0000;

            // Branch comparisons
            2'b01: begin
                case (funct3)
                    3'b000,
                    3'b001: alu_control = 4'b0001; // BEQ, BNE
                    3'b100,
                    3'b101: alu_control = 4'b1000; // BLT, BGE
                    3'b110,
                    3'b111: alu_control = 4'b1001; // BLTU, BGEU
                    default: alu_control = 4'b0001;
                endcase
            end

            // R-type and I-type arithmetic/logical instructions
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if ((opcode == 7'b0110011) &&
                            (funct7[5] == 1'b1))
                            alu_control = 4'b0001; // SUB
                        else
                            alu_control = 4'b0000; // ADD / ADDI
                    end

                    3'b001: alu_control = 4'b0101; // SLL / SLLI
                    3'b010: alu_control = 4'b1000; // SLT / SLTI
                    3'b011: alu_control = 4'b1001; // SLTU / SLTIU
                    3'b100: alu_control = 4'b0100; // XOR / XORI

                    3'b101: begin
                        if (funct7[5])
                            alu_control = 4'b0111; // SRA / SRAI
                        else
                            alu_control = 4'b0110; // SRL / SRLI
                    end

                    3'b110: alu_control = 4'b0011; // OR / ORI
                    3'b111: alu_control = 4'b0010; // AND / ANDI

                    default: alu_control = 4'b0000;
                endcase
            end

            // LUI: pass the immediate through the ALU
            2'b11: alu_control = 4'b1010;

            default: alu_control = 4'b0000;
        endcase
    end

endmodule
