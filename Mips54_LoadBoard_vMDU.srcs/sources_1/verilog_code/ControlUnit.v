`timescale 1ns / 1ps
`include "Definition.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company:Tongji University
// Engineer:Mi HD
//
// Create Date: 2018/04/25 16:11:18
// Module Name: ControlUnit
// Project Name: MIPS VERILOG CPU
// Target Devices:DIGILENT NEXYS 4 DDR
// Tool Versions:Vivado 2016.2
// Description:MIPS CPU 54条指令控制器

// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module ControlUnit (
	input [31:0] instr,
	input [31:0] pc,
	input [31:0] rdata1,rdata2,
	input [31:0] alu_r,ram_data,
	/////////////////////////////////////
	input [31:0] hi,lo,
	input [31:0] cop_data,mul_out,
	input [31:0] exc_addr,
	//newly added in mips54
	/***********Separator between inpupt and output*******************/
	output [ 4:0] rs, rt, rd,
	output [ 4:0] waddr,
	output [31:0] ram_addr,
	output ram_wena,
	output reg reg_wena,
	output reg [31:0]reg_data,
	output reg [31:0] wdata,
	output reg [31:0] pc_in,
	output reg [31:0] alu_a,alu_b,
	output reg [ 3:0] alu_op,
	////////////////////////////////////
	output reg [3:0] ExcCode_toCP0,
	output mtc0,eret,teq_exc,
	output reg [2:0] mul_div_control,
	//newly added in mips54
	output   DM_CS
);
/*变量说明:
【输入】
instr:     32bit mips指令
pc:        PC寄存器的现值
rdata1:    从RegFile中读出的第一个数
rdata2:    从RegFile中读出的第二个数
alu_r:     alu的输出值
ram_data:  从数据存储器ram中读出的数据
【输出】
rs,rt,rd:  寄存器编?$0~$31
waddr:     写入寄存器的编号$0~$31
ram_addr:   数据存储器ram的读写地址
ram_wena:  数据存储器ram的写开关
reg_wena:  RegFile的写开关
ram_datain：写入Ram中的数据
wdata:     写入RegFile的数
pc_in:     写入PC寄存器的新值
alu_a:     alu输入数a
alu_b:     alu输入数b
alu_op:    alu操作码
*/



	wire [5:0] op = instr[31:26];
	assign rs = instr[25:21];
	assign rt = instr[20:16];
	//COMMON INSTRUCTION FIELD
	assign rd = instr[15:11];
	wire [ 4:0] shamt = instr[10:6];
	wire [ 5:0] func  = instr[5:0];
	//R-TYPE INSTRUCTION UNIQUE FIELD
	wire [15:0] imm   = instr[15:0];
	//I-TYPE INSTRUCTION UNIQUE FIELD
	wire [25:0] addr  = instr[25:0];
	//J-TYPE INSTRUCTION UNIQUE FIELD
	/*指令的分解*/


	wire imm_sign = (op==`ANDI||op==`ORI||op==`XORI)?`UNSIGN:`SIGN;//立即数符号扩展方式
	wire [31:0] shamt_ext = {27'b0,shamt};//位移数符号扩展
	wire [31:0] imm_ext   =  (imm_sign==`SIGN)?{{(16){imm[15]}},imm}:{16'b0,imm};//立即数符号扩展
	//op==000000的时候，写入数据的寄存器总是rd，I-Type总是写入rt,jal写入$31
	/*数据扩展*/

	assign waddr    = (op==`SPECIAL||op==`SPECIAL2)?rd:(op==`JAL)?5'b11111:rt;
	assign ram_addr = rdata1 + imm_ext;
	assign ram_wena = (op==`SW || op==`SH || op==`SB)?`ENABLED:`DISABLED;
	assign eret     = op==`CP0 && func==`ERET;
	assign mtc0     = op==`CP0 && rs==`MTC0;
	assign teq_exc  = rdata1==rdata2;
	assign DM_CS = (op==`LB||op==`LBU||op==`LH||op== `LHU||op== `LW||op==`SB||op== `SH ||op==`SW)?`ENABLED:`DISABLED;
   wire test_iflblbu;
    assign test_iflblbu = (op==`LB||op==`LBU||op==`LH||op== `LHU||op== `LW)?`ENABLED:`DISABLED;
	/*通过assign直接计算输出*/


	wire [31:0] npc = pc+4;
	wire [31:0] pc_branch = npc + {{(14){imm[15]}},imm,2'b00};
	wire [31:0] pc_jmp = {npc[31:28],addr,2'b00}-32'h00400000;
	reg [31:0] load_data,clz_data;
//    reg teq_show_me;
//    reg sys_show_me;
//    reg break_show_me;
//    reg add_show_me;
	/*其他内部变量*/



	always @(*) begin
		case (op)
			`SPECIAL:
			case (func)
				`ADDU:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_ADDU;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;
				end
				`SUBU:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_SUBU;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`ADD:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_ADD;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;
				end
				`SUB:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_SUB;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`AND:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_AND;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`OR:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_OR;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`XOR:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_XOR;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`NOR:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_NOR;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`SLT:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_SLT;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`SLTU:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_SLTU;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`SRL:begin
					wdata    <= alu_r;
					alu_a    <= shamt_ext;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_SRL;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`SRA:begin
					wdata    <= alu_r;
					alu_a    <= shamt_ext;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_SRA;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`SLL:begin
					wdata    <= alu_r;
					alu_a    <= shamt_ext;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_SLL;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`SLLV:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_SLL;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`SRLV:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_SRL;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`SRAV:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= npc;
					alu_op   <= `_SRA;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`JR:begin
					wdata    <= alu_r;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in    <= rdata1-32'h00400000;
					alu_op   <= `_ADDU;
					reg_wena <= `DISABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;

				end
				`MULTU:begin
					wdata    <= alu_r;
					reg_wena <= `DISABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_MULTU;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in  <=   npc;
					alu_op  <=   `_ADDU;
				end
				`DIV:begin
					wdata    <= alu_r;
					reg_wena <= `DISABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_DIV;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in  <=   npc;
					alu_op  <=   `_ADDU;
				end
				`DIVU:begin
					wdata    <= alu_r;

					reg_wena <= `DISABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_DIVU;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in  <=   npc;
					alu_op  <=   `_ADDU;
				end
				`MFHI:begin
					wdata    <= hi;
					reg_wena <= `ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in  <=   npc;
					alu_op  <=   `_ADDU;
				end
				`MFLO:begin
					wdata    <=   lo;
					reg_wena <=`ENABLED;
					reg_data <= rdata2;
					ExcCode_toCP0    <= 5'b0;
					mul_div_control      <= `MD_NO;
					alu_a    <= rdata1;
					alu_b    <= rdata2;
					pc_in  <=   npc;
					alu_op  <=   `_ADDU;
				end
				`MTHI:begin
					wdata    <= alu_r;
					reg_wena <= `DISABLED;
					reg_data    <=    rdata2;
					ExcCode_toCP0    <=    5'b0;
					mul_div_control        <=    `MD_MTHI;
					alu_a<=rdata1;
					alu_b<=rdata2;
					pc_in  <=   npc;
					alu_op  <=   `_ADDU;

				end
				`MTLO:begin
					wdata   <=   alu_r;
					reg_wena<=`DISABLED;
					ExcCode_toCP0    <=    5'b0;
					mul_div_control        <=    `MD_MTLO;
					alu_a<=rdata1;
					alu_b<=rdata2;
					pc_in  <=   npc;
					alu_op  <=   `_ADDU;

				end
				`BREAK:begin
					wdata   <=   alu_r;
					reg_wena<=`DISABLED;
					reg_data    <=    rdata2;
					ExcCode_toCP0    <=    `_BREAK;
					mul_div_control      <= `MD_NO;
					alu_a<=rdata1;
					alu_b<=rdata2;
					pc_in  <=   exc_addr;
					alu_op  <=   `_ADDU;

				end
				`SYSCALL:begin
					wdata   <=   alu_r;
					reg_wena<=`DISABLED;
					reg_data    <=    rdata2;
					ExcCode_toCP0    <=     `_SYSCALL;
					mul_div_control      <= `MD_NO;
					alu_a<=rdata1;
					alu_b<=rdata2;
					pc_in  <=   exc_addr;
					alu_op  <=   `_ADDU;

				end
				`TEQ:begin
					wdata   <=   alu_r;
					reg_wena<=`ENABLED;
					reg_data    <=    rdata2;
					ExcCode_toCP0    <=    `_TEQ;
					mul_div_control      <= `MD_NO;
					alu_a<=rdata1;
					alu_b<=rdata2;
					pc_in  <=   exc_addr;
					alu_op  <=   `_ADDU;

				end
				`JALR:begin
					wdata   <=   npc+32'h00400000;
					reg_wena<=`ENABLED;
					reg_data    <=    rdata2;
					ExcCode_toCP0    <=    5'b0;
					mul_div_control      <= `MD_NO;
					alu_a<=rdata1;
					alu_b<=rdata2;
					pc_in  <=   rdata1-32'h00400000;
					alu_op  <=   `_ADDU;

				end
			endcase //endcase of SPECIAL




			`SPECIAL2:
			case(func)
				`CLZ:begin
					reg_wena<=`ENABLED;
					reg_data    <=    rdata2;
					ExcCode_toCP0    <=    5'b0;
					mul_div_control      <= `MD_NO;
					casez(rdata1)
                                        32'b1???????????????????????????????:   wdata   =       32'h0;
                                        32'b01??????????????????????????????:   wdata   =       32'h1;
                                        32'b001?????????????????????????????:   wdata   =       32'h2;
                                        32'b0001????????????????????????????:   wdata   =       32'h3;
                                        32'b00001???????????????????????????:   wdata   =       32'h4;
                                        32'b000001??????????????????????????:   wdata   =       32'h5;
                                        32'b0000001?????????????????????????:   wdata   =       32'h6;
                                        32'b00000001????????????????????????:   wdata   =       32'h7;
                                        32'b000000001???????????????????????:   wdata   =       32'h8;
                                        32'b0000000001??????????????????????:   wdata   =       32'h9;
                                        32'b00000000001?????????????????????:   wdata   =       32'ha;
                                        32'b000000000001????????????????????:   wdata   =       32'hb;
                                        32'b0000000000001???????????????????:   wdata   =       32'hc;
                                        32'b00000000000001??????????????????:   wdata   =       32'hd;
                                        32'b000000000000001?????????????????:   wdata   =       32'he;
                                        32'b0000000000000001????????????????:   wdata   =       32'hf;
                                        32'b00000000000000001???????????????:   wdata   =       32'h10;
                                        32'b000000000000000001??????????????:   wdata   =       32'h11;
                                        32'b0000000000000000001?????????????:   wdata   =       32'h12;
                                        32'b00000000000000000001????????????:   wdata   =       32'h13;
                                        32'b000000000000000000001???????????:   wdata   =       32'h14;
                                        32'b0000000000000000000001??????????:   wdata   =       32'h15;
                                        32'b00000000000000000000001?????????:   wdata   =       32'h16;
                                        32'b000000000000000000000001????????:   wdata   =       32'h17;
                                        32'b0000000000000000000000001???????:   wdata   =       32'h18;
                                        32'b00000000000000000000000001??????:   wdata   =       32'h19;
                                        32'b000000000000000000000000001?????:   wdata   =       32'h1a;
                                        32'b0000000000000000000000000001????:   wdata   =       32'h1b;
                                        32'b00000000000000000000000000001???:   wdata   =       32'h1c;
                                        32'b000000000000000000000000000001??:   wdata   =       32'h1d;
                                        32'b0000000000000000000000000000001?:   wdata   =       32'h1e;
                                        32'b00000000000000000000000000000001:   wdata   =        32'h1f;
                                        32'b00000000000000000000000000000000:    wdata   =       32'h20;
                                    endcase


					
					alu_a<=rdata1;
					alu_b<=rdata2;
					pc_in  <=   npc;
					alu_op  <=   `_ADDU;

				end
				`MUL:begin
					reg_wena<=`ENABLED;
					reg_data    <=    rdata2;
					ExcCode_toCP0    <=    5'b0;
					mul_div_control        <=    `MD_MUL;  //瀛樼枒
					wdata    <=    mul_out;
					alu_a<=rdata1;
					alu_b<=rdata2;
					pc_in  <=   npc;
					alu_op  <=   `_ADDU;

				end
			endcase // func



			`CP0:
			case (rs)
				`MFC0:begin
					reg_wena<=`ENABLED;
					reg_data    <=    rdata2;
					ExcCode_toCP0    <=    5'b0;
					mul_div_control      <= `MD_NO;
					wdata   <=   cop_data;
					alu_a<=rdata1;
					alu_b<=rdata2;
					pc_in  <=   npc;
					alu_op  <=   `_ADDU;

				end
				`MTC0:begin
					reg_wena<=`DISABLED;
					reg_data    <=    rdata2;
					ExcCode_toCP0    <=    5'b0;
					mul_div_control      <= `MD_NO;
					wdata   <=   alu_r;
					alu_a<=rdata1;
					alu_b<=rdata2;
					pc_in  <=   npc;
					alu_op  <=   `_ADDU;

				end
				`ERET:begin
					reg_wena<=`DISABLED;
					reg_data    <=    rdata2;
					ExcCode_toCP0    <=    5'b0;
					mul_div_control      <= `MD_NO;
					wdata   <=   alu_r;
					alu_a<=rdata1;
					alu_b<=rdata2;
					pc_in  <=   exc_addr;
					alu_op  <=   `_ADDU;

				end
			endcase


			`BGEZ:begin
				reg_wena<=`DISABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;
				wdata   <=   alu_r;
				alu_a<=rdata1;
				alu_b<=rdata2;
				if(!rdata1[31])
					pc_in  <=   pc_branch;
				else
					pc_in  <=   npc;
				alu_op  <=   `_ADDU;
			end
			`LB:begin

				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				load_data   <=   {{24{ram_data[7]}},ram_data[7:0]};
				wdata   <=   load_data;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;
				alu_a<=rdata1;
				alu_b<=rdata2;
				pc_in  <=   npc;
				alu_op  <=   `_ADDU;
			end
			`LBU:begin
				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				load_data   <=   {24'b0,ram_data[7:0]};
				wdata   <=   load_data;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;
				alu_a<=rdata1;
				alu_b<=rdata2;
				pc_in  <=   npc;
				alu_op  <=   `_ADDU;


			end
			`LH:begin

				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				load_data   <=   {{16{ram_data[15]}},ram_data[15:0]};
				wdata   <=   load_data;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;
				alu_a<=rdata1;
				alu_b<=rdata2;
				pc_in  <=   npc;
				alu_op  <=   `_ADDU;


			end
			`LHU:begin

				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				load_data   <=   {16'b0,ram_data[15:0]};
				wdata   <=   load_data;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;
				alu_a<=rdata1;
				alu_b<=rdata2;
				pc_in  <=   npc;
				alu_op  <=   `_ADDU;


			end
			`SB:begin
				reg_wena<=`DISABLED;
				reg_data    <=   {24'b0,rdata2[7:0]};
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;
				alu_a<=rdata1;
				alu_b<=rdata2;
				pc_in  <=   npc;
				alu_op  <=   `_ADDU;


			end
			`SH:begin
				reg_wena<=`DISABLED;
				reg_data    <=   {16'b0,rdata2[15:0]};
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;
				alu_a<=rdata1;
				alu_b<=rdata2;
				pc_in  <=   npc;
				alu_op  <=   `_ADDU;

			end




			`ADDI:begin
				wdata<=alu_r;
				alu_a<=rdata1;
				alu_b<=imm_ext;
				pc_in<=npc;
				alu_op<=`_ADD;
				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`ADDIU:begin
				wdata<=alu_r;
				alu_a<=rdata1;
				alu_b<=imm_ext;
				pc_in<=npc;
				alu_op<=`_ADDU;
				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`ANDI:begin
				wdata<=alu_r;
				alu_a<=rdata1;
				alu_b<=imm_ext;
				pc_in<=npc;
				alu_op<=`_AND;
				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`ORI:begin
				wdata<=alu_r;
				alu_a<=rdata1;
				alu_b<=imm_ext;
				pc_in<=npc;
				alu_op<=`_OR;
				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`XORI:begin
				wdata<=alu_r;
				alu_a<=rdata1;
				alu_b<=imm_ext;
				pc_in<=npc;
				alu_op<=`_XOR;
				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`LW:begin
				wdata   <=   load_data;
				alu_a<=rdata1;
				alu_b<=rdata2;
				pc_in<=npc;
				alu_op<=`_ADDU;
				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				load_data   <=   ram_data;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`SW:begin
				wdata<=alu_r;
				alu_a<=rdata1;
				alu_b<=rdata2;
				pc_in<=npc;
				alu_op<=`_ADDU;
				reg_wena<=`DISABLED;
				reg_data    <=   rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`BEQ:begin
				wdata<=alu_r;
				alu_a<=rdata1;
				alu_b<=rdata2;
				if(rdata1==rdata2)
					pc_in  <=   pc_branch;
				else
					pc_in  <=   npc;
				alu_op<=`_SUBU;
				reg_wena<=`DISABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`BNE:begin
				wdata<=alu_r;
				alu_a<=rdata1;
				alu_b<=rdata2;
				if(rdata1!=rdata2)
					pc_in  <=   pc_branch;
				else
					pc_in  <=   npc;
				alu_op<=`_SUBU;
				reg_wena<=`DISABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`SLTI:begin
				wdata<=alu_r;
				alu_a<=rdata1;
				alu_b<=imm_ext;
				pc_in<=npc;
				alu_op<=`_SLT;
				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`SLTIU:begin
				wdata<=alu_r;
				alu_a<=rdata1;
				alu_b<=imm_ext;
				pc_in<=npc;
				alu_op<=`_SLTU;
				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`LUI:begin
				wdata<=alu_r;
				alu_a<=rdata1;
				alu_b<=imm_ext;
				pc_in<=npc;
				alu_op<=`_LUI;
				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`J:begin
				wdata<=alu_r;
				alu_a<=rdata1;
				alu_b<=rdata2;
				pc_in<=pc_jmp;
				alu_op<=`_ADDU;
				reg_wena<=`DISABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
			`JAL:begin
				wdata<=npc+32'h00400000;
				alu_a<=rdata1;
				alu_b<=rdata2;
				pc_in<=pc_jmp;
				alu_op<=`_ADDU;
				reg_wena<=`ENABLED;
				reg_data    <=    rdata2;
				ExcCode_toCP0    <=    5'b0;
				mul_div_control      <= `MD_NO;

			end
		endcase
	end
endmodule

