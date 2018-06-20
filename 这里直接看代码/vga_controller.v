`timescale 1ns / 1ps
`include "Definition.vh"
module VGA_Controller (
    input clk100mhz,
    input clk_cpu,
    input [11:0]qsig,
    input [31:0]data_in,
    input  sys_rst_n,    //WHEN 1, DISPLAY
    output HSync,
    output VSync,
    output [3:0] OutBlue,
    output [3:0] OutGreen,
    output [3:0] OutRed,
    output reg[18:0]address_to_gmem
);



    wire [1:0]data_mean=data_in[31:30];
    wire [1:0]game_state_in=data_in[29:28];

    wire signed[10:0] y_in;
    wire signed[10:0] x_in;
    wire signed[10:0] road_margin_in;

    assign y_in=data_in[27:17];
    assign x_in=data_in[16:6];
    assign road_margin_in=data_in[27:17];




    reg [1:0]game_state;
    reg signed[10:0]user_posx,user_posy;
    reg signed[10:0]enemy1_posx,enemy1_posy;
    reg signed[10:0]road_margin;


    reg clk50mhz;
    wire signed[10:0]pixel_x;
    wire signed[10:0]pixel_y;
    reg clk_25mhz;
    reg [11:0]  rgb_reg;
    wire [11:0]rgb;
    reg [18:0]address_bg;
    reg     [23:0] cnt;
    wire video_en;
    always@(posedge clk_cpu)begin
        case(data_mean)
            `vga_in_datamean_user:
            begin
                user_posx<=x_in;
                user_posy<=y_in;
                game_state<=game_state_in;
                
            end
            `vga_in_datamean_enemy1:
            begin
                enemy1_posx<=x_in;
                enemy1_posy<=y_in;
                game_state<=game_state_in;
            end
            `vga_in_datamean_road:
            begin
                game_state<=game_state_in;
                road_margin<=road_margin_in;

            end
            default:;
        endcase // data_in[31:30]
    end
    //VGA数据传入译码模块


    //assign test_data_fromvga={data_mean,19'b0,y_in};



////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    


    assign rgb         = (video_en == 1'b1) ? rgb_reg:12'b0;
    assign OutRed      = {rgb[11:8]};
    assign OutGreen    = {rgb[7:4]};
    assign OutBlue     = {rgb[3:0]};


    
    always @(posedge clk_25mhz or negedge sys_rst_n)begin
        if(!sys_rst_n)
            begin
                cnt <= 0;
            end
        else
            begin
                cnt <= cnt + 1'b1;
                if(cnt == 24'd12500000)
                    begin
                        cnt <= 24'b0;
                    end
            end
    end
    always @ (posedge clk_25mhz or negedge sys_rst_n)begin
        if(!sys_rst_n)
            begin
                rgb_reg <= 12'b0;
            end
        else
            begin
                rgb_reg[3:0] <= qsig[7:4];
                rgb_reg[7:4] <= qsig[3:0];
                rgb_reg[11:8] <= qsig[11:8];
            end
    end

    always @ (posedge clk_25mhz or negedge sys_rst_n)begin
        if(!sys_rst_n)
            begin
                address_bg <= 19'b0;
            end
        else
            begin
                if(pixel_x>=0 && pixel_x<= 639 && pixel_y>=0 && pixel_y<=479)
                    address_bg <= (pixel_x/2 + pixel_y/2*320);
            end
    end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    reg [18:0]address_small;  
    wire [18:0]modi_address_small;
    wire signed[19:0]modi_address_bg;
    wire [18:0]modi_address_sig_road;

    assign modi_address_small    = address_small+19'd5;
    assign modi_address_bg       = address_bg+19'd5;
    assign modi_address_sig_road = (modi_address_bg-road_margin*320<0)?modi_address_bg-road_margin*320+76800:modi_address_bg-road_margin*320;


    always@(posedge clk100mhz )begin
        if(game_state==`state_during)begin//游戏中画面信�?
            if(pixel_x>=user_posx&&pixel_x<user_posx+`car_width_pixel&&pixel_y>=user_posy&&pixel_y<user_posy+`car_height_pixel)begin
                address_small<=(pixel_x-user_posx)+90*(pixel_y-user_posy);
                address_to_gmem<=modi_address_small+`GMEM_INIT_ADDR_CARUSER;   
            end
            else if(pixel_x>=enemy1_posx&&pixel_x<enemy1_posx+`car_width_pixel&&pixel_y>=enemy1_posy&&pixel_y<enemy1_posy+`car_height_pixel)begin
                address_small<=(pixel_x-enemy1_posx)+90*(pixel_y-enemy1_posy);
                address_to_gmem<=modi_address_small+`GMEM_INIT_ADDR_CARENEMY;
            end
            else begin
                address_to_gmem<=modi_address_sig_road+`GMEM_INIT_ADDR_BGROAD;
            end
        end
        else if(game_state==`state_collision) begin //与enemy相撞时画面信�?
            if(pixel_x>=user_posx&&pixel_x<user_posx+`car_width_pixel&&pixel_y>=user_posy&&pixel_y<user_posy+`car_height_pixel)begin
                address_small<=(pixel_x-user_posx)+90*(pixel_y-user_posy);
                address_to_gmem<=modi_address_small+`GMEM_INIT_ADDR_CARCOLLI;   
            end
            else if(pixel_x>=enemy1_posx&&pixel_x<enemy1_posx+`car_width_pixel&&pixel_y>=enemy1_posy&&pixel_y<enemy1_posy+`car_height_pixel)begin
                address_small<=(pixel_x-enemy1_posx)+90*(pixel_y-enemy1_posy);
                address_to_gmem<=modi_address_small+`GMEM_INIT_ADDR_CARENEMY;
            end
            else begin
                address_to_gmem<=modi_address_sig_road+`GMEM_INIT_ADDR_BGROAD;
            end
        end
        else if(game_state==`state_ready)begin//准备状�?�的游戏画面数据
            address_to_gmem<=modi_address_bg+`GMEM_INIT_ADDR_BGSTART;
        end
        else if(game_state==`state_over)begin //结束状�?�的游戏画面数据
            address_to_gmem<=modi_address_bg+`GMEM_INIT_ADDR_BGEND;
        end

    end















/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    

    vga_sync vga_syn_inst(
        .clk            (clk_25mhz),
        .rst_n          (sys_rst_n),
        /////////////////////////////
        .video_en       (video_en),
        .hsync          (HSync),
        .vsync          (VSync),
        .pixel_x        (pixel_x),
        .pixel_y        (pixel_y)
    );


    
    always@(posedge(clk100mhz))
        begin
            clk50mhz <= ~clk50mhz;
        end
    always@(posedge(clk50mhz))
        begin
            clk_25mhz <= ~clk_25mhz;
        end
    //内部实现分频
endmodule

