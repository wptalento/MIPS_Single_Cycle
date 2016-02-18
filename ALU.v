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
			3'b000: begin							//ADD
              res = opA + opB;
              v = ((opA[31] == opB[31]) && (opA[31] != res[31])) ? 1:0;
              c = ((opA == 32'hffffffff && opB >= 32'd1) || (opB == 32'hffffffff && opA >= 32'd1)) ? 1:0;
            end
			3'b001: begin							//SUB
              res = opA - opB;
              v = ((opA[31] == opB[31]) && (opA[31] != res[31])) ? 1:0;
              c = (opA == 32'h0 && opB >= 32'd1) ? 1:0;
            end
			3'b010: res = opA & opB;				// AND
			3'b011: res = opA | opB;				// OR
			3'b100: res = ~opA;					    // NOT
		endcase
      z = (res == 0) ? 1:0;
      
	end

endmodule
