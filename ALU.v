`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Wilson P Talento
// 
// Create Date:    09:31:52 02/18/2015 
// Design Name: 
// Module Name:    ALU 
//////////////////////////////////////////////////////////////////////////////////
module ALU(
	input [31:0] opA,
	input [31:0] opB,
	input [2:0] sel,
	output reg [31:0] res,
	output reg z,
	output reg c,
	output reg v
    );
	
	always@(opA or opB or sel) begin	
		case(sel)
			3'b000: res = opA + opB;				// ADD
			3'b001: res = opA - opB;				// SUB
			3'b010: res = opA & opB;				// AND
			3'b011: res = opA | opB;				// OR
			3'b100: res = ~opA;					    // NOT
		endcase
		z = ((opA - opB) == 0) ? 1:0;			// ZERO FLAG
	end

endmodule
