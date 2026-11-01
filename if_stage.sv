
module if_stage (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] next_pc,
    output logic [31:0] pc_out,
    output logic [31:0] instruction
);

    pc pc_unit (
        .clk     (clk),
        .reset   (reset),
        .next_pc (next_pc),
        .pc_out  (pc_out)
    );

    instruction_memory imem (
        .address     (pc_out),
        .instruction (instruction)
    );

endmodule
