module main_control_unit (
    input  logic [6:0] opcode,
    output logic       reg_write,
    output logic [2:0] imm_src,
    output logic       alu_src,    // 0: rs2, 1: imm
    output logic       mem_write,
    output logic [1:0] result_src, // 00: ALU, 01: Mem, 10: PC+4 (for JAL/JALR)
    output logic       branch,
    output logic       jump,
    output logic [1:0] alu_op
);

    always_comb begin
        // Default assignments to prevent hardware latches
        reg_write  = 1'b0;
        imm_src    = 3'b000;
        alu_src    = 1'b0;
        mem_write  = 1'b0;
        result_src = 2'b00;
        branch     = 1'b0;
        jump       = 1'b0;
        alu_op     = 2'b00;

        case (opcode)
            7'b0110011: begin // R-Type (ADD, SUB, AND, OR, etc.)
                reg_write = 1'b1;
                alu_op    = 2'b10;
            end
            
            7'b0010011: begin // I-Type ALU (addi, andi, ori, etc.)
                reg_write = 1'b1;
                imm_src   = 3'b000; 
                alu_src   = 1'b1;
                alu_op    = 2'b10;
            end
            
            7'b0000011: begin // I-Type Load (lw, lb, lh, etc.)
                reg_write  = 1'b1;
                imm_src    = 3'b000; 
                alu_src    = 1'b1;
                result_src = 2'b01;  
                alu_op     = 2'b00;  
            end
            
            7'b0100011: begin // S-Type Store (sw, sb, sh)
                imm_src   = 3'b001; 
                alu_src   = 1'b1;
                mem_write = 1'b1;
                alu_op    = 2'b00;  
            end
            
            7'b1100011: begin // B-Type Branch (beq, bne, blt, etc.)
                imm_src = 3'b010; 
                branch  = 1'b1;
                alu_op  = 2'b01; 
            end

            7'b1101111: begin // J-Type (jal)
                reg_write  = 1'b1;
                imm_src    = 3'b100;
                jump       = 1'b1;
                result_src = 2'b10; // Save PC+4 to rd
            end

            7'b1100111: begin // I-Type (jalr)
                reg_write  = 1'b1;
                imm_src    = 3'b000;
                jump       = 1'b1;
                result_src = 2'b10; // Save PC+4 to rd
            end

            7'b0110111: begin // U-Type (lui)
                reg_write = 1'b1;
                imm_src   = 3'b011;
                alu_src   = 1'b1;
                alu_op    = 2'b11; // ALU passes imm directly
            end

            7'b0010111: begin // U-Type (auipc)
                reg_write = 1'b1;
                imm_src   = 3'b011;
                alu_src   = 1'b1; // Requires ALU to add PC + imm (wiring handled in top module)
                alu_op    = 2'b00; 
            end
            
            default: ; 
        endcase
     end
     endmodule