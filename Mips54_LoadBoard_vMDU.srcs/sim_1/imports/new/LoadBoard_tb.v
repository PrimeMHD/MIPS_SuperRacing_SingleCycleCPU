`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/14 13:39:22
// Design Name: 
// Module Name: LoadBoard_tb
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


module LoadBoard_tb;
    reg clk_in;
    reg reset;
    reg[15:0]sw;
    wire [7:0]o_seg;
    wire [7:0]o_sel;
     integer file_output;
       integer counter=0;
       //reg[31:0]p;
    
    
    always #5 clk_in<=!clk_in;
    initial begin
        file_output=$fopen("D:\\result_my.txt");
        sw=16'b1000000000000001;
        clk_in=0;
        reset=1;
    
        #3 reset=0;
    end
// always@(posedge clk_in)begin
//            p<=inst_scc.ip_in;
//        end
//        always @(posedge clk_in)begin
            
    
//            if(1==1)begin
//            counter=counter+1;
//            $fdisplay(file_output,"pc: %h",inst_scc.ip_in);
//            $fdisplay(file_output,"instr: %h",inst_scc.inst);
    
             
//            $fdisplay(file_output,"regfile0: %h",inst_scc.sccpu.cpu_ref.array_reg[0]);
//            $fdisplay(file_output,"regfile1: %h",inst_scc.sccpu.cpu_ref.array_reg[1]);
//            $fdisplay(file_output,"regfile2: %h",inst_scc.sccpu.cpu_ref.array_reg[2]);
//            $fdisplay(file_output,"regfile3: %h",inst_scc.sccpu.cpu_ref.array_reg[3]);
//            $fdisplay(file_output,"regfile4: %h",inst_scc.sccpu.cpu_ref.array_reg[4]);
//            $fdisplay(file_output,"regfile5: %h",inst_scc.sccpu.cpu_ref.array_reg[5]);
//            $fdisplay(file_output,"regfile6: %h",inst_scc.sccpu.cpu_ref.array_reg[6]);
//            $fdisplay(file_output,"regfile7: %h",inst_scc.sccpu.cpu_ref.array_reg[7]);
//            $fdisplay(file_output,"regfile8: %h",inst_scc.sccpu.cpu_ref.array_reg[8]);
//            $fdisplay(file_output,"regfile9: %h",inst_scc.sccpu.cpu_ref.array_reg[9]);
//            $fdisplay(file_output,"regfile10: %h",inst_scc.sccpu.cpu_ref.array_reg[10]);
//            $fdisplay(file_output,"regfile11: %h",inst_scc.sccpu.cpu_ref.array_reg[11]);
//            $fdisplay(file_output,"regfile12: %h",inst_scc.sccpu.cpu_ref.array_reg[12]);
//            $fdisplay(file_output,"regfile13: %h",inst_scc.sccpu.cpu_ref.array_reg[13]);
//            $fdisplay(file_output,"regfile14: %h",inst_scc.sccpu.cpu_ref.array_reg[14]);
//            $fdisplay(file_output,"regfile15: %h",inst_scc.sccpu.cpu_ref.array_reg[15]);
//            $fdisplay(file_output,"regfile16: %h",inst_scc.sccpu.cpu_ref.array_reg[16]);
//            $fdisplay(file_output,"regfile17: %h",inst_scc.sccpu.cpu_ref.array_reg[17]);
//            $fdisplay(file_output,"regfile18: %h",inst_scc.sccpu.cpu_ref.array_reg[18]);
//            $fdisplay(file_output,"regfile19: %h",inst_scc.sccpu.cpu_ref.array_reg[19]);
//            $fdisplay(file_output,"regfile20: %h",inst_scc.sccpu.cpu_ref.array_reg[20]);
//            $fdisplay(file_output,"regfile21: %h",inst_scc.sccpu.cpu_ref.array_reg[21]);
//            $fdisplay(file_output,"regfile22: %h",inst_scc.sccpu.cpu_ref.array_reg[22]);
//            $fdisplay(file_output,"regfile23: %h",inst_scc.sccpu.cpu_ref.array_reg[23]);
//            $fdisplay(file_output,"regfile24: %h",inst_scc.sccpu.cpu_ref.array_reg[24]);
//            $fdisplay(file_output,"regfile25: %h",inst_scc.sccpu.cpu_ref.array_reg[25]);
//            $fdisplay(file_output,"regfile26: %h",inst_scc.sccpu.cpu_ref.array_reg[26]);
//            $fdisplay(file_output,"regfile27: %h",inst_scc.sccpu.cpu_ref.array_reg[27]);
//            $fdisplay(file_output,"regfile28: %h",inst_scc.sccpu.cpu_ref.array_reg[28]);
//            $fdisplay(file_output,"regfile29: %h",inst_scc.sccpu.cpu_ref.array_reg[29]);
//            $fdisplay(file_output,"regfile30: %h",inst_scc.sccpu.cpu_ref.array_reg[30]);
//            $fdisplay(file_output,"regfile31: %h",inst_scc.sccpu.cpu_ref.array_reg[31]);
//        end
//            end     
    
    
   MipsSuperRacing imr(
    clk_in,
    reset,
    btn_start,
    btn_left,
    btn_right,
    HSync,
    VSync,
    OutBlue,
    OutGreen,
    OutRed
);
endmodule
