`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 12:49:50 AM
// Design Name: 
// Module Name: if_stage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




module if_stage (
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] pc_out,
    output logic [31:0] instruction
);

    logic [31:0] next_pc;

    assign next_pc = pc_out + 32'd4;

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
