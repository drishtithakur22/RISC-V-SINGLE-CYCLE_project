
module ex_stage (
    input  logic [31:0] operand_a,
    input  logic [31:0] operand_b,
    input  logic [31:0] immediate,
    input  logic        alu_src,
    input  logic [3:0]  alu_control,
    output logic [31:0] alu_result,
    output logic        zero
);

    logic [31:0] alu_operand_b;

    always_comb begin
        if (alu_src)
            alu_operand_b = immediate;
        else
            alu_operand_b = operand_b;
    end

    alu alu_unit (
        .operand_a  (operand_a),
        .operand_b  (alu_operand_b),
        .alu_control(alu_control),
        .alu_result (alu_result),
        .zero       (zero)
    );

endmodule
