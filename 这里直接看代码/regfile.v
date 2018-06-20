`timescale 1ns / 1ps
`include "Definition.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company:Tongji University
// Engineer:Mi HD
//
// Create Date: 2018/04/25 16:11:18
// Module Name: RegFiles
// Project Name: MIPS VERILOG CPU
// Target Devices:DIGILENT NEXYS 4 DDR
// Tool Versions:Vivado 2016.2
// Description:MIPS CPU 31条指令寄存器�?

// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
/////
//////////////////////////////////////////////////////////////////////////////////
module regfile (
	input clk, //寄存器组时钟信号，下降沿写入数据
	input rst, //reset 信号，异步复位，高电平时全部寄存器置�?
	input we, //寄存器读写有效信号，高电平时允许寄存器写入数据，低电平时允许寄存器读出数�?
	input [4:0] raddr1, //�?�?读取的寄存器的地�?
	input [4:0] raddr2, //�?�?读取的寄存器的地�?
	input [4:0] waddr, //写寄存器的地�?
	input [31:0] wdata, //写寄存器数据，数据在 clk 下降沿时被写�?
	output [31:0] rdata1, //raddr1 �?对应寄存器的输出数据
	output [31:0] rdata2 //raddr2 �?对应寄存器的输出数据
);
	reg [31:0] array_reg [31:0];
	integer i;

	always@(posedge  clk or posedge rst) begin
		if(rst)  for(i=0;i<32;i=i+1) begin
			array_reg[i]<=32'b0;
		end
		else begin
			if(we&&waddr!=5'b0) array_reg[waddr]<=wdata;
		end
	end

	assign rdata1 = array_reg[raddr1];
	assign rdata2 = array_reg[raddr2];

endmodule