`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2018/06/16 17:50:30
// Design Name:
// Module Name: IO_Interface
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


module IO_Interface (
    input [31:0]addr,
    input cs,
    input sig_w,
    input sig_r,
    input [31:0]wdata,
    input [31:0]data_fmem,
    input [3:0]btn,
    input [1:0]sw,
    ///////////////////
    output reg[31:0]rdata,
    output reg[31:0]data_tovga,
    output reg[31:0]data_toseg7,
    output seg7_cs
);
    assign vga_cs  = (addr == 32'h10010000 && cs == 1 && sig_w == 1) ? 1 : 0;
    assign btn_cs  = (addr == 32'h10010010 && cs == 1 && sig_r == 1) ? 1 : 0;
    assign seg7_cs = (addr == 32'h10010020 && cs == 1 && sig_w == 1) ? 1 : 0;
    assign sw_cs   = (addr == 32'h10010030 && cs == 1 && sig_r == 1) ? 1 : 0;

    always @(*) begin 
        if(btn_cs)
            rdata<={28'b0,btn};
        else if(sw_cs)
            rdata<={30'b0,sw};
        else
            rdata<=data_fmem;
    end
    


    always @(*) begin
        if(vga_cs)
            data_tovga<=wdata;
        else
            data_tovga<=data_tovga;
    end

    always @(*) begin
        if(seg7_cs)
            data_toseg7<=wdata;
        else
            data_toseg7<=data_toseg7;
    end

endmodule
