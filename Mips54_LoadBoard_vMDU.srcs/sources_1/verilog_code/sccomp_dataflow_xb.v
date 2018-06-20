`timescale 1ns / 1ps
`include "Definition.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:14:04 11/24/2013 
// Design Name: 
// Module Name:    sccomp_dataflow 
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
module sccomp_dataflow(
input clk_in,
input reset,
input [15:0] sw,
output [7:0] o_seg,
output [7:0] o_sel
//output reg enter_teq,
//output reg enter_sys,
//output reg enter_break
    ); 
	 
	 wire exc;
	 wire [31:0]status;
	 
wire [31:0]rdata;
wire [31:0]wdata;
wire IM_R,DM_CS,DM_R,DM_W;
wire [31:0]inst,pc,addr;
wire inta,intr;

wire [31:0]data_fmem;
wire [31:0]addr_in;
wire [31:0]ip_in;
wire seg7_cs,switch_cs;

assign ip_in = pc-32'h00400000;
assign addr_in=addr-32'h10010000; 
assign intr = 0;
//wire clk_reduce1;
//clk_div cpu_clk(clk_in,reset,clk_reduce1);
clk_wiz_0 clk_diver(.clk_in1(clk_in),.clk_out1(clk_reduced));
/*地址译码*/
io_sel io_mem(addr_in, DM_CS, DM_W, DM_R, seg7_cs, switch_cs);

//cpu sccpu(clk,reset,inst,rdata,pc,addr,wdata,IM_R,DM_CS,DM_R,DM_W,intr,inta);
cpu sccpu(
		.clk(clk_reduced),
		.reset(reset),
		.inst(inst),
		.ram_data(rdata),

		.modified_pc(pc),
		.modified_ram_addr(addr),
		.ram_wena(DM_W),
		.reg_data(wdata),
		.DM_CS(DM_CS)
		);
assign DM_R=1'b1;


//always@(posedge clk_reduced or posedge reset)begin
//    if(reset)begin
//         enter_teq<=1'b0;
//         enter_sys<=1'b0;
//         enter_break<=1'b0;
//    end
    
//    else if(inst[31:26]==`SPECIAL)begin 
//        case(inst[5:0])
//            `TEQ:
//                enter_teq<=1'b1;
//            `BREAK:
//                enter_break<=1'b1;
//            `SYSCALL:
//                enter_sys<=1'b1;
//            default:;
//        endcase
//    end
        
//end

/*指令存储�?*/
imem imem(ip_in[12:2],inst);
//imemory im(pc,inst);

/*数据存储�?*/
//dmem scdmem(~clk,reset,DM_CS,DM_W,DM_R,addr-32'h10010000,wdata,data_fmem);
dmem scdmem(addr_in[9:0],wdata,~clk_reduced,DM_W,data_fmem);

seg7x16 seg7(clk_reduced, reset, seg7_cs, wdata, o_seg, o_sel);

sw_mem_sel sw_mem(switch_cs, sw, data_fmem, rdata);

endmodule
