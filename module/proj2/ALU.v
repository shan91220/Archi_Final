//Subject:     Architecture project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire            zero_o;
assign zero_o = (result_o == 0)? 1:0;
//Parameter
//Main function
always@(src1_i or src2_i or ctrl_i)begin
	
	if(ctrl_i == 4'b0000) begin //and
		result_o = src1_i & src2_i;
	end
	else if(ctrl_i == 4'b0001) begin //or
		result_o = src1_i | src2_i;
	end
	else if(ctrl_i == 4'b0010) begin //add
		result_o = src1_i + src2_i;
	end
	else if(ctrl_i == 4'b0110) begin //sub
		result_o = src1_i - src2_i;
	end
	else if(ctrl_i == 4'b0111) begin //slt
		result_o = (src1_i < src2_i)? 1:0;
	end
	
end

endmodule