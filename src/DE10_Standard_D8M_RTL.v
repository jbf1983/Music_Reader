module DE10_Standard_D8M_RTL ( 
	//////////// CLOCK //////////
	input 		          		CLOCK_50,
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// Seg7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// VGA //////////
	output		          		VGA_CLK,
	output		          		VGA_BLANK_N,
	output		          		VGA_SYNC_N,
	output		          		VGA_HS,
	output		          		VGA_VS,	
  output		     [7:0]		VGA_R,
	output		     [7:0]		VGA_G,
	output		     [7:0]		VGA_B,

	//////////// GPIO, GPIO connect to D8M-GPIO //////////
	inout 		          		CAMERA_I2C_SCL,
	inout 		          		CAMERA_I2C_SDA,
	output		          		CAMERA_PWDN_n,
	output		          		MIPI_CS_n,
	inout 		          		MIPI_I2C_SCL,
	inout 		          		MIPI_I2C_SDA,
	output		          		MIPI_MCLK,
	input 		          		MIPI_PIXEL_CLK,
	input 		     [9:0]		MIPI_PIXEL_D,
	input 		          		MIPI_PIXEL_HS,
	input 		          		MIPI_PIXEL_VS,
	output		          		MIPI_REFCLK,
	output		          		MIPI_RESET_n,

	//////////// IR //////////
	input 		          		IRDA_RXD
);

wire          READ_Request;
wire 	[7:0]   BLUE;
wire 	[7:0]   GREEN;
wire 	[7:0]   RED;
wire          RESET_N; 
wire          RESET_N_DELAY; 
  
wire          I2C_RELEASE;  
wire          CAMERA_I2C_SCL_MIPI; 
wire          CAMERA_I2C_SCL_AF;
wire          CAMERA_MIPI_RELEASE;
wire          MIPI_BRIDGE_RELEASE;  
wire          VCM_RELEASE; 
wire          AUTO_FOC;
wire          D8M_PIXEL_HZ; 
wire  [9:0]   RD_DATA; 
wire  [19:0]  WR_ADDR;
wire  [19:0]  RD_ADDR;  

wire	[15:0]  SDRAM_RD_DATA;
wire			    SDRAM_CTRL_CLK;

wire  [12:0]  VGA_H_CNT;			
wire  [12:0]  VGA_V_CNT;	
  
wire          LUT_MIPI_PIXEL_HS;
wire          LUT_MIPI_PIXEL_VS;
wire  [9:0]   LUT_MIPI_PIXEL_D;

wire          DLY_RST_0;	
wire          DLY_RST_1;
wire          DLY_RST_2;
          
wire          READY;

wire          ir_data_ready; //IR data_ready flag
wire  [31:0]  ir_hex_data; //seg data input
reg   [23:0]  seg_data;
reg    [5:0]  seg_ena;
wire  [19:0]  expo;
wire  [12:0]  gain;
wire   [7:0]  test_pattern;

wire          expo_ena;
wire          gain_ena;
reg           set_reg_tog;
reg           set_reg_tog_r;
reg           set_reg_pul;

reg    [7:0]  counter;

assign LUT_MIPI_PIXEL_HS = MIPI_PIXEL_HS;
assign LUT_MIPI_PIXEL_VS = MIPI_PIXEL_VS;
assign LUT_MIPI_PIXEL_D = MIPI_PIXEL_D;

assign CAMERA_PWDN_n = 1; 
assign MIPI_CS_n = 0; 
assign MIPI_RESET_n = RESET_N;

assign I2C_RELEASE = CAMERA_MIPI_RELEASE & MIPI_BRIDGE_RELEASE; 
assign CAMERA_I2C_SCL = (I2C_RELEASE) ? CAMERA_I2C_SCL_AF : CAMERA_I2C_SCL_MIPI;   

RESET_DELAY i_RESET_DELAY (
  .RESET_N  ( KEY[0] && ~set_reg_pul ),
  .CLK      ( CLOCK3_50 ), 
  .READY0   ( RESET_N ),
  .READY1   ( RESET_N_DELAY ) 
); 
  
MIPI_PLL i_MIPI_PLL (
  .refclk    ( CLOCK_50 ),
  .rst       ( 0 ),
  .outclk_0  ( MIPI_REFCLK ) // 20 MHz
);

VGA_PLL i_VGA_PLL (
  .refclk    ( CLOCK_50 ),
  .rst       ( 0 ),
  .outclk_0  ( VGA_CLK ) // 25 MHz
);

SDRAM_PLL i_SDRAM_PLL (
  .refclk   ( CLOCK2_50 ),  
  .rst      ( 0 ),      
  .outclk_0 ( SDRAM_CTRL_CLK ), // 100 MHz
  .outclk_1 ( DRAM_CLK ) // 100 MHz 
);

//------ MIPI BRIGE & CAMERA SETTING
MIPI_BRIDGE_CAMERA_CONFIG i_MIPI_BRIDGE_CAMERA_CONFIG (
  .RESET_N            ( DLY_RST_0 ),
  .CLK_50             ( CLOCK4_50 ), 
  .MIPI_I2C_SCL       ( MIPI_I2C_SCL ), 
  .MIPI_I2C_SDA       ( MIPI_I2C_SDA ), 
  .MIPI_I2C_RELEASE   ( MIPI_BRIDGE_RELEASE ),  
  .CAMERA_I2C_SCL     ( CAMERA_I2C_SCL_MIPI ),
  .CAMERA_I2C_SDA     ( CAMERA_I2C_SDA ),
  .CAMERA_I2C_RELEASE ( CAMERA_MIPI_RELEASE ),
  .VCM_RELEASE        ( VCM_RELEASE ),
  .iREG_EXPO          ( expo ),
  .iREG_GAIN          ( gain ),
  .iREG_TEST_PATTERN  ( test_pattern )
);

//------ AUTO FOCUS ENABLE
AUTO_FOCUS_ENABLE i_AUTO_FOCUS_ENABLE ( 
  .CLK_50       ( CLOCK4_50 ), 
  .I2C_RELEASE  ( I2C_RELEASE ), 
  .AUTO_FOC     ( AUTO_FOC )
); 

 //------ AUTO FOCUS ADJUST
AUTO_FOCUS_ADJUST i_AUTO_FOCUS_ADJUST (
  .CLK_50               ( CLOCK4_50 ),
  .RESET_N_IMG_PROC     ( KEY[2] ),
  .RESET_N              ( I2C_RELEASE ), 
  .RESET_SUB_N          ( I2C_RELEASE ), 
  .AUTO_FOC             ( KEY[1] & AUTO_FOC ),
  .SW_0                 ( SW[0] ), 
  .SW_1                 ( SW[1] ),
  .SW_2                 ( SW[2] ),
  .VIDEO_HS             ( VGA_HS),
  .VIDEO_VS             ( VGA_VS),
  .VIDEO_DE             ( READ_Request ),
  .VIDEO_CLK            ( VGA_CLK ),

  .iR                   ( RED [7:0] ),
  .iG                   ( GREEN[7:0] ),
  .iB                   ( BLUE[7:0] ),
  .oR                   ( VGA_R[7:0] ), 
  .oG                   ( VGA_G[7:0] ), 
  .oB                   ( VGA_B[7:0] ),    
  .READY                ( READY ),
  .SCL                  ( CAMERA_I2C_SCL_AF ), 
  .SDA                  ( CAMERA_I2C_SDA )
);
 				
RESET_DELAY_DRAM	i_RESET_DELAY_DRAM (	
  .iCLK   ( CLOCK4_50 ),
	.iRST   ( KEY[0] && ~set_reg_pul ),
	.oRST_0 ( DLY_RST_0 ),
	.oRST_1 ( DLY_RST_1 ),
	.oRST_2 ( DLY_RST_2 )
);
	
//------SDRAM CONTROLLER --
SDRAM_CONTROL	i_SDRAM_CONTROL (	//	HOST Side						
  .RESET_N      ( KEY[0] && ~set_reg_pul ),
  .CLK          ( SDRAM_CTRL_CLK ), 
  // FIFO Write Side 1
  .WR1_DATA     ( LUT_MIPI_PIXEL_D[9:0] ),
  .WR1          ( LUT_MIPI_PIXEL_HS & LUT_MIPI_PIXEL_VS ),
  .WR1_ADDR     ( 0 ),
  .WR1_MAX_ADDR ( 640*480 ),
  .WR1_LENGTH   ( 256 ), 
  .WR1_LOAD     ( ~I2C_RELEASE ),
  .WR1_CLK      ( MIPI_PIXEL_CLK ),
  // FIFO Read Side 1
  .RD1_DATA     ( RD_DATA[9:0] ),
  .RD1          ( READ_Request ),
  .RD1_ADDR     ( 0 ),
  .RD1_MAX_ADDR ( 640*480 ),
  .RD1_LENGTH   ( 256  ),
  .RD1_LOAD     ( ~I2C_RELEASE ),
  .RD1_CLK      ( VGA_CLK ),
  // SDRAM Side
  .SA          ( DRAM_ADDR ),
  .BA          ( DRAM_BA ),
  .CS_N        ( DRAM_CS_N ),
  .CKE         ( DRAM_CKE ),
  .RAS_N       ( DRAM_RAS_N ),
  .CAS_N       ( DRAM_CAS_N ),
  .WE_N        ( DRAM_WE_N ),
  .DQ          ( DRAM_DQ ),
  .DQM         ( {DRAM_UDQM,DRAM_LDQM} )
);
															
//-- RAW TO RGB ---
RAW2RGB_ALL	i_RAW2RGB_ALL (	
  .RST            ( VGA_VS ),
  .CCD_PIXCLK     ( VGA_CLK ),
  .mCCD_DATA      ( RD_DATA[9:0] ),
  .VGA_CLK        ( VGA_CLK ),
  .READ_Request   ( READ_Request ),
  .VGA_VS         ( VGA_VS ),	
  .VGA_HS         ( VGA_HS ), 	
  .oRed           ( RED[7:0] ),
  .oGreen         ( GREEN[7:0] ),
  .oBlue          ( BLUE[7:0] ),
  .oDVAL          ( )
);							
							
//----- VGA Controller ---
VGA_CONTROLLER i_VGA_CONTROLLER (
  .iCLK         ( VGA_CLK ),		 				 
  .oVGA_H_SYNC  ( VGA_HS ),
  .oVGA_V_SYNC  ( VGA_VS ),	       
  .oRequest     ( READ_Request ),			 
  .iRST_N       ( I2C_RELEASE ),
  .oVGA_SYNC    ( VGA_SYNC_N ),
  .oVGA_BLANK   ( VGA_BLANK_N )			 	
);		

//------VS FREQUENCY TEST = 60HZ --
FPS_MONITOR i_FPS_MONITOR ( 
  .clk50      ( CLOCK4_50 ),
  .vs         ( LUT_MIPI_PIXEL_VS ),
  .fps        ( ),
  .hex_fps_h  ( ), // HEX1
  .hex_fps_l  ( ) // HEX0
);

//--LED DISPLAY--
CLK_DIV i_CLK_DIV_LED (  
  .CLK_IN   ( MIPI_PIXEL_CLK ), // 25 MHz
  .CLK_DIV  ( 25000000 ),
  .CLK_OUT  ( D8M_PIXEL_HZ ) // 1 Hz
);

assign LEDR = { D8M_PIXEL_HZ, CAMERA_MIPI_RELEASE, MIPI_BRIDGE_RELEASE, ir_data_ready }; 

// IR
IR_RX i_IR_RX (
  .iCLK         ( CLOCK_50 ), 
  .iRST_n       ( KEY[0] ),        
  .iIRDA        ( IRDA_RXD ), 
  .oDATA_READY  ( ir_data_ready ),
  .oDATA        ( ir_hex_data )        
);

IR_DECODER i_IR_DECODER (
  .iRST_n             ( KEY[0] ),        
  .iDATA              ( ir_hex_data[23:16] ), 
  .iDATA_READY        ( ir_data_ready ),
  .oEXPO              ( expo ),
  .oGAIN              ( gain ),
  .oTEST_PATTERN      ( test_pattern ),
  .oEXPO_ENA          ( expo_ena ),
  .oGAIN_ENA          ( gain_ena ),
  .oSET_REG_TOG       ( set_reg_tog )
);

always @(posedge CLOCK_50)  
  begin
    set_reg_tog_r <= set_reg_tog;
    if (set_reg_tog_r != set_reg_tog) begin
      // tog detected, load counter, pulse high for first time
      counter <= 100;
      set_reg_pul <= 1'b1;
    end
    else if (counter > 0) 
      // decrement counter, pulse high
      counter <= counter - 1;
    else 
      // end of counter, pulse low
      set_reg_pul <= 1'b0;
  end

always @(posedge CLOCK_50 or negedge KEY[0])
  begin
    if (!KEY[0])
      seg_ena <= 6'b000000;
    else if (expo_ena) begin
      seg_ena <= 6'b011111;
      seg_data <= expo;
    end
    else if (gain_ena) begin
      seg_ena <= 6'b001111;
      seg_data <= gain;
    end
    else
      seg_ena <= 6'b000000;
  end

IR_SEG_HEX i_IR_SEG_HEX0 (
  .iENA   ( seg_ena[0] ),
  .iDIG   ( seg_data[3:0] ),         
  .oHEX_D ( HEX0 )
);  

IR_SEG_HEX i_IR_SEG_HEX1 (                           
  .iENA   ( seg_ena[1] ),
  .iDIG   ( seg_data[7:4] ),
  .oHEX_D ( HEX1 )
);

IR_SEG_HEX i_IR_SEG_HEX2 (                       
  .iENA   ( seg_ena[2] ),
  .iDIG   ( seg_data[11:8] ),
  .oHEX_D ( HEX2 )
);

IR_SEG_HEX i_IR_SEG_HEX3 (                              
  .iENA   ( seg_ena[3] ),
  .iDIG   ( seg_data[15:12] ),
  .oHEX_D ( HEX3 )
);

IR_SEG_HEX i_IR_SEG_HEX4 (                              
  .iENA   ( seg_ena[4] ),
  .iDIG   ( seg_data[19:16] ),
  .oHEX_D ( HEX4 )
);

IR_SEG_HEX i_IR_SEG_HEX5 (                               
  .iENA   ( seg_ena[5] ),
  .iDIG   ( seg_data[23:20] ),
  .oHEX_D ( HEX5 )
);

endmodule
