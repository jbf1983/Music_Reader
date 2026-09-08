`timescale 1ns/1ps

module PLAYER
( input clk,                       
	input reset_n,   
  input latch,           
  input [8:0] circle_x_0,
  input [8:0] circle_x_1,
  input [8:0] circle_x_2,
  input [8:0] circle_x_3,
  input [8:0] circle_x_4,
  input [8:0] circle_x_5,
  input [8:0] circle_x_6,
  input [8:0] circle_x_7,
  input [8:0] circle_x_8,
  input [8:0] circle_x_9,
  input [8:0] circle_y_0,
  input [8:0] circle_y_1,
  input [8:0] circle_y_2,
  input [8:0] circle_y_3,
  input [8:0] circle_y_4,
  input [8:0] circle_y_5,
  input [8:0] circle_y_6,
  input [8:0] circle_y_7,
  input [8:0] circle_y_8,
  input [8:0] circle_y_9,
  input [6:0] line_m_0,  
  input [9:0] line_c_0, 
  input [8:0] line_m_1,  
  input [6:0] line_c_1,  
  input [9:0] line_m_2,  
  input [6:0] line_c_2,  
  input [9:0] line_m_3,  
  input [6:0] line_c_3,  
  input [9:0] line_m_4,  
  input [6:0] line_c_4,  
  input [9:0] line_m_5,  
  input [6:0] line_c_5,  
  input [9:0] line_m_6,  
  input [6:0] line_c_6,  
  input [9:0] line_m_7,  
  input [6:0] line_c_7,  
  input [9:0] line_m_8,  
  input [6:0] line_c_8,  
  input [9:0] line_m_9,  
  input [6:0] line_c_9,  
  input [9:0] line_m_10,
  input [6:0] line_c_10,
  input [9:0] line_m_11,
  input [6:0] line_c_11,
  input [4:0] line_count);

/*
  const logic [8:0] x_size = 500; 
  const logic [8:0] y_size = 418; 
  const logic [3:0] radius = 12; 
  logic is_win_1;
  logic stage_1;

  logic [8:0] min_nms_x_2; // 0-499
  logic [8:0] min_nms_y_2; // 0-417
*/
  reg [8:0] reg_circle_x_0; 
  reg [8:0] reg_circle_x_1; 
  reg [8:0] reg_circle_x_2; 
  reg [8:0] reg_circle_x_3; 
  reg [8:0] reg_circle_x_4; 
  reg [8:0] reg_circle_x_5; 
  reg [8:0] reg_circle_x_6; 
  reg [8:0] reg_circle_x_7; 
  reg [8:0] reg_circle_x_8; 
  reg [8:0] reg_circle_x_9; 
  reg [8:0] reg_circle_y_0; 
  reg [8:0] reg_circle_y_1; 
  reg [8:0] reg_circle_y_2; 
  reg [8:0] reg_circle_y_3; 
  reg [8:0] reg_circle_y_4; 
  reg [8:0] reg_circle_y_5; 
  reg [8:0] reg_circle_y_6; 
  reg [8:0] reg_circle_y_7; 
  reg [8:0] reg_circle_y_8; 
  reg [8:0] reg_circle_y_9; 
  reg [6:0] reg_line_m_0;   
  reg [9:0] reg_line_c_0;   
  reg [8:0] reg_line_m_1;   
  reg [6:0] reg_line_c_1;   
  reg [9:0] reg_line_m_2;   
  reg [6:0] reg_line_c_2;   
  reg [9:0] reg_line_m_3;   
  reg [6:0] reg_line_c_3;   
  reg [9:0] reg_line_m_4;   
  reg [6:0] reg_line_c_4;   
  reg [9:0] reg_line_m_5;   
  reg [6:0] reg_line_c_5;   
  reg [9:0] reg_line_m_6;   
  reg [6:0] reg_line_c_6;   
  reg [9:0] reg_line_m_7;   
  reg [6:0] reg_line_c_7;   
  reg [9:0] reg_line_m_8;   
  reg [6:0] reg_line_c_8;   
  reg [9:0] reg_line_m_9;   
  reg [6:0] reg_line_c_9;   
  reg [9:0] reg_line_m_10;  
  reg [6:0] reg_line_c_10;  
  reg [9:0] reg_line_m_11;  
  reg [6:0] reg_line_c_11;  
  reg [4:0] reg_line_count; 
/*
	enum logic [3:0]{
		S_RESET,
		S_MEMREAD,
    S_HOUGH,
    S_NMS_IMAGE
	} CS, NS;
	
	//Next State Logic
	always_ff @ (posedge clk, negedge reset_n) begin
		if(!reset_n) begin
			CS <= S_RESET;
		end
		else begin
			CS <= NS;
		end
	end	
*/
	always_ff @ (posedge clk) begin
    if (latch) begin
      reg_circle_x_0 <= circle_x_0;
      reg_circle_x_1 <= circle_x_1;
      reg_circle_x_2 <= circle_x_2;
      reg_circle_x_3 <= circle_x_3;
      reg_circle_x_4 <= circle_x_4;
      reg_circle_x_5 <= circle_x_5;
      reg_circle_x_6 <= circle_x_6;
      reg_circle_x_7 <= circle_x_7;
      reg_circle_x_8 <= circle_x_8;
      reg_circle_x_9 <= circle_x_9;
      reg_circle_y_0 <= circle_y_0;
      reg_circle_y_1 <= circle_y_1;
      reg_circle_y_2 <= circle_y_2;
      reg_circle_y_3 <= circle_y_3;
      reg_circle_y_4 <= circle_y_4;
      reg_circle_y_5 <= circle_y_5;
      reg_circle_y_6 <= circle_y_6;
      reg_circle_y_7 <= circle_y_7;
      reg_circle_y_8 <= circle_y_8;
      reg_circle_y_9 <= circle_y_9;
      reg_line_m_0   <= line_m_0;  
      reg_line_c_0   <= line_c_0; 
      reg_line_m_1   <= line_m_1;  
      reg_line_c_1   <= line_c_1;  
      reg_line_m_2   <= line_m_2;  
      reg_line_c_2   <= line_c_2;  
      reg_line_m_3   <= line_m_3;  
      reg_line_c_3   <= line_c_3;  
      reg_line_m_4   <= line_m_4;  
      reg_line_c_4   <= line_c_4;  
      reg_line_m_5   <= line_m_5;  
      reg_line_c_5   <= line_c_5;  
      reg_line_m_6   <= line_m_6;  
      reg_line_c_6   <= line_c_6;  
      reg_line_m_7   <= line_m_7;  
      reg_line_c_7   <= line_c_7;  
      reg_line_m_8   <= line_m_8;  
      reg_line_c_8   <= line_c_8;  
      reg_line_m_9   <= line_m_9;  
      reg_line_c_9   <= line_c_9;  
      reg_line_m_10  <= line_m_10;
      reg_line_c_10  <= line_c_10;
      reg_line_m_11  <= line_m_11;
      reg_line_c_11  <= line_c_11;
      reg_line_count <= line_count;
    end
	end	



	/*
  CIRCLE_READ_DPRAM 
  #(.DATA_WIDTH(1),
    .ADDRESS_WIDTH(18)) 
  i_CIRCLE_READ_DPRAM(
  .we_a(NS == S_MEMREAD ? 1'b1 : 1'b0),
  //.we_a(1'b0),
  .clk_a(clk),
  .addr_a(read_pointer),
  .data_a(readMem),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(y_circle[4] ? x_circle[4] ? hough_pointer - x_circle_abs - y_circle_abs * x_size : 
                                      hough_pointer + x_circle_abs - y_circle_abs * x_size : 
                        x_circle[4] ? hough_pointer - x_circle_abs + y_circle_abs * x_size : 
                                      hough_pointer + x_circle_abs + y_circle_abs * x_size),
  .data_b(),
  .q_b(houghInput));
*/

endmodule