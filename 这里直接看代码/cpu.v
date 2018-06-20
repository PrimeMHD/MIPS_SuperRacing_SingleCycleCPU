`timescale 1ns / 1ps
`include "Definition.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company:Tongji University
// Engineer:Mi HD
//
// Create Date: 2018/04/25 16:11:18
// Module Name: CPU TOP MODULE
// Project Name: MIPS VERILOG CPU
// Target Devices:DIGILENT NEXYS 4 DDR
// Tool Versions:Vivado 2016.2
// Description:MIPS CPU 31条指令cpu封装模块

// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module cpu (
	input 	clk,
	input 	reset,
	input 	[31:0]inst,
	input 	[31:0]ram_data,
	output 	[31:0]modified_pc,
	output	[31:0]modified_ram_addr,
	output 	ram_wena,
	output 	[31:0]reg_data,
	output  DM_CS
);

	wire [31:0] alu_a;
	wire [31:0] alu_b;
	wire [3:0] alu_op;
	wire [31:0] alu_r;
	wire zero;
	wire carry;
	wire negative;
	wire overflow;
	wire pc_ena;
	wire [31:0] pc_in;

	wire [31:0]hi,lo;
	wire [31:0] cop_data;
	wire [31:0] epc_out;
	wire [3:0] ExcCode_in;
	wire mfc0,mtc0,eret,teq_exc;
	wire [2:0] mul_div_control;

	wire [31:0]pc;
	wire [31:0]ram_addr;
	wire [4:0] raddr1;
	wire [4:0] raddr2;
	wire [4:0] waddr;
	wire [31:0] rdata1;
	wire [31:0] rdata2;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	wire reg_wena;
	wire [31:0]wdata;
	wire [5:0] op = inst[31:26];
	//assign pc_ena            = `ENABLED;
	assign modified_pc       = pc+32'h00400000;
	assign modified_ram_addr = ram_addr+32'h10010000;
//wire has_load_first_inst=(op==`SPECIAL||op==`ADDI||op==`ADDIU||op==`ANDI||op==`ORI||op==`XORI||op==`LW||op==`SW||op==`BEQ||op== `BNE||op==`SLTI||op==`SLTIU||op==`LUI||op==`J||op==`JAL)?`YES:`NO;
//assign modified_pc=((op==`J||op==`JAL)?pc:((op==32'hxxxxxxxx)?32'h00400000:(pc+32'h00400000)));
//assign modified_pc=(has_load_first_inst==`NO)?32'h00400000:((op==`J||op==`JAL)?pc:(pc+32'h00400000));
// initial begin
// 	modified_pc=32'h00400000;
// end

// always @(*) begin
// 	case (op)
// 		`J,
// 		`JAL:modified_pc=pc;
// 		default : modified_pc=pc+32'h00400000;
// 	endcase
// end

	ALU i_ALU (
		.a(alu_a),
		.b(alu_b),
		.aluc(alu_op),
		.r(alu_r),
		.zero(zero),
		.carry(carry),
		.negative(negative),
		.overflow(overflow));



	pcreg i_pcreg (
		.clk(clk),
		.rst(reset),
		.ena(pc_ena),
		.data_in(pc_in),
		.data_out(pc));



	wire div_busy;
	wire divu_busy;
	wire div_start;
	wire divu_start;
	wire [63:0]mult_out;
	wire [63:0]multu_out;
	wire [63:0]div_out;
	wire [63:0]divu_out;
	wire [63:0]mul_out_fromMD;




      MDU I_MDU(
        .clk(clk),
        .rst(reset),
        .mul_div_control(mul_div_control),
        .rdata1(rdata1),
        .rdata2(rdata2),
        //////////////////
        .mul_out(mul_out_fromMD),
        .pc_ena(pc_ena),
        .hi(hi),
        .lo(lo));



//	MulDivControler mulDivControlerInst(
//		.clk       (clk),
//		.rst       (reset),
//		.mul_div_control(mul_div_control),
//		.div_busy(div_busy),
//		.divu_busy(divu_busy),
//		.mult_out(mult_out),
//		.multu_out(multu_out),
//		.div_out(div_out),
//		.divu_out(divu_out),
//		.rdata1(rdata1),
//		.rdata2(rdata2),
//		////////////////////////
//		.pc_ena    (pc_ena),
//		.div_start(div_start),
//		.divu_start(divu_start),
//		.mul_out   (mul_out_fromMD),
//		.hi        (hi),
//		.lo        (lo)
//	);




	ControlUnit i_ControlUnit (
		.instr   (inst    ),
		.pc      (pc      ),
		.rdata1  (rdata1  ),
		.rdata2  (rdata2  ),
		.alu_r   (alu_r   ),
		.ram_data(ram_data),
		////////////////////
		.hi(hi),
		.lo(lo),
		.cop_data(cop_data),
		.mul_out(mul_out_fromMD[31:0]),
		.exc_addr(epc_out),
		//newly added in mips54
		/********Separator between inpupt and output*******/
		.rs      (rs      ),
		.rt      (rt      ),
		.rd      (rd      ),
		.waddr   (waddr   ),
		.ram_addr(ram_addr),
		.ram_wena(ram_wena),
		.reg_wena(reg_wena),
		.reg_data(reg_data),
		.wdata   (wdata   ),
		.pc_in   (pc_in   ),
		.alu_a   (alu_a   ),
		.alu_b   (alu_b   ),
		.alu_op  (alu_op  ),
		/////////////////////
		.ExcCode_toCP0(ExcCode_in),
		//.mfc0(mfc0),
		.mtc0(mtc0),
		.eret(eret),
		.teq_exc(teq_exc),
		.mul_div_control(mul_div_control),
		//newly added in mips54
		.DM_CS(DM_CS)
	);



	regfile cpu_ref (
		.clk   (clk   ),
		.rst   (reset ),
		.we    (reg_wena),
		.raddr1(rs),
		.raddr2(rt),
		.waddr (waddr ),
		.wdata (wdata ),
		.rdata1(rdata1),
		.rdata2(rdata2));


	CP0 i_CP0 (
		.clk    (clk),
		.rst    (reset),
		//.mfc0	(mfc0),
		.mtc0	(mtc0),
		.teq_exc(teq_exc),
		.eret   (eret),
		.addr   (rd),
		.CP0_in(rdata2),
		.pc     (pc),
		.ExcCode_in (ExcCode_in),
		/********Separator between inpupt and output*******/
		.CP0_out(cop_data),
		.epc_out(epc_out)
		//output [31:0]status

	);





endmodule // cpu






