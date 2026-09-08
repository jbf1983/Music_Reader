module MIPI_BRIDGE_CAMERA_CONFIG (
  input           RESET_N, 
  input           CLK_50, 
            
  output          MIPI_I2C_SCL, 
  inout           MIPI_I2C_SDA, 
  output          MIPI_I2C_RELEASE,  
  output          CAMERA_I2C_SCL,
  inout           CAMERA_I2C_SDA,
  output          CAMERA_I2C_RELEASE,
  
  output   [9:0]  STEP,
  output          VCM_RELEASE,

  input   [19:0]  iREG_EXPO,
  input   [12:0]  iREG_GAIN,
  input    [7:0]  iREG_TEST_PATTERN
); 
 
wire VCM_I2C_SCL; 
wire CAMERA_I2C_SCL_; 
wire CLK_400K; 

assign VCM_RELEASE = 1; 
//--Camera share  SCL -- 
assign CAMERA_I2C_SCL = (!VCM_RELEASE) ? VCM_I2C_SCL : CAMERA_I2C_SCL_;
 
//--D8M CAMERA I2C -- 
MIPI_CAMERA_CONFIG i_MIPI_CAMERA_CONFIG ( 
  .RESET_N              ( VCM_RELEASE & RESET_N & MIPI_I2C_RELEASE ),
	.TR_IN                ( ), 	
  .CLK_50               ( CLK_50 ),
	.CLK_400K             ( CLK_400K ),
  .I2C_SCL              ( CAMERA_I2C_SCL_ ), 
  .I2C_SDA              ( CAMERA_I2C_SDA),
  .INT_n                ( ),
	.MIPI_CAMERA_RELEASE  ( CAMERA_I2C_RELEASE ),
  .iREG_EXPO            ( iREG_EXPO ),
  .iREG_GAIN            ( iREG_GAIN ),
  .iREG_TEST_PATTERN    ( iREG_TEST_PATTERN )
);

//--MIPI BRIDGE I2C -- 
MIPI_BRIDGE_CONFIG  i_MIPI_BRIDGE_CONFIG ( 
  .RESET_N                    ( RESET_N ),  
  .CLK_400K                   ( CLK_400K ),
  .CLK_50                     ( CLK_50 ),
  .I2C_SCL                    ( MIPI_I2C_SCL ), 
  .I2C_SDA                    ( MIPI_I2C_SDA ),
	.MIPI_BRIDGE_CONFIG_RELEASE ( MIPI_I2C_RELEASE ), 
  .INT_n()
);

endmodule 
