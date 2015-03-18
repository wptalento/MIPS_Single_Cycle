`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:13:50 02/28/2015 
// Design Name: 
// Module Name:    processor 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module processor(
	input clk,
	input rst_n,
	input [31:0] data_in,
	input [31:0] inst,
	output reg [31:0] inst_addr,
	output [31:0] data_out,
	output [31:0] data_addr,
	output data_wr
    );
	
	// bookkeeping
	reg [1:0] state;
	
	// writes
	wire Reg_Write;
	wire Mem_Write;
	
	// instruction fetch
	wire [31:0] PC;
	wire [1:0] PC_Src;

	// register file IO
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	wire [4:0] writereg;
	wire [31:0] writedata;
	wire regwrite;
	wire [31:0] readdata1;
	wire [31:0] readdata2;
	
	// register file stuff
	wire [1:0] Reg_Write_Dest_Source;
	wire [1:0] Reg_Write_Data_Source;
	
	assign rs = inst[25:21];
	assign rt = inst[20:16];
	assign rd = inst[15:11];
	
	// register write destination mux
	mux5 mux_writeregdest(rd, rt, 5'b11111, 5'd0, Reg_Write_Dest_Source, writereg);
	
	// ALU IO
	wire [31:0] ALU_A;
	wire [31:0] ALU_B;
	wire [3:0] ALU_Control;
	wire [4:0] shamt;
	wire [31:0] ALU_Output;
	wire zero;
	
	// ALU stuff
	wire [1:0] ALU_A_Source;
	wire [1:0] ALU_B_Source;
	
	wire [31:0] sign_extended;
	wire [31:0] shifted_sign_extended;
	
	wire extend_bit;
	
	assign sign_extended = {{16{extend_bit}}, inst[15:0]};
	assign shifted_sign_extended = sign_extended << 2;
	
	mux32 mux_ALU_A_handler(readdata1, readdata2, 32'd0, 32'd0, ALU_A_Source, ALU_A);
	mux32 mux_ALU_B_handler(sign_extended, readdata2, 32'd0, 32'd0, ALU_B_Source, ALU_B);
	
	assign shamt = inst[10:6];
	
	// PC stuff
	wire [31:0] jumpaddr;
	assign jumpaddr = {inst[31:28], inst[25:0], 2'b00};
	
	mux32 mux_nextPC(inst_addr + 4, inst_addr + 4 + shifted_sign_extended, readdata1, jumpaddr, PC_Src, PC);

	// controller
	controller controller(inst, zero, Reg_Write_Dest_Source, ALU_A_Source, ALU_B_Source, ALU_Control, PC_Src, Reg_Write_Data_Source, Reg_Write, Mem_Write, extend_bit);

	assign regwrite = Reg_Write;
	
	// register file
	registers registers(clk, rst_n, rs, rt, writereg, writedata, regwrite, readdata1, readdata2);	
	
	// ALU
	ALU ALU(ALU_A, ALU_B, ALU_Control, shamt, ALU_Output, zero);

	// register write data mux
	mux32 mux_writeregdata(data_in, {24'b0, data_in[31:24]}, inst_addr + 4, ALU_Output, Reg_Write_Data_Source, writedata);
	
	// processor IO	
	assign data_out = readdata2;
	assign data_addr = ALU_Output;
	assign data_wr = Mem_Write;
	
	always@(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			state <= 2'b00;
		end else begin
			if(state == 2'b00) begin
				inst_addr <= 0;
				state <= 2'b01;
			end else begin
				inst_addr <= PC;
			end
		end
	end
	
endmodule
