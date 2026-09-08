module AUTO_FOCUS_ADJUST (
  input             CLK_50, 
  input             RESET_N_IMG_PROC, 
  input             RESET_N,      
  input             RESET_SUB_N,   
  input             AUTO_FOC,       
  input             SW_0,           
  input             SW_1,        
  input             SW_2,        
       
  input             VIDEO_HS,
  input             VIDEO_VS,
  input             VIDEO_CLK,
  input             VIDEO_DE, 
  input       [7:0] iR, 
  input       [7:0] iG, 
  input       [7:0] iB, 

  output reg  [7:0] oR, 
  output reg  [7:0] oG, 
  output reg  [7:0] oB, 

  output            READY,
  output            SCL, 
  inout             SDA
);

reg [17:0] SUM_CANNY;
reg [17:0] SUM_CANNY_PREV; 
reg [17:0] SUM_CANNY_MAX; 
reg  [9:0] STEP_MAX;

wire         BUSY_LINE;
wire         BUSY_CIRCLE;
wire         SOF;
wire         IMG_PROC;
wire         IMG_PROC_LINE;
wire         IMG_PROC_CIRCLE;
wire         VS_NS; 
wire         HS_NS; 
wire  [15:0] VCM_DATA;
wire   [9:0] STEP; 
wire         VCM_END;
wire   [7:0] S; 
wire   [7:0] CANNY; 
wire  [17:0] Y; 
wire         ACTIV_C; 
wire         ACTIV_V; 
wire   [9:0] V_CNT;
wire   [9:0] H_CNT;
wire         BORDER;

reg [7:0] R_r[6501:0];
reg [7:0] G_r[6501:0];
reg [7:0] B_r[6501:0];
reg [7:0] Y_r[6501:0];

AUTO_SYNC_MODIFY i_AUTO_SYNC_MODIFY (
  .PCLK ( VIDEO_CLK ),
  .VS   ( VIDEO_VS ),
  .HS   ( VIDEO_HS ),
  .M_VS ( VS_NS ),
  .M_HS ( HS_NS )
); 

LCD_COUNTER i_LCD_COUNTER (
  .CLK            ( VIDEO_CLK ),
  .VS             ( VS_NS), 
  .HS             ( HS_NS), 
  .DE             ( VIDEO_DE ), 
  .V_CNT          ( V_CNT ),
  .H_CNT          ( H_CNT ),
  .BORDER         ( BORDER ),
  .ACTIV_C        ( ACTIV_C ),
  .ACTIV_V        ( ACTIV_V ),
  .SOF            ( SOF )
); 

//-- VCM_STEP CONTROL & PIXEL HIGH_Statistics --
VCM_CTRL i_VCM_CTRL (
  .iR                   ( iR ),
  .iG                   ( iG ),
  .iB                   ( iB ),
  .VS                   ( VS_NS ), 
  .HS                   ( HS_NS ), 
  .ACTIV_C              ( ACTIV_C ),
  .ACTIV_V              ( ACTIV_V ),
  .VIDEO_CLK            ( VIDEO_CLK ), 
  .AUTO_FOC             ( AUTO_FOC ),  
  .Y                    ( Y ),
  .S                    ( S ),
  .VCM_DATA             ( VCM_DATA ),
  .CANNY                ( CANNY ),
  .STEP                 ( STEP ),
  .STEP_MAX             ( STEP_MAX ),
  .VCM_END              ( VCM_END ),
  .readMemPixel         ( readMemPixel )
);
                                             
//-- I2C DELAY -- 
I2C_DELAY i_VCM_I2C_DELAY (
  .RESET_N  ( RESET_SUB_N ),
  .CLK      ( VIDEO_VS ), 
  .READY    ( READY )
);
 
//-- VCM_SETTING -- 
VCM_I2C i_VCM_I2C ( 
  .TR_IN        ( VS_NS ),
  .RESET_N      ( READY ), 
	.RESET_SUB_N  ( RESET_SUB_N ),
  .CLK_50       ( CLK_50 ),
  .I2C_SCL      ( SCL ) ,
  .I2C_SDA      ( SDA ),
  .VCM_DATA     ( VCM_DATA ), 
	.TEST_MODE    ( 1 ) // 1: WRITE-READ-WRITE, 0: write only
);

assign IMG_PROC = IMG_PROC_LINE | IMG_PROC_CIRCLE;

//-- VIDEO MIXED -- 
always @( negedge VIDEO_CLK ) begin
  {oR, oG, oB} <= 
    BORDER ? 
      {8'hFF, 8'h00, 8'h00} : // bordure ecran
        (SW_0) ?
          // switch 0 en haut -> image edge
          (SW_1) ?
            // switch 1 en haut -> // image edge en blanc
            (SW_2) ?
              // switch 2 en haut -> // img_proc + canny
              {IMG_PROC ? 8'h00 : CANNY, IMG_PROC ? 8'hFF : CANNY, IMG_PROC ? 8'h00 : CANNY} :
              // switch 2 en bas -> // uniquement img_proc
              {IMG_PROC ? 8'hFF : 8'h00, IMG_PROC ? 8'hFF : 8'h00, IMG_PROC ? 8'hFF : 8'h00} :
            // switch 1 en bas -> // image edge en noir
            (SW_2) ?
              // switch 2 en haut -> // img_proc + canny
              {IMG_PROC ? 8'h00 : ~CANNY, IMG_PROC ? 8'hFF : ~CANNY, IMG_PROC ? 8'h00 : ~CANNY} :
              // switch 2 en bas -> // uniquement img_proc
              {IMG_PROC ? 8'h00 : 8'hFF, IMG_PROC ? 8'h00 : 8'hFF, IMG_PROC ? 8'h00 : 8'hFF} :
          // switch 0 en bas -> image camera
          (SW_1) ?
            // switch 1 en haut -> // image noir et blanc YUV
            {Y_r[6436], Y_r[6436], Y_r[6436]} :
            // switch 1 en bas -> // image couleur RGB
            {R_r[6436], G_r[6436], B_r[6436]};
end

always @( negedge AUTO_FOC or posedge VIDEO_CLK ) begin
  if (!AUTO_FOC) 
    SUM_CANNY <= 0;
  else
    SUM_CANNY <= (V_CNT > 0) ? !BORDER ? CANNY[0] ? SUM_CANNY + 1 : SUM_CANNY : SUM_CANNY : 0;
end

always @( negedge AUTO_FOC or posedge VIDEO_CLK )
  if (!AUTO_FOC) 
    SUM_CANNY_PREV <= 0;
  else
    SUM_CANNY_PREV <= (V_CNT == 500 && H_CNT == 640) ? SUM_CANNY : SUM_CANNY_PREV;

always @( negedge AUTO_FOC or posedge VIDEO_CLK )
  if (!AUTO_FOC) begin
    SUM_CANNY_MAX <= 0;
    STEP_MAX <= 0;
  end
  else begin
    if (!VCM_END) begin
      SUM_CANNY_MAX <= SUM_CANNY_PREV > SUM_CANNY_MAX ? SUM_CANNY_PREV : SUM_CANNY_MAX;
      STEP_MAX <= SUM_CANNY_PREV > SUM_CANNY_MAX ? STEP : STEP_MAX;
    end
  end

LINE
#(.x_input_size   ( 500 ),
  .y_input_size   ( 418 ))
i_LINE
( .clk            ( VIDEO_CLK ),                   
	.reset_n        ( RESET_N_IMG_PROC ),                         
	.chipSelect     ( !BORDER ),                               
	.readMem        ( CANNY ),
  .printMem       ( IMG_PROC_LINE ),
  .busy           ( BUSY_LINE ),
  .sof            ( SOF ),
  .m_0            ( line_m_0 ),
  .c_0            ( line_c_0 ),
  .m_1            ( line_m_1 ),
  .c_1            ( line_c_1 ),
  .m_2            ( line_m_2 ),
  .c_2            ( line_c_2 ),
  .m_3            ( line_m_3 ),
  .c_3            ( line_c_3 ),
  .m_4            ( line_m_4 ),
  .c_4            ( line_c_4 ),
  .m_5            ( line_m_5 ),
  .c_5            ( line_c_5 ),
  .m_6            ( line_m_6 ),
  .c_6            ( line_c_6 ),
  .m_7            ( line_m_7 ),
  .c_7            ( line_c_7 ),
  .m_8            ( line_m_8 ),
  .c_8            ( line_c_8 ),
  .m_9            ( line_m_9 ),
  .c_9            ( line_c_9 ),
  .m_10           ( line_m_10 ),
  .c_10           ( line_c_10 ),
  .m_11           ( line_m_11 ),
  .c_11           ( line_c_11 ),
  .line_count     ( line_count ));

CIRCLE
#(.x_input_size   ( 500 ),
  .y_input_size   ( 418 ))
i_CIRCLE
( .clk            ( VIDEO_CLK ),                   
	.reset_n        ( RESET_N_IMG_PROC ),                         
	.chipSelect     ( readMemPixel ),                               
	.readMem        ( ~Y_r[25+801*4] ),
  .printMem       ( IMG_PROC_CIRCLE ),
  .busy           ( BUSY_CIRCLE ),
  .sof            ( SOF ),
  .latch_x_0      ( center_x_0 ),
  .latch_x_1      ( center_x_1 ),
  .latch_x_2      ( center_x_2 ),
  .latch_x_3      ( center_x_3 ),
  .latch_x_4      ( center_x_4 ),
  .latch_x_5      ( center_x_5 ),
  .latch_x_6      ( center_x_6 ),
  .latch_x_7      ( center_x_7 ),
  .latch_x_8      ( center_x_8 ),
  .latch_x_9      ( center_x_9 ),
  .latch_y_0      ( center_y_0 ),
  .latch_y_1      ( center_y_1 ),
  .latch_y_2      ( center_y_2 ),
  .latch_y_3      ( center_y_3 ),
  .latch_y_4      ( center_y_4 ),
  .latch_y_5      ( center_y_5 ),
  .latch_y_6      ( center_y_6 ),
  .latch_y_7      ( center_y_7 ),
  .latch_y_8      ( center_y_8 ),
  .latch_y_9      ( center_y_9 ));

PLAYER i_player ( 
  .clk            ( VIDEO_CLK ),                  
	.reset_n        ( RESET_N_IMG_PROC ), 
  .latch          ( BUSY_CIRCLE | BUSY_LINE ),          
  .circle_x_0     ( center_x_0 ),
  .circle_x_1     ( center_x_1 ),
  .circle_x_2     ( center_x_2 ),
  .circle_x_3     ( center_x_3 ),
  .circle_x_4     ( center_x_4 ),
  .circle_x_5     ( center_x_5 ),
  .circle_x_6     ( center_x_6 ),
  .circle_x_7     ( center_x_7 ),
  .circle_x_8     ( center_x_8 ),
  .circle_x_9     ( center_x_9 ),
  .circle_y_0     ( center_y_0 ),
  .circle_y_1     ( center_y_1 ),
  .circle_y_2     ( center_y_2 ),
  .circle_y_3     ( center_y_3 ),
  .circle_y_4     ( center_y_4 ),
  .circle_y_5     ( center_y_5 ),
  .circle_y_6     ( center_y_6 ),
  .circle_y_7     ( center_y_7 ),
  .circle_y_8     ( center_y_8 ),
  .circle_y_9     ( center_y_9 ),
  .line_m_0       ( line_m_0 ),
  .line_c_0       ( line_c_0 ),
  .line_m_1       ( line_m_1 ),
  .line_c_1       ( line_c_1 ),
  .line_m_2       ( line_m_2 ),
  .line_c_2       ( line_c_2 ),
  .line_m_3       ( line_m_3 ),
  .line_c_3       ( line_c_3 ),
  .line_m_4       ( line_m_4 ),
  .line_c_4       ( line_c_4 ),
  .line_m_5       ( line_m_5 ),
  .line_c_5       ( line_c_5 ),
  .line_m_6       ( line_m_6 ),
  .line_c_6       ( line_c_6 ),
  .line_m_7       ( line_m_7 ),
  .line_c_7       ( line_c_7 ),
  .line_m_8       ( line_m_8 ),
  .line_c_8       ( line_c_8 ),
  .line_m_9       ( line_m_9 ),
  .line_c_9       ( line_c_9 ),
  .line_m_10      ( line_m_10 ),
  .line_c_10      ( line_c_10 ),
  .line_m_11      ( line_m_11 ),
  .line_c_11      ( line_c_11 ),
  .line_count     ( line_count )
);

///////////////////////////////////

always @( negedge VIDEO_CLK ) begin
  //R_r[0] <= iR;
  //G_r[0] <= iG;
  //B_r[0] <= iB;
  //Y_r[0] <= Y[15:8];
  if (Y[15:8] < 100)
    Y_r[0] <= 8'h00;
  else 
    Y_r[0] <= 8'hFF;

end

genvar gi;
generate
  for (gi=0; gi<3250; gi=gi+1) begin : gen_r
    always @( negedge VIDEO_CLK ) begin
      //R_r[gi+1]      <= R_r[gi];
      //G_r[gi+1]      <= G_r[gi];
      //B_r[gi+1]      <= B_r[gi];
      Y_r[gi+1]      <= Y_r[gi];
      //R_r[gi+1+3250] <= R_r[gi+3250];
      //G_r[gi+1+3250] <= G_r[gi+3250];
      //B_r[gi+1+3250] <= B_r[gi+3250];
      Y_r[gi+1+3250] <= Y_r[gi+3250];
    end
  end
endgenerate

///////////////////////////////////

endmodule 
	 
