//Subject:     Architecture project 2 - MUX 2to1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
     
module MUX_3to1(
               data0_i,
               data1_i,
			   data2_i,
               select_i,
               data_o
               );

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data0_i;          
input   [size-1:0] data1_i;
input   [size-1:0] data2_i;
input   [1:0]      select_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;

//Main function
always@(data0_i or data1_i or data2_i or select_i )begin
	 case(select_i)
       
          1'b00:  data_o = data0_i;
          1'b01:  data_o = data1_i;
		  1'b10:  data_o = data2_i;
          
      endcase
end
	

endmodule 