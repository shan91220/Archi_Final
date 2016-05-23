//Subject:     Architecture project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter


//Select exact operation, please finish the following code
always@(funct_i or ALUOp_i) begin
    case(ALUOp_i)
		3'b000:   //lw sw addi 
            begin
					ALUCtrl_o = 4'b0010;
            end
		3'b001:   //beq 
            begin
					ALUCtrl_o = 4'b0110;
            end
		3'b100:   //slti
            begin
					ALUCtrl_o = 4'b0111;
            end
        3'b010:   //R-type: and, or, add, sub, slt
            begin
                case(funct_i)
                    6'b100100: ALUCtrl_o = 4'b0000; // AND
					6'b100101: ALUCtrl_o = 4'b0001; // OR
					6'b100000: ALUCtrl_o = 4'b0010; // ADD
					6'b100010: ALUCtrl_o = 4'b0110; // SUB
					6'b101010: ALUCtrl_o = 4'b0111; // SLT
                    default: ALUCtrl_o = 4'b1111;
                endcase
            end
        default:ALUCtrl_o = 4'b1111;
			
    endcase
end
endmodule
