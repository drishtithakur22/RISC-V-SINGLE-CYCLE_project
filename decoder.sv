module decode_unit (
    input  logic [31:0] instr,
    
    // Core instruction fields
    output logic [6:0]  opcode,
    output logic [4:0]  rd,
    output logic [2:0]  funct3,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [6:0]  funct7,
    
    // Explicit raw immediate fragments for all types
    output logic [11:0] imm_i_raw,  
    output logic [11:0] imm_s_raw,  
    output logic [12:1] imm_b_raw,  
    output logic [31:12] imm_u_raw, 
    output logic [20:1] imm_j_raw   
);

    // 1. Extract Core Fields 
    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    assign funct7 = instr[31:25];

    // 2. I-Type Immediate 
    assign imm_i_raw = instr[31:20];

    // 3. S-Type Immediate 
    assign imm_s_raw = {instr[31:25], instr[11:7]};

    // 4. B-Type Immediate 
    assign imm_b_raw = {instr[31], instr[7], instr[30:25], instr[11:8]};

    // 5. U-Type Immediate 
    assign imm_u_raw = instr[31:12];

    // 6. J-Type Immediate 
    assign imm_j_raw = {instr[31], instr[19:12], instr[20], instr[30:21]};

endmodule