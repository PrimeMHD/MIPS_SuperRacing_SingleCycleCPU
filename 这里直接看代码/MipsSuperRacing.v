`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2018/06/16 17:10:16
// Design Name:
// Module Name: MipsSuperRacing
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module MipsSuperRacing (
    input clk_100mhz,
    input rst,
    input btn_start,
    input btn_left,
    input btn_right,
    input btn_restart,
    input [1:0]sw,
    output HSync,
    output VSync,
    output [3:0] OutBlue,
    output [3:0] OutGreen,
    output [3:0] OutRed,
    output [7:0] o_sel,
    output [7:0] o_seg
);

    wire seg7_cs;
    wire [31:0]rdata;
    wire [31:0]wdata;
    wire DM_CS,DM_R,DM_W;
    wire [31:0]inst,pc,addr;
    wire [31:0]data_fmem;
    wire [31:0]data_tovga;
    wire [31:0]data_toseg7;
    wire [31:0]addr_in;
    wire [31:0]ip_in;

    assign ip_in   = pc-32'h00400000;
    assign addr_in = addr-32'h10010000;
    assign DM_R    = 1'b1;

    clk_wiz_0 clk_divider(.clk_in1(clk_100mhz),.clk_out1(clk_reduced));
    cpu sccpu(
        .clk(clk_reduced),
        .reset(reset),
        .inst(inst),
        .ram_data(rdata),
        ///////////////////////////
        .modified_pc(pc),
        .modified_ram_addr(addr),
        .ram_wena(DM_W),
        .reg_data(wdata),
        .DM_CS(DM_CS)
    );
    
    VGA m_vga(
        .clk100mhz(clk_100mhz),
        .clk_cpu   (clk_reduced),
        .sys_rst_n(1'b1),
        .data_input(data_tovga),
        ///////////////////////////
        .HSync(HSync),
        .VSync(VSync),
        .OutBlue(OutBlue),
        .OutGreen(OutGreen),
        .OutRed(OutRed)
    );



    IO_Interface m_io_interface(
        .addr(addr_in),
        .cs(DM_CS),
        .sig_w(DM_W),
        .sig_r(DM_R),
        .wdata(wdata),
        .data_fmem(data_fmem),
        .btn({btn_restart,btn_left,btn_start,btn_right}),
        .sw(sw),
        //////////////////////
        .rdata(rdata),
        .data_tovga(data_tovga),
        .data_toseg7(data_toseg7),
        .seg7_cs(seg7_cs)
    );

    imem imem(ip_in[12:2],inst);
    dmem scdmem(addr_in[9:0],wdata,~clk_reduced,DM_W,data_fmem);
    seg7x16 seg7(clk_reduced, reset, seg7_cs, data_toseg7, o_seg, o_sel);
 
endmodule
