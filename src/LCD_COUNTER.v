module LCD_COUNTER (
  input            CLK,
  input            VS, 
  input            HS,
  input            DE, 
  output reg [9:0] V_CNT,
  output reg [9:0] H_CNT,
  output reg       BORDER,
  output reg       ACTIV_C,
  output reg       ACTIV_V,
  output reg       SOF
); 

parameter H_OFF = 10'd200; 
parameter V_OFF = 10'd200; 
parameter H_BOR = 10'd500; 
parameter V_BOR = 10'd400; 

reg rHS;
reg rVS;

reg [9:0] H_CEN; //10'd450; 
reg [9:0] V_CEN; //10'd250; 

always @( posedge CLK ) begin 
  ACTIV_V <=  HS & VS; 
  rHS <= HS;
  rVS <= VS;
  // H
  if ( !rHS &&  HS ) begin  
    {H_CNT, H_CEN} <= {10'd0, H_CNT}; 
  end
  else if (DE) 
    H_CNT <= H_CNT + 1; 
  // V
  if ( !rVS && VS ) begin  
    {V_CNT, V_CEN} <= {10'd0, V_CNT}; 
  end
  else if ( (!rHS && HS) && (VS) )  
    V_CNT <= V_CNT + 1; 
	
	//--- BORDER ---
	BORDER <= (
	 (V_CNT < (V_CEN/2-V_BOR/2)) || (V_CNT >= (V_CEN/2+V_BOR/2+18)) ||
	 (H_CNT < (H_CEN/2-H_BOR/2)) || (H_CNT >= (H_CEN/2+H_BOR/2))
	 ) ?
	 1 : 0; 
	//--- V TRIGGER ---	
	ACTIV_C <= ( 
   ((H_CNT >= (H_CEN/2-H_OFF/2)) && (H_CNT < (H_CEN/2+H_OFF/2))) &&
	 ((V_CNT >= (V_CEN/2-V_OFF/2)) && (V_CNT < (V_CEN/2+V_OFF/2)))
   ) ?
   1 : 0; 
end

always @( posedge CLK ) begin 
  if ( V_CNT == 61 && H_CNT == 69 ) 
    SOF <= 1;
  else
    SOF <= 0;
end


endmodule 
