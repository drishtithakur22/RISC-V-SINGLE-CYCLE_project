
module alu (
    input  logic [31:0] operand_a,
    input  logic [31:0] operand_b,
    input  logic [3:0]  alu_control,
    output logic [31:0] alu_result,
    output logic        zero
);

    always_comb begin
        case (alu_control)
            4'b0000: alu_result = operand_a + operand_b; 
            4'b0001: alu_result = operand_a - operand_b;
            4'b0010: alu_result = operand_a & operand_b;
            4'b0011: alu_result = operand_a | operand_b;
            4'b0100: alu_result = operand_a ^ operand_b;
            4'b0101: alu_result = operand_a << operand_b[4:0];
            4'b0110: alu_result = operand_a >> operand_b[4:0];
            4'b0111: alu_result = $signed(operand_a) >>> operand_b[4:0];
            4'b1000: alu_result =
                ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0;
            4'b1001: alu_result =
                (operand_a < operand_b) ? 32'd1 : 32'd0;
            default: alu_result = 32'b0;
        endcase

        zero = (alu_result == 32'b0);
    end

endmodule
