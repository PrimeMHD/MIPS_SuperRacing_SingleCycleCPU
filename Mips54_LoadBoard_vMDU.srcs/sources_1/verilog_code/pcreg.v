module pcreg (
	input clk, //1 Î»ÊäÈë£¬¼Ä´æÆ÷Ê±ÖÓÐÅºÅ£¬ÉÏÉýÑØÊ±Îª PC ¼Ä´æÆ÷¸³Öµ
	input rst, //1 Î»ÊäÈë£¬ Òì²½ÖØÖÃÐÅºÅ£¬¸ßµçÆ½Ê±½« PC ¼Ä´æÆ÷ÇåÁã
	//×¢£ºµ± ena ÐÅºÅÎÞÐ§Ê±£¬ rst Ò²¿ÉÒÔÖØÖÃ¼Ä´æÆ÷
	input ena, //1 Î»ÊäÈë,ÓÐÐ§ÐÅºÅ¸ßµçÆ½Ê± PC ¼Ä´æÆ÷¶ÁÈë data_in
	//µÄÖµ£¬·ñÔò±£³ÖÔ­ÓÐÊä³ö
	input [31:0] data_in, //32 Î»ÊäÈë£¬ÊäÈëÊý¾Ý½«±»´æÈë¼Ä´æÆ÷ÄÚ²¿
	output [31:0] data_out //32 Î»Êä³ö£¬¹¤×÷Ê±Ê¼ÖÕÊä³ö PC
	//¼Ä´æÆ÷ÄÚ²¿´æ´¢µÄÖµ 
);
	wire [31:0] data_out_reverse;
	Asynchronous_D_FF a0(ena,clk,data_in[0],~rst,data_out[0],data_out_reverse[0]);
	Asynchronous_D_FF a1(ena,clk,data_in[1],~rst,data_out[1],data_out_reverse[1]);
	Asynchronous_D_FF a2(ena,clk,data_in[2],~rst,data_out[2],data_out_reverse[2]);
	Asynchronous_D_FF a3(ena,clk,data_in[3],~rst,data_out[3],data_out_reverse[3]);
	Asynchronous_D_FF a4(ena,clk,data_in[4],~rst,data_out[4],data_out_reverse[4]);
	Asynchronous_D_FF a5(ena,clk,data_in[5],~rst,data_out[5],data_out_reverse[5]);
	Asynchronous_D_FF a6(ena,clk,data_in[6],~rst,data_out[6],data_out_reverse[6]);
	Asynchronous_D_FF a7(ena,clk,data_in[7],~rst,data_out[7],data_out_reverse[7]);
	Asynchronous_D_FF a8(ena,clk,data_in[8],~rst,data_out[8],data_out_reverse[8]);
	Asynchronous_D_FF a9(ena,clk,data_in[9],~rst,data_out[9],data_out_reverse[9]);
	Asynchronous_D_FF a10(ena,clk,data_in[10],~rst,data_out[10],data_out_reverse[10]);
	Asynchronous_D_FF a11(ena,clk,data_in[11],~rst,data_out[11],data_out_reverse[11]);
	Asynchronous_D_FF a12(ena,clk,data_in[12],~rst,data_out[12],data_out_reverse[12]);
	Asynchronous_D_FF a13(ena,clk,data_in[13],~rst,data_out[13],data_out_reverse[13]);
	Asynchronous_D_FF a14(ena,clk,data_in[14],~rst,data_out[14],data_out_reverse[14]);
	Asynchronous_D_FF a15(ena,clk,data_in[15],~rst,data_out[15],data_out_reverse[15]);
	Asynchronous_D_FF a16(ena,clk,data_in[16],~rst,data_out[16],data_out_reverse[16]);
	Asynchronous_D_FF a17(ena,clk,data_in[17],~rst,data_out[17],data_out_reverse[17]);
	Asynchronous_D_FF a18(ena,clk,data_in[18],~rst,data_out[18],data_out_reverse[18]);
	Asynchronous_D_FF a19(ena,clk,data_in[19],~rst,data_out[19],data_out_reverse[19]);
	Asynchronous_D_FF a20(ena,clk,data_in[20],~rst,data_out[20],data_out_reverse[20]);
	Asynchronous_D_FF a21(ena,clk,data_in[21],~rst,data_out[21],data_out_reverse[21]);
	Asynchronous_D_FF a22(ena,clk,data_in[22],~rst,data_out[22],data_out_reverse[22]);
	Asynchronous_D_FF a23(ena,clk,data_in[23],~rst,data_out[23],data_out_reverse[23]);
	Asynchronous_D_FF a24(ena,clk,data_in[24],~rst,data_out[24],data_out_reverse[24]);
	Asynchronous_D_FF a25(ena,clk,data_in[25],~rst,data_out[25],data_out_reverse[25]);
	Asynchronous_D_FF a26(ena,clk,data_in[26],~rst,data_out[26],data_out_reverse[26]);
	Asynchronous_D_FF a27(ena,clk,data_in[27],~rst,data_out[27],data_out_reverse[27]);
	Asynchronous_D_FF a28(ena,clk,data_in[28],~rst,data_out[28],data_out_reverse[28]);
	Asynchronous_D_FF a29(ena,clk,data_in[29],~rst,data_out[29],data_out_reverse[29]);
	Asynchronous_D_FF a30(ena,clk,data_in[30],~rst,data_out[30],data_out_reverse[30]);
	Asynchronous_D_FF a31(ena,clk,data_in[31],~rst,data_out[31],data_out_reverse[31]);
endmodule

module Asynchronous_D_FF (
	input ena,
	input CLK, //Ê±ÖÓÐÅºÅ£¬ÉÏÉýÑØÓÐÐ§
	input D, //ÊäÈëÐÅºÅ D
	input RST_n, //¸´Î»ÐÅºÅ£¬µÍµçÆ½ÓÐÐ§
	output reg Q1, //Êä³öÐÅºÅ Q
	output reg Q2 //Êä³öÐÅºÅ ?
);
	always @(posedge  CLK or negedge RST_n)begin
		if(!RST_n)begin
			Q1<=1'b0;
			Q2<=1'b1;
		end
		else if(ena==1) begin
			Q1<=D;
			Q2<=~D;
		end
		else begin
			Q1<=Q1;
			Q2<=Q2;
		end
	end
endmodule