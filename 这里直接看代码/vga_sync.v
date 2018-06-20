`timescale 1ns / 1ps
/*
Author:Mi HD
Date:2018.1.2
Language:verilog HDL
Environment:Vivado 2016.2
Hardware:Digilent Nexys 4 DDR
*/
module vga_sync (
    input   wire            clk,
    input   wire            rst_n,
    output  wire        video_en,              //数据有效
    output  reg             hsync,                 //场同步信号
    output  reg             vsync,                 //行同步信号
    output  signed    [10:0]   pixel_x,               //待显示待像素的x坐标
    output  signed    [10:0]   pixel_y                //待显示待像素的y坐标
);
    reg [10:0] pixel_cnt;
    reg [10:0] line_cnt;
    reg v_video_en;
    reg h_video_en;
    parameter PAL = 640;        //Pixels/Active Line (pixels)
    parameter LAF = 480;        //Lines/Active Frame (lines)
    parameter PLD = 800;        //Pixel/Line Divider
    parameter LFD = 525;        //Line/Frame Divider
    parameter HPW = 96;            //Horizontal synchro Pulse Width (pixels)
    parameter HFP = 16;            //Horizontal synchro Front Porch (pixels)
    parameter VPW = 2;            //Verical synchro Pulse Width (lines)
    parameter VFP = 10;            //Verical synchro Front Porch (lines)
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            pixel_cnt <= 10'b0;
        end
        else begin
            if(pixel_cnt == PLD-1 )begin //have reached the edge of one line
                pixel_cnt <= 0; //reset the horizontal counter
                if(line_cnt == LFD-1 ) //only when horizontal pointer reach the edge can the vertical counter ++
                    line_cnt <=0;
                else
                    line_cnt <= line_cnt + 1;
            end
            else
                pixel_cnt <= pixel_cnt + 1;
        end
    end

    always @(posedge clk or negedge rst_n)
        if(!rst_n) begin
            h_video_en <= 1'b1;
            hsync <= 1'b1;
        end
        else begin
            case (pixel_cnt)
                10'd0:begin
                    h_video_en <= 1'b1;
                end
                10'd639:begin
                    h_video_en <= 1'b0;
                end
                10'd655:begin
                    hsync <= 1'b0;
                end
                10'd751:begin
                    hsync <= 1'b1;
                end
            endcase
        end


    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            v_video_en <= 1'b1;
            vsync <= 1'b1;
        end
        else begin
            case(line_cnt)
                10'd0:begin
                    v_video_en <= 1'b1;
                end
                10'd479:begin
                    v_video_en <= 1'b0;
                end
                10'd489:begin
                    vsync <= 1'b0;
                end
                10'd491:begin
                    vsync <= 1'b1;
                end
            endcase
        end
    end

    assign pixel_x  = pixel_cnt;
    assign pixel_y  = line_cnt;
    assign video_en = ((h_video_en == 1'b1)&&(v_video_en == 1'b1));

endmodule  