`timescale 1ns / 1ps
`include "Definition.vh"
module VGA (
    input clk100mhz,
    input clk_cpu,
    input  sys_rst_n,    //WHEN 1, DISPLAY
    input [31:0] data_input,
    ///////////////////////
    output HSync,
    output VSync,
    output [3:0] OutBlue,
    output [3:0] OutGreen,
    output [3:0] OutRed
);


    wire [11:0]data_fgmem;
    wire [18:0]addr_to_gmem;

    gmem vga_gmem(clk100mhz,addr_to_gmem,data_fgmem);//VGA的显�?


    VGA_Controller m_vga_controller(
    .clk100mhz(clk100mhz),
    .clk_cpu(clk_cpu),
    .data_in(data_input),
    .qsig(data_fgmem),
    .sys_rst_n(1'b1),    //WHEN 1, DISPLAY
    ////////////////////////////
    .HSync(HSync),
    .VSync(VSync),
    .OutBlue(OutBlue),
    .OutGreen(OutGreen),
    .OutRed(OutRed),
    .address_to_gmem(addr_to_gmem)
    );



//////////////////////////////////////////////////////////////


    


endmodule

