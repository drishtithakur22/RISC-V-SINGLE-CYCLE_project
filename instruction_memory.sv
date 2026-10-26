`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 12:47:50 AM
// Design Name: 
// Module Name: instruction_memory
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






module instruction_memory (
    input  logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] memory [0:15];

    initial begin
        memory[0]  = 32'h00500093; // addi x1, x0, 5
        memory[1]  = 32'h00A00113; // addi x2, x0, 10
        memory[2]  = 32'h002081B3; // add x3, x1, x2
        memory[3]  = 32'h00302023; // sw x3, 0(x0)

        memory[4]  = 32'h00000013; // nop
        memory[5]  = 32'h00000013;
        memory[6]  = 32'h00000013;
        memory[7]  = 32'h00000013;
        memory[8]  = 32'h00000013;
        memory[9]  = 32'h00000013;
        memory[10] = 32'h00000013;
        memory[11] = 32'h00000013;
        memory[12] = 32'h00000013;
        memory[13] = 32'h00000013;
        memory[14] = 32'h00000013;
        memory[15] = 32'h00000013;
    end

    always_comb begin
        if (address < 32'd64)
            instruction = memory[address[5:2]];
        else
            instruction = 32'h00000013;
    end

endmodule

