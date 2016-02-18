`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Wilson P Talento
// 
// Create Date:    12:34:00 02/18/2016
// Design Name: 
// Module Name:    register 

//////////////////////////////////////////////////////////////////////////////////
module register(
    input clk,
    input nrst,
    input [4:0] rd_addrA,
    input [4:0] rd_addrB,
    input [4:0] wr_addr,
    input [31:0] wr_data,
    input wr_en,                     
    output reg [31:0] rd_dataA,
    output reg [31:0] rd_dataB
    );
    
    reg [31:0] regfile [0:31];

    always@(rd_addrA or regfile[rd_addrA]) begin
        if (rd_addrA == 0) rd_dataA = 0;
        else rd_dataA = regfile[rd_addrA];
    end
    
    always@(rd_addrB or regfile[rd_addrB]) begin
        if (rd_addrB == 0) rd_dataB = 0;
        else rd_dataB = regfile[rd_addrB];
    end
    
    always@(posedge clk or negedge nrst) begin
        if(~nrst) begin
            regfile[0]  <= 32'b0;
            regfile[1]  <= 32'b0;
            regfile[2]  <= 32'b0;
            regfile[3]  <= 32'b0;
            regfile[4]  <= 32'b0;
            regfile[5]  <= 32'b0;
            regfile[6]  <= 32'b0;
            regfile[7]  <= 32'b0;
            regfile[8]  <= 32'b0;
            regfile[9]  <= 32'b0;
            regfile[10] <= 32'b0;
            regfile[11] <= 32'b0;
            regfile[12] <= 32'b0;
            regfile[13] <= 32'b0;
            regfile[14] <= 32'b0;
            regfile[15] <= 32'b0;
            regfile[16] <= 32'b0;
            regfile[17] <= 32'b0;
            regfile[18] <= 32'b0;
            regfile[19] <= 32'b0;
            regfile[20] <= 32'b0;
            regfile[21] <= 32'b0;
            regfile[22] <= 32'b0;
            regfile[23] <= 32'b0;
            regfile[24] <= 32'b0;
            regfile[25] <= 32'b0;
            regfile[26] <= 32'b0;
            regfile[27] <= 32'b0;
            regfile[28] <= 32'b0;
            regfile[29] <= 32'b0;
            regfile[30] <= 32'b0;
            regfile[31] <= 32'b0;
        end else begin
            if(wr_en && wr_addr) begin
                regfile[wr_addr] <= wr_data;
            end
        end 
    end
    
endmodule
