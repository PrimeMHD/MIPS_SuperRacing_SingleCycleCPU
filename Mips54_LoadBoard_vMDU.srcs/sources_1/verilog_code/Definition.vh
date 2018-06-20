//////////////////////////////////////////////////////////////////////////////////
// Company:Tongji University
// Engineer:Mi HD
//
// Create Date: 2018/04/25 16:11:18
// Module Name: DEFINITION
// Project Name: MIPS VERILOG CPU
// Target Devices:DIGILENT NEXYS 4 DDR
// Tool Versions:Vivado 2016.2
// Description:MIPS CPU 宏定义常�?

// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

//******MIPS*********//
//SPECIAL FUNC CODE(instr[5:0])
`define  ADDU       6'b100001
`define  SUBU       6'b100011
`define  ADD        6'b100000
`define  SUB        6'b100010
`define  AND        6'b100100
`define  OR         6'b100101
`define  XOR        6'b100110
`define  NOR        6'b100111
`define  SLT        6'b101010
`define  SLTU       6'b101011
`define  SRL        6'b000010
`define  SRA        6'b000011
`define  SLL        6'b000000
`define  SLLV       6'b000100
`define  SRLV       6'b000110
`define  SRAV       6'b000111
`define  JR         6'b001000



//R-TYPE OPCODE FILED
`define SPECIAL    6'b000000
//I-TYPE & J-TYPE OPCODE FIELD  (instr[31:26])
`define ADDI       6'b001000
`define ADDIU      6'b001001
`define ANDI       6'b001100
`define ORI        6'b001101
`define XORI       6'b001110
`define LW         6'b100011
`define SW         6'b101011
`define BEQ        6'b000100
`define BNE        6'b000101
`define SLTI       6'b001010
`define SLTIU      6'b001011
`define LUI        6'b001111
`define J          6'b000010
`define JAL        6'b000011







//ALU OPCODE
`define   _ADDU      4'b0000    //r=a+b unsigned
`define   _ADD       4'b0010    //r=a+b signed
`define   _SUBU      4'b0001    //r=a-b unsigned
`define   _SUB       4'b0011    //r=a-b signed
`define   _AND       4'b0100    //r=a&b
`define   _OR        4'b0101    //r=a|b
`define   _XOR       4'b0110    //r=a^b
`define   _NOR       4'b0111    //r=~(a|b)
`define   _LUI       4'b1000    //r={b[15:0],16'b0}
`define   _SLT       4'b1011    //r=(a-b<0)?1:0 signed
`define   _SLTU      4'b1010    //r=(a-b<0)?1:0 unsigned
`define   _SRA       4'b1100    //r=b>>>a
`define   _SLL       4'b1110    //r=b<<a
`define   _SRL       4'b1101    //r=b>>a

//ExcCode for CP0
`define  _SYSCALL	 5'b01000
`define  _BREAK		 5'b01001
`define  _TEQ		 5'b01101


//OTHER DEFINITION
`define   SIGN       1'b1
`define   UNSIGN     1'b0
`define   DISABLED	 1'b0
`define   ENABLED	 1'b1
`define   YES		 1'b1
`define   NO         1'b0
`define   UNUSED32   32'b0




/*NOT USED IN 31 INSTRUCTIONS*/
/*USED IN MIPS54*/


//mul_div_contorl_signal
`define 	MD_MUL       3'h1
`define 	MD_MULTU     3'h2
`define 	MD_DIV		 3'h3
`define 	MD_DIVU	     3'h4
`define 	MD_MTHI		 3'h5
`define     MD_MTLO		 3'h6
`define 	MD_NO	     3'h0




`define SPECIAL2   6'b011100
`define CP0       6'b010000
//REGIMM OP LIST 20-16
`define  BGEZ       6'b000001
//COP0 OP LIST
`define ERET       6'b011000  //5-0&&25TH=1
`define MFC0       5'b00000   //20-16
`define MTC0       5'b00100
//SPECIAL FUNC CODE(instr[5:0])
`define  MULTU      6'b011001
`define  DIV        6'b011010
`define  DIVU       6'b011011
`define  MFHI       6'b010000
`define  MFLO       6'b010010
`define  MTHI       6'b010001
`define  MTLO       6'b010011
`define  BREAK      6'b001101
`define  SYSCALL    6'b001100
`define  TEQ        6'b110100
`define  JALR       6'b001001
//SPECIAL 2 FUNC CODE(instr[5:0])
`define  CLZ        6'b100000
`define  MUL        6'b000010


//I-TYPE & J-TYPE OPCODE FIELD  (instr[31:26])
`define LB         6'b100000//    Load Byte Function=6'h24
`define LBU        6'b100100//    1Load Byte Unsigned
`define LH         6'b100001//    Load high
`define LHU        6'b100101//    Load High Unsigned
`define SB         6'b101000//    Send Byte
`define SH         6'b101001//    Send High
`define BGEZ       6'b000001

/*NOT USED IN 31 INSTRUCTIONS*/

//Constant In Application
// ball speed direction
`define RIGHT 1'b1
`define LEFT  1'b0
`define UP    1'b0
`define DOWN  1'b1



`define vga_in_datamean_user   2'b00
`define vga_in_datamean_enemy1 2'b01
`define vga_in_datamean_road   2'b10


`define WhichGmemBlockNow_caruser   	3'b000
`define WhichGmemBlockNow_carenemy1 	3'b001
`define WhichGmemBlockNow_carcollision  3'b010
`define WhichGmemBlockNow_bgroad    	3'b011
`define WhichGmemBlockNow_bgstart   	3'b100
`define WhichGmemBlockNow_bgend   		3'b101





`define state_ready 2'b00
`define state_during 2'b01
`define state_collision 2'b10
`define state_over 2'b11

`define car_width_pixel 90
`define car_height_pixel 160
`define to_right 2'b00
`define to_left 2'b01
`define stay_straight 2'b10
`define RIGHT_BOUND 540
`define LEFT_BOUND 20
`define UP_BOUND 10
`define DOWN_BOUND 480

`define car_right_blank 6
`define car_left_blank 6


`define   BLACK     12'b0000_0000_0000;
`define   BLUE      12'b0000_0000_1111;
`define   GREEN     12'b0000_1111_0000;
`define   DIAN      12'b0000_1111_1111;
`define   RED       12'b1111_0000_0000;
`define   PURPLE    12'b1111_0000_1111;
`define   YELLOW    12'b1111_1111_0000;
`define   WHITE     12'b1111_1111_1111;

`define PAL  640;//Pixels/Active Line (pixels)
`define LAF  480;//Lines/Active Frame (lines)
`define PLD  800;//Pixel/Line Divider
`define LFD  521;//Line/Frame Divider
`define HPW  96;//Horizontal synchro Pulse Width (pixels)
`define HFP  16;//Horizontal synchro Front Porch (pixels)
`define VPW  2;//Verical synchro Pulse Width (lines)
`define VFP  10;//Verical synchro Front Porch (lines)

// 7 seg LED definition
`define ZERO 7'b1000000
`define ONE 7'b1111001
`define TWO 7'b0100100
`define THREE 7'b0110000
`define FOUR 7'b0011001
`define FIVE 7'b0010010
`define SIX 7'b0000010
`define SEVEN 7'b1111000
`define EIGHT 7'b0000000
`define NINE 7'b0010000


`define GMEM_INIT_ADDR_BGEND    0
`define GMEM_INIT_ADDR_BGROAD   76806
`define GMEM_INIT_ADDR_BGSTART  153612
`define GMEM_INIT_ADDR_CARCOLLI 230418
`define GMEM_INIT_ADDR_CARUSER  244824
`define GMEM_INIT_ADDR_CARENEMY 259230
