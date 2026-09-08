module RAW2RGB_ALL(	
  input   [9:0] mCCD_DATA,
  input			    CCD_PIXCLK,
  input			    RST,
  input         VGA_CLK, 
  input         READ_Request,
  input         VGA_VS,	
  input         VGA_HS,	
  output  [7:0] oRed,
  output  [7:0] oGreen,
  output  [7:0] oBlue
);

  wire  [9:0]	  mDAT0_0;
  wire  [9:0]	  mDAT0_1;
  wire  [9:0]	  mCCD_R;
  wire  [9:0]	  mCCD_G; 
  wire  [9:0]	  mCCD_B;
  wire  [7:0]   red;
  wire  [7:0]   green;
  wire  [7:0]   blue;
  reg			      mDVAL;
  reg	  [10:0]  mX_Cont;
  reg	  [10:0]	mY_Cont;
  reg           rDVAL ; 

//-------- RGB OUT ---- 
assign oRed	  = (mY_Cont > 1) ? mCCD_R[9:2] : 0;
assign oGreen = (mY_Cont > 1) ? mCCD_G[9:2] : 0;
assign oBlue  = (mY_Cont > 1) ? mCCD_B[9:2] : 0;

//-----COUNTER ----
always @(negedge VGA_VS or posedge VGA_CLK ) begin
  if ( !VGA_VS ) begin 
    mX_Cont <= 0;
    mY_Cont <= 0;
  end 
  else begin 
    rDVAL <= READ_Request; 
    if ( !rDVAL )
      mX_Cont <= 0;  
    else 
      mX_Cont <= mX_Cont + 1;   
    if ( rDVAL && !READ_Request )  
      mY_Cont <= mY_Cont + 1; 
  end 
end 

//----3 2-PORT-LINE-BUFFER----  
LINE_BUFFER_ALL i_LINE_BUFFER_ALL (	
  .CCD_PIXCLK   ( VGA_CLK ),
  .mCCD_FVAL    ( VGA_VS ),
  .mCCD_LVAL    ( VGA_HS ), 	
  .X_Cont       ( mX_Cont ), 
  .mCCD_DATA    ( mCCD_DATA ),
  .VGA_CLK      ( VGA_CLK ), 
  .READ_Request ( READ_Request ),
  .VGA_VS       ( VGA_VS ),	
  .READ_Cont    ( mX_Cont ),
  .V_Cont       ( mY_Cont ),
  .taps0x       ( mDAT0_1 ),
  .taps1x       ( mDAT0_0 )
);					

//---- BIN GEN ---  						
RAW2RGB_BIN i_RAW2RGB_BIN (
  .CLK    ( VGA_CLK ), 
  .RST_N  ( RST ), 
  .D0     ( mDAT0_0 ),
  .D1     ( mDAT0_1 ),
  .X      ( mX_Cont [0] ),
  .Y      ( mY_Cont [0] ),
  .B      ( mCCD_R ),
  .G      ( mCCD_G ), 
  .R      ( mCCD_B )
);               

endmodule
