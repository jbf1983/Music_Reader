module CLK_DIV ( 
  input         CLK_IN,
  input  [31:0] CLK_DIV,
  output reg    CLK_OUT
);

reg [31:0] CLK_COUNT; 

always @(posedge CLK_IN)  
  begin
    if (CLK_COUNT > CLK_DIV / 2) begin 
      CLK_COUNT <= 0;  
      CLK_OUT <= ~CLK_OUT; 
    end
    else   
      CLK_COUNT <= CLK_COUNT + 1;
  end		
	
endmodule 
	
	
