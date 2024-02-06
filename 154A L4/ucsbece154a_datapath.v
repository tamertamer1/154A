// ucsbece154a_datapath.v
// All Rights Reserved
// Copyright (c) 2023 UCSB ECE
// Distribution Prohibited


module ucsbece154a_datapath (
    input               clk, reset,
    input               RegWrite_i,
    input         [2:0] ImmSrc_i,
    input               ALUSrc_i,
    input               PCSrc_i,
    input         [1:0] ResultSrc_i,
    input         [2:0] ALUControl_i,
    output              zero_o,
    output reg   [31:0] pc_o,
    input        [31:0] instr_i,
    output wire  [31:0] aluresult_o, writedata_o,
    input        [31:0] readdata_i
);

`include "ucsbece154a_defines.vh"

/// Your code here

// Use name "rf" for a register file module so testbench file work properly (or modify testbench file) 
reg [31:0] result_o;
wire [31:0] pc_next, pc_plus4, pc_target, rd1;
reg[31:0] imm_gen;
wire branch_taken;
assign pc_plus4 = pc_o + 4;
reg [31:0] alu_src_b; 
// Immediate Generation
always @(*) begin
	case(ImmSrc_i)
		imm_Itype: imm_gen = {{20{instr_i[31]}},instr_i[31:20]};
		imm_Stype: imm_gen = {{20{instr_i[31]}},instr_i[31:25],instr_i[11:7]};
		imm_Btype: imm_gen = {{19{instr_i[31]}},instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0};
		imm_Jtype: imm_gen = {{12{instr_i[31]}},instr_i[19:12],instr_i[20],instr_i[30:21],1'b0};
		imm_Utype: imm_gen = {instr_i[31:12], 12'b0};
	        default: imm_gen = 32'b0;
	endcase
end

// Register File Access
ucsbece154a_rf rf (
    .clk(clk),
    .a1_i(instr_i[19:15]), // rs1
    .a2_i(instr_i[24:20]), // rs2
    .a3_i(instr_i[11:7]),  // rd
    .rd1_o(rd1),
    .rd2_o(writedata_o),
    .we3_i(RegWrite_i),
    .wd3_i(result_o)
);

// ALU Operations
always @(*) begin
	case (ALUSrc_i)
		ALUSrc_reg: alu_src_b = writedata_o;
		ALUSrc_imm: alu_src_b =  imm_gen;
	endcase
end
ucsbece154a_alu alu (
    .a_i(rd1),
    .b_i(alu_src_b),
    .alucontrol_i(ALUControl_i),
    .result_o(aluresult_o),
    .zero_o(zero_o)
);



//Result ALU
always @(*) begin
	case(ResultSrc_i)
		ResultSrc_ALU: result_o = aluresult_o;
		ResultSrc_load: result_o = readdata_i;
		ResultSrc_jal: result_o = pc_plus4;
	        ResultSrc_lui : result_o = imm_gen;
                default: result_o = 32'b0;
	endcase
end
// Next PC Logic
assign pc_target= imm_gen + pc_o;
reg[31:0] pcout;
always @ (*) begin
    case (PCSrc_i)
        1'b0: pcout = pc_plus4;
        1'b1: pcout = pc_target;
        default: pcout = pc_plus4;
    endcase
end
always @(posedge clk or posedge reset) begin
    if (reset)
        pc_o <= 32'b0;
    else
        pc_o <= pcout;
end
endmodule

