`timescale 1ns / 1ps
/*******************************************************************
 * Create Date: 	2016/05/03
 * Design Name: 	Pipeline CPU
 * Module Name:		Pipe_CPU 
 * Project Name: 	Architecture Project_3 Pipeline CPU
 
 * Please DO NOT change the module name, or your'll get ZERO point.
 * You should add your code here to complete the project 3.
 ******************************************************************/
module Pipe_CPU(
        clk_i,
		rst_i
		);
    
/****************************************
*            I/O ports                  *
****************************************/
input clk_i;
input rst_i;

/****************************************
*          Internal signal              *
****************************************/

/**** IF stage ****/
//control signal...
wire [32-1:0] PC_Source ;
wire [32-1:0] pc_addr;
wire [32-1:0] instr;
wire [31:0] addered_pc, addered2_pc;
wire [63:0] IF_ID_IN, IF_ID_Reg;

/**** ID stage ****/
//control signal...
wire [4:0] RF_RDaddr;
wire [32-1:0] mux_dataMem_result_w;
wire ctrl_register_write_w;
wire [31:0] RF_RSdata;
wire [31:0] RF_RTdata;
wire [2:0] AC_ALUop;
wire Decoder_ALUSrc, Decoder_RegDst, Decoder_Branch, Decoder_MemRead, Decoder_MemWrite, Decoder_MemtoReg;
wire [31:0] Extended_data;
wire [152:0] ID_EX_IN, ID_EX_Reg;

/**** EX stage ****/
//control signal...
wire [31:0] ALU_Src1, ALU_Src2, ALU_Src2_mux, ALU_result;
wire [3:0] ALU_ctrl;
wire ALU_zero;
wire [31:0] Adder2_src, new_pc;
wire [4:0] Reg_Back;
wire [106:0] EX_MEM_IN, EX_MEM_Reg;

/**** MEM stage ****/
//control signal...
wire [31:0] DataMemory_o;
wire [70:0] MEM_WB_IN, MEM_WB_Reg;

/**** WB stage ****/
//control signal...


/**** Data hazard ****/
//control signal...


/****************************************
*       Instantiate modules             *
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(addered_pc),
        .data1_i(EX_MEM_Reg[101:70]),
        .select_i(Mux_PC_Source_select),
        .data_o(PC_Source)
        );
		
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(PC_Source) ,   
	    .pc_out_o(pc_addr) 
	    );

Instr_Memory IM(
        .pc_addr_i(pc_addr),  
	    .instr_o(instr)    
	    );
			
Adder Add_pc(
		.src1_i(pc_addr),     
	    .src2_i(4),     
	    .sum_o(addered_pc)    
		);

		
Pipe_Reg #(.size(64)) IF_ID(       
		.rst_i(rst_i),
		.clk_i(clk_i),   
		.data_i(IF_ID_IN),
		.data_o(IF_ID_Reg)
		);
		
//Instantiate the components in ID stage
Reg_File RF(
        .clk_i(clk_i),
		.rst_i(rst_i),
		.RSaddr_i(IF_ID_Reg[25:21]) ,
		.RTaddr_i(IF_ID_Reg[20:16]) ,
		.RDaddr_i(RF_RDaddr) ,
		.RDdata_i(mux_dataMem_result_w),
		.RegWrite_i(ctrl_register_write_w),
		.RSdata_o(RF_RSdata) ,
		.RTdata_o(RF_RTdata)
        );

Decoder Control(
		.instr_op_i(IF_ID_Reg[31:26]), 
	    .RegWrite_o(ctrl_register_write_w), 
	    .ALU_op_o(AC_ALUop),   
	    .ALUSrc_o(Decoder_ALUSrc),   
	    .RegDst_o(Decoder_RegDst),   
		.Branch_o(Decoder_Branch), 
		.MemWrite_o(Decoder_MemWrite),
		.MemRead_o(Decoder_MemRead),
		.MemtoReg_o(Decoder_MemtoReg)
		);

Sign_Extend Sign_Extend(
		.data_i(IF_ID_Reg[15:0]),
        .data_o(Extended_data)
		);	


Pipe_Reg #(.size(153)) ID_EX(
		.rst_i(rst_i),
		.clk_i(clk_i),   
		.data_i(ID_EX_IN),
		.data_o(ID_EX_Reg)
		);
		
//Instantiate the components in EX stage	   
ALU ALU(
		.src1_i(ALU_Src1),
	    .src2_i(ALU_Src2),
	    .ctrl_i(ALU_ctrl),
	    .result_o(ALU_result),
		.zero_o(ALU_zero)
		);
		
ALU_Ctrl ALU_Control(
		.funct_i(ID_EX_Reg[20:15]),   
        .ALUOp_i(ID_EX_Reg[145:143]),   
        .ALUCtrl_o(ALU_ctrl) 
		);
		
Shift_Left_Two_32 Shifter(
        .data_i(ID_EX_Reg[46:15]),
        .data_o(Adder2_src)
        ); 
		
Adder Adder2(
		.src1_i(ID_EX_Reg[142:111]),     
	    .src2_i(Adder2_src),     
	    .sum_o(new_pc)    
		);

MUX_3to1 #(.size(32)) Mux1(
		 .data0_i(ID_EX_Reg[110:79]),
         .data1_i(),
   	     .data2_i(),
         .select_i(),
         .data_o(ALU_Src1)
        );
		
MUX_3to1 #(.size(32)) Mux2(
		 .data0_i(ID_EX_Reg[78:47]),
         .data1_i(),
   	     .data2_i(),
         .select_i(),
         .data_o(ALU_Src2_mux)
        );
		
MUX_2to1 #(.size(32)) Mux4(
		 .data0_i(ALU_Src2_mux),
         .data1_i(ID_EX_Reg[46:15]),
         .select_i(ID_EX_Reg[146]),
         .data_o(ALU_Src2)
        );
		
MUX_2to1 #(.size(5)) Mux3(
		 .data0_i(ID_EX_Reg[9:5]),
         .data1_i(ID_EX_Reg[4:0]),
         .select_i(ID_EX_Reg[147]),
         .data_o(Reg_Back)
        );

Pipe_Reg #(.size(107)) EX_MEM(
		.rst_i(rst_i),
		.clk_i(clk_i),   
		.data_i(EX_MEM_IN),
		.data_o(EX_MEM_Reg)
		);
			   
//Instantiate the components in MEM stage
Data_Memory DM(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.addr_i(EX_MEM_Reg[69:38]),
		.data_i(EX_MEM_Reg[36:5]),
		.MemRead_i(EX_MEM_Reg[104]),
		.MemWrite_i(EX_MEM_Reg[103]),
		.data_o(DataMemory_o)
	    );

Pipe_Reg #(.size()) MEM_WB(
        .rst_i(rst_i),
		.clk_i(clk_i),   
		.data_i(MEM_WB_IN),
		.data_o(MEM_WB_Reg)
		);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux5(
		 .data0_i(MEM_WB_Reg[68:37]),
         .data1_i(MEM_WB_Reg[36:5]),
         .select_i(MEM_WB_Reg[70]),
         .data_o(mux_dataMem_result_w)
        );

/****************************************
*         Signal assignment             *
****************************************/
assign Mux_PC_Source_select= EX_MEM_Reg[37] & EX_MEM_Reg[102];

/* PC+4: IF_ID_IN[63:32]
   instr: IF_ID_IN[31:0] */
assign IF_ID_IN = {addered_pc,instr};

/* MemtoReg: ID_EX_Reg[152]
   RegWrite: ID_EX_Reg[151] 
   MemRead: ID_EX_Reg[150] 
   MemWrite: ID_EX_Reg[149] 
   Branch: ID_EX_Reg[148] 
   RegDst: ID_EX_Reg[147] 
   ALUSrc: ID_EX_Reg[146] 
   ALUop: ID_EX_Reg[145:143] ; 
   IF_ID_Reg[63:32](PC+4): ID_EX_Reg[142:111]
   RSdata: ID_EX_Reg[110:79]
   RTdata: ID_EX_Reg[78:47]
   Extended_data: ID_EX_Reg[46:15]
   IF_ID_Reg[25:21]: ID_EX_Reg[14:10]
   IF_ID_Reg[20:16]: ID_EX_Reg[9:5]
   IF_ID_Reg[15:11]: ID_EX_Reg[4:0] */
assign ID_EX_IN = {Decoder_MemtoReg,ctrl_register_write_w,Decoder_MemRead,Decoder_MemWrite,Decoder_Branch,Decoder_RegDst,Decoder_ALUSrc,AC_ALUop,IF_ID_Reg[63:32],RF_RSdata,RF_RTdata,Extended_data,IF_ID_Reg[25:21],IF_ID_Reg[20:16],IF_ID_Reg[15:11]};

/* MemtoReg: EX_MEM_Reg[106]
   RegWrite: EX_MEM_Reg[105]
   MemRead: EX_MEM_Reg[104]
   MemWrite: EX_MEM_Reg[103]
   Branch: EX_MEM_Reg[102]
   new_pc(branch): EX_MEM_Reg[101:70]
   ALU_result: EX_MEM_Reg[69:38]
   ALU_zero: EX_MEM_Reg[37]
   ALU_Src2_mux(MemWrite): EX_MEM_Reg[36:5]
   Reg_Back: EX_MEM_Reg[4:0]
   */
assign EX_MEM_IN = {ID_EX_Reg[152],ID_EX_Reg[151],ID_EX_Reg[150],ID_EX_Reg[149],ID_EX_Reg[148],new_pc,ALU_result,ALU_zero,ALU_Src2_mux,Reg_Back};

/* MemtoReg: MEM_WB_Reg[70]
   RegWrite: MEM_WB_Reg[69]
   DataMemory_o: MEM_WB_Reg[68:37]
   ALU_result: MEM_WB_Reg[36:5]
   Reg_Back: MEM_WB_Reg[4:0]
*/
assign MEM_WB_IN = {EX_MEM_Reg[106],EX_MEM_Reg[105],DataMemory_o,EX_MEM_Reg[69:38],EX_MEM_Reg[4:0]};
endmodule

