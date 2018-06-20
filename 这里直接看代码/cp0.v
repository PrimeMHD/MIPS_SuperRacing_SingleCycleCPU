`timescale 1ns / 1ps
`include "Definition.vh"

//////////////////////////////////////////////////////////////////////////////////
// Company:Tongji University
// Engineer:Mi HD
//
// Create Date: 2018/05/20 15:11:10
// Module Name: CP0
// Project Name: MIPS VERILOG CPU
// Target Devices:DIGILENT NEXYS 4 DDR
// Tool Versions:Vivado 2016.2
// Description:MIPS CPU CP0

// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////



module CP0 (
	input clk,
	input rst,
	//input mfc0,
	input mtc0,
	input teq_exc,
	input eret,
	input [4:0]addr,
	input [31:0]CP0_in,
	input [31:0]pc,
	input [3:0]ExcCode_in,
	
	output [31:0]CP0_out,
	output [31:0]epc_out
	//output [31:0]status 
);//interface is modified with ZDD's PDF considered


	reg [31:0]cp0regs[31:0]; //CP0?32个内部寄存器

	wire [31:0]status;
	//status ?12号寄存器
	wire [31:0]cause;   //13号寄存器
	wire [31:0]epc;     //14号寄存器
	//CP0 inner registers and those used in this module

	wire ie;
	wire [2:0]im;
	//part of CP0 regs

	wire exception;
	

	assign CP0_out   = cp0regs[addr];
	assign status    = cp0regs[12];
	assign cause     = cp0regs[13];
	assign epc       = cp0regs[14];
	assign ie        = status[0];
	assign im        = status[3:1];
	assign ExcCode   = cause[6:2];
	assign epc_out   = eret?epc:32'h4;
	assign exception = ie&&(
		(im[0]&&ExcCode_in==`_SYSCALL)||
		(im[1]&&ExcCode_in==`_BREAK)  ||
		(im[2]&&ExcCode_in==`_TEQ&&teq_exc));

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			cp0regs[0]<=0;
			cp0regs[1]<=0;
			cp0regs[2]<=0;
			cp0regs[3]<=0;
			cp0regs[4]<=0;
			cp0regs[5]<=0;
			cp0regs[6]<=0;
			cp0regs[7]<=0;
			cp0regs[8]<=0;
			cp0regs[9]<=0;
			cp0regs[10]<=0;
			cp0regs[11]<=0;
			cp0regs[12]<=0;
			cp0regs[13]<=0;
			cp0regs[14]<=0;
			cp0regs[15]<=0;
			cp0regs[16]<=0;
			cp0regs[17]<=0;
			cp0regs[18]<=0;
			cp0regs[19]<=0;
			cp0regs[20]<=0;
			cp0regs[21]<=0;
			cp0regs[22]<=0;
			cp0regs[23]<=0;
			cp0regs[24]<=0;
			cp0regs[25]<=0;
			cp0regs[26]<=0;
			cp0regs[27]<=0;
			cp0regs[28]<=0;
			cp0regs[29]<=0;
			cp0regs[30]<=0;
			cp0regs[31]<=0;
		end
		else begin
			// if(mfc0) begin
			// 	CP0_out<=cp0regs[addr];
			// end
			if(mtc0)begin
				cp0regs[addr]<=CP0_in;
			end
			else if(exception) begin//cope with exception
				cp0regs[14]    <=    pc;    //put value of PC into epc
				cp0regs[12]    <=    status<<5; //make IM 0 to block interruption
				cp0regs[13]    <=    {25'b0,ExcCode_in,2'b0};
			end
			else if(eret)begin
				cp0regs[12]    <=    status>>5;
				//While receiving the signal of eret,
				//1st shift status right to recover from interruption blocked state
				//2nd send epc out (this is not implemented here but assigned before)
			end // else if(eret)


		end
	end


endmodule // CP0