module VCM_CTRL ( 
  input        [7:0]  iR,
  input        [7:0]  iG,
  input        [7:0]  iB,
  input               VS,
  input               HS,
  input               ACTIV_C,
  input               ACTIV_V, 
  input               VIDEO_CLK, 
  input               AUTO_FOC,  
  output      [17:0]  Y,
  output reg   [7:0]  S,
  output      [15:0]  VCM_DATA,
  output reg   [7:0]  CANNY,
  output reg   [9:0]  STEP,
  input        [9:0]  STEP_MAX,
  output reg          VCM_END,
  output reg          lin_act,
  output reg          col_act,
  output reg          readMemPixel 
);
 
reg   [9:0] lin_count;
reg   [9:0] lin_act_count;
reg   [9:0] col_count;
reg   [9:0] col_act_count;
reg   [8:0] lin_act_count_circle;
reg   [8:0] col_act_count_circle;
reg         lin_act_circle;
reg         col_act_circle;
wire  [9:0] END_STEP; 
wire  [7:0] pixelOutput;

assign Y = (iR * 77 +  iG *150 +  iB*29); // niveaux de gris
assign VCM_DATA = {2'b00, END_STEP, 4'b1111};  
assign END_STEP = VCM_END ? STEP_MAX : STEP;

always @( negedge AUTO_FOC or posedge VS ) begin 
  if (!AUTO_FOC) begin 
	  STEP <= 0; 
    VCM_END <= 0;
  end 
  else begin 
    if (STEP < 10'd1000) begin
      STEP <= STEP + 1;  
      VCM_END <= 0;
    end
    else begin
      VCM_END <= 1; 
    end
  end 
end 

always @( posedge VIDEO_CLK ) begin
  if ( !HS ) 
    col_count <= 0;
  else
    col_count <= col_count + 1;
  if ( (col_count > 37) && (col_count < 677) ) begin
    col_act <= 1;
    col_act_count <= col_act_count + 1;
  end
  else begin
    col_act <= 0;
    col_act_count <= 0;
  end
  if ( (col_count > 37+65) && (col_count < 37+501+65) ) begin
    col_act_circle <= 1;
    col_act_count_circle <= col_act_count_circle + 1;
  end
  else begin
    col_act_circle <= 0;
    col_act_count_circle <= 0;
  end
end

always @( posedge HS ) begin
  if ( !VS )
    lin_count <= 0;
  else
    lin_count <= lin_count + 1;
  if ( (lin_count > 10) && (lin_count < 490) ) begin
    lin_act <= 1;
    lin_act_count <= lin_act_count + 1;
  end
  else begin
    lin_act <= 0;
    lin_act_count <= 0;
  end
  if ( lin_count > 10 ) begin
    lin_act_circle <= 1;
    lin_act_count_circle <= lin_act_count_circle + 1;
  end
  else begin
    lin_act_circle <= 0;
    lin_act_count_circle <= 0;
  end
end

always @( posedge VIDEO_CLK ) begin
  readMemPixel <= lin_act_circle & col_act_circle;
end

IMAGE_PROCESSING i_IMAGE_PROCESSING(
  .clk(VIDEO_CLK),
  .reset(1),
  .startConv(col_act),
  .endConv(!lin_act),
  .pixelValue(Y[15:8]),
  .pixelOutput(pixelOutput)
);

always @( posedge VIDEO_CLK ) begin
  CANNY <= pixelOutput[0] ? 8'hff : 8'h00;
end

endmodule 
