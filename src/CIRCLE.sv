`timescale 1ns/1ps

module CIRCLE
#(parameter x_input_size = 500,
  parameter y_input_size = 418)
( input clk,
	input reset_n,
	input chipSelect,
	input readMem,
	input sof,
	output reg printMem,
	output reg busy,
  output reg [8:0] latch_x_0,
  output reg [8:0] latch_x_1,
  output reg [8:0] latch_x_2,
  output reg [8:0] latch_x_3,
  output reg [8:0] latch_x_4,
  output reg [8:0] latch_x_5,
  output reg [8:0] latch_x_6,
  output reg [8:0] latch_x_7,
  output reg [8:0] latch_x_8,
  output reg [8:0] latch_x_9,
  output reg [8:0] latch_y_0,
  output reg [8:0] latch_y_1,
  output reg [8:0] latch_y_2,
  output reg [8:0] latch_y_3,
  output reg [8:0] latch_y_4,
  output reg [8:0] latch_y_5,
  output reg [8:0] latch_y_6,
  output reg [8:0] latch_y_7,
  output reg [8:0] latch_y_8,
  output reg [8:0] latch_y_9);

  const logic [8:0] x_size = 500; 
  const logic [8:0] y_size = 418; 
  const logic [3:0] radius = 12; 
  const logic [4:0] step_hough_max = 29;
  const logic [3:0] stage_counter_max = 10;
  const logic [5:0] border = 25; 

  logic houghInput;

	logic [8:0] x_pointer; // 0-499
	logic [8:0] y_pointer; // 0-417


	logic [10:0] x_print; // 0-499
	logic [10:0] y_print; // 0-417

  logic [4:0] x_circle; // +/-12
	logic [4:0] y_circle; // +/-12

  logic [3:0] x_circle_abs; // 0-12
	logic [3:0] y_circle_abs; // 0-12

  logic [4:0] circleAccumulator; // 0-31

	logic [17:0] read_pointer; // 0-208999
  logic [17:0] hough_pointer; // 0-208999
  logic [17:0] nms_pointer; // 0-208999
  logic [18:0] print_pointer; // 0-480000 (800*600)

	logic [4:0] step_hough; // 0-29
  logic step_nms;

  logic [5:0] nmsInput;
  logic reset_hough;

  logic [8:0] min_nms_x_0; // 0-499
  logic [8:0] min_nms_y_0; // 0-417
  logic [8:0] max_nms_x_0; // 0-499
  logic [8:0] max_nms_y_0; // 0-417
  logic [8:0] min_win_x_0; // 0-499
  logic [8:0] min_win_y_0; // 0-417
  logic [8:0] max_win_x_0; // 0-499
  logic [8:0] max_win_y_0; // 0-417
  logic [8:0] center_x_0; // 0-499
  logic [8:0] center_y_0; // 0-417
  logic first_0;
  logic is_win_0;
  logic stage_0;

  logic [8:0] min_nms_x_1; // 0-499
  logic [8:0] min_nms_y_1; // 0-417
  logic [8:0] max_nms_x_1; // 0-499
  logic [8:0] max_nms_y_1; // 0-417
  logic [8:0] min_win_x_1; // 0-499
  logic [8:0] min_win_y_1; // 0-417
  logic [8:0] max_win_x_1; // 0-499
  logic [8:0] max_win_y_1; // 0-417
  logic [8:0] center_x_1; // 0-499
  logic [8:0] center_y_1; // 0-417
  logic first_1;
  logic is_win_1;
  logic stage_1;

  logic [8:0] min_nms_x_2; // 0-499
  logic [8:0] min_nms_y_2; // 0-417
  logic [8:0] max_nms_x_2; // 0-499
  logic [8:0] max_nms_y_2; // 0-417
  logic [8:0] min_win_x_2; // 0-499
  logic [8:0] min_win_y_2; // 0-417
  logic [8:0] max_win_x_2; // 0-499
  logic [8:0] max_win_y_2; // 0-417
  logic [8:0] center_x_2; // 0-499
  logic [8:0] center_y_2; // 0-417
  logic first_2;
  logic is_win_2;
  logic stage_2;

  logic [8:0] min_nms_x_3; // 0-499
  logic [8:0] min_nms_y_3; // 0-417
  logic [8:0] max_nms_x_3; // 0-499
  logic [8:0] max_nms_y_3; // 0-417
  logic [8:0] min_win_x_3; // 0-499
  logic [8:0] min_win_y_3; // 0-417
  logic [8:0] max_win_x_3; // 0-499
  logic [8:0] max_win_y_3; // 0-417
  logic [8:0] center_x_3; // 0-499
  logic [8:0] center_y_3; // 0-417
  logic first_3;
  logic is_win_3;
  logic stage_3;

  logic [8:0] min_nms_x_4; // 0-499
  logic [8:0] min_nms_y_4; // 0-417
  logic [8:0] max_nms_x_4; // 0-499
  logic [8:0] max_nms_y_4; // 0-417
  logic [8:0] min_win_x_4; // 0-499
  logic [8:0] min_win_y_4; // 0-417
  logic [8:0] max_win_x_4; // 0-499
  logic [8:0] max_win_y_4; // 0-417
  logic [8:0] center_x_4; // 0-499
  logic [8:0] center_y_4; // 0-417
  logic first_4;
  logic is_win_4;
  logic stage_4;

  logic [8:0] min_nms_x_5; // 0-499
  logic [8:0] min_nms_y_5; // 0-417
  logic [8:0] max_nms_x_5; // 0-499
  logic [8:0] max_nms_y_5; // 0-417
  logic [8:0] min_win_x_5; // 0-499
  logic [8:0] min_win_y_5; // 0-417
  logic [8:0] max_win_x_5; // 0-499
  logic [8:0] max_win_y_5; // 0-417
  logic [8:0] center_x_5; // 0-499
  logic [8:0] center_y_5; // 0-417
  logic first_5;
  logic is_win_5;
  logic stage_5;

  logic [8:0] min_nms_x_6; // 0-499
  logic [8:0] min_nms_y_6; // 0-417
  logic [8:0] max_nms_x_6; // 0-499
  logic [8:0] max_nms_y_6; // 0-417
  logic [8:0] min_win_x_6; // 0-499
  logic [8:0] min_win_y_6; // 0-417
  logic [8:0] max_win_x_6; // 0-499
  logic [8:0] max_win_y_6; // 0-417
  logic [8:0] center_x_6; // 0-499
  logic [8:0] center_y_6; // 0-417
  logic first_6;
  logic is_win_6;
  logic stage_6;

  logic [8:0] min_nms_x_7; // 0-499
  logic [8:0] min_nms_y_7; // 0-417
  logic [8:0] max_nms_x_7; // 0-499
  logic [8:0] max_nms_y_7; // 0-417
  logic [8:0] min_win_x_7; // 0-499
  logic [8:0] min_win_y_7; // 0-417
  logic [8:0] max_win_x_7; // 0-499
  logic [8:0] max_win_y_7; // 0-417
  logic [8:0] center_x_7; // 0-499
  logic [8:0] center_y_7; // 0-417
  logic first_7;
  logic is_win_7;
  logic stage_7;

  logic [8:0] min_nms_x_8; // 0-499
  logic [8:0] min_nms_y_8; // 0-417
  logic [8:0] max_nms_x_8; // 0-499
  logic [8:0] max_nms_y_8; // 0-417
  logic [8:0] min_win_x_8; // 0-499
  logic [8:0] min_win_y_8; // 0-417
  logic [8:0] max_win_x_8; // 0-499
  logic [8:0] max_win_y_8; // 0-417
  logic [8:0] center_x_8; // 0-499
  logic [8:0] center_y_8; // 0-417
  logic first_8;
  logic is_win_8;
  logic stage_8;

  logic [8:0] min_nms_x_9; // 0-499
  logic [8:0] min_nms_y_9; // 0-417
  logic [8:0] max_nms_x_9; // 0-499
  logic [8:0] max_nms_y_9; // 0-417
  logic [8:0] min_win_x_9; // 0-499
  logic [8:0] min_win_y_9; // 0-417
  logic [8:0] max_win_x_9; // 0-499
  logic [8:0] max_win_y_9; // 0-417
  logic [8:0] center_x_9; // 0-499
  logic [8:0] center_y_9; // 0-417
  logic first_9;
  logic is_win_9;
  logic stage_9;

  logic stage_10;

  logic[3:0] stage_counter; // 0-1

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
	
	//Combinational Logic
	always_latch begin
		case(CS)

			S_RESET	:	
      begin
        x_pointer = 0;		
        y_pointer = 0;	
        x_circle = 0;
        y_circle = 0;
        if (sof)			
          NS = S_MEMREAD;
        else 
          NS = S_RESET;
      end

			S_MEMREAD	:	
      begin					
        if (read_pointer <= x_size * y_size)
          NS = S_MEMREAD;
        else
          NS = S_HOUGH;
          //NS = S_RESET;
      end

      S_HOUGH	:	
      begin		
        x_pointer = hough_pointer % x_size;
        y_pointer = (hough_pointer / x_size) % y_size;

        case(step_hough)
          000: begin x_circle =  -4 ; y_circle = - 4 +  0 ; x_circle_abs = 8 ; y_circle_abs = 4 ; reset_hough = 1 ; end
          ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          001: begin x_circle =  -4 ; y_circle = - 4 +  0 ; x_circle_abs = 8 ; y_circle_abs = 4 ; reset_hough = 0 ; end
          002: begin x_circle =  -4 ; y_circle = - 4 +  1 ; x_circle_abs = 8 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          003: begin x_circle =  -4 ; y_circle = - 4 +  2 ; x_circle_abs = 8 ; y_circle_abs = 2 ; reset_hough = 0 ; end
          004: begin x_circle =  -4 ; y_circle = - 4 +  3 ; x_circle_abs = 8 ; y_circle_abs = 1 ; reset_hough = 0 ; end
          005: begin x_circle =  -4 ; y_circle = - 4 +  5 ; x_circle_abs = 8 ; y_circle_abs = 1 ; reset_hough = 0 ; end
          006: begin x_circle =  -4 ; y_circle = - 4 +  6 ; x_circle_abs = 8 ; y_circle_abs = 2 ; reset_hough = 0 ; end
          007: begin x_circle =  -4 ; y_circle = - 4 +  7 ; x_circle_abs = 8 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          008: begin x_circle =  -4 ; y_circle = - 4 +  8 ; x_circle_abs = 8 ; y_circle_abs = 4 ; reset_hough = 0 ; end
        
          009: begin x_circle =  -3 ; y_circle = - 3      ; x_circle_abs = 3 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          010: begin x_circle =  -2 ; y_circle = - 3      ; x_circle_abs = 2 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          011: begin x_circle =  -1 ; y_circle = - 3      ; x_circle_abs = 1 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          012: begin x_circle =  +1 ; y_circle = - 3      ; x_circle_abs = 1 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          013: begin x_circle =  +2 ; y_circle = - 3      ; x_circle_abs = 2 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          014: begin x_circle =  +3 ; y_circle = - 3      ; x_circle_abs = 3 ; y_circle_abs = 3 ; reset_hough = 0 ; end

          015: begin x_circle =  -3 ; y_circle = + 3      ; x_circle_abs = 3 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          016: begin x_circle =  -2 ; y_circle = + 3      ; x_circle_abs = 2 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          017: begin x_circle =  -1 ; y_circle = + 3      ; x_circle_abs = 1 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          018: begin x_circle =  +1 ; y_circle = + 3      ; x_circle_abs = 1 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          019: begin x_circle =  +2 ; y_circle = + 3      ; x_circle_abs = 2 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          020: begin x_circle =  +3 ; y_circle = + 3      ; x_circle_abs = 3 ; y_circle_abs = 3 ; reset_hough = 0 ; end

          021: begin x_circle =  -4 ; y_circle = - 4 +  0 ; x_circle_abs = 8 ; y_circle_abs = 4 ; reset_hough = 0 ; end
          022: begin x_circle =  -4 ; y_circle = - 4 +  1 ; x_circle_abs = 8 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          023: begin x_circle =  -4 ; y_circle = - 4 +  2 ; x_circle_abs = 8 ; y_circle_abs = 2 ; reset_hough = 0 ; end
          024: begin x_circle =  -4 ; y_circle = - 4 +  3 ; x_circle_abs = 8 ; y_circle_abs = 1 ; reset_hough = 0 ; end
          025: begin x_circle =  -4 ; y_circle = - 4 +  5 ; x_circle_abs = 8 ; y_circle_abs = 1 ; reset_hough = 0 ; end
          026: begin x_circle =  -4 ; y_circle = - 4 +  6 ; x_circle_abs = 8 ; y_circle_abs = 2 ; reset_hough = 0 ; end
          027: begin x_circle =  -4 ; y_circle = - 4 +  7 ; x_circle_abs = 8 ; y_circle_abs = 3 ; reset_hough = 0 ; end
          028: begin x_circle =  -4 ; y_circle = - 4 +  8 ; x_circle_abs = 8 ; y_circle_abs = 4 ; reset_hough = 0 ; end
          ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          029: begin x_circle =  -4 ; y_circle = - 4 +  8 ; x_circle_abs = 8 ; y_circle_abs = 4 ; reset_hough = 0 ; end
        endcase

        if (hough_pointer < x_size * y_size)
          NS = S_HOUGH;
        else      
          NS = S_NMS_IMAGE;
      end

      S_NMS_IMAGE :	
      begin	
        x_pointer = nms_pointer % x_size;
        y_pointer = (nms_pointer / x_size) % y_size;

        if (nms_pointer < x_size * y_size)
          NS = S_NMS_IMAGE;
        else  
          NS = S_RESET;
      end

		endcase
	end

	//Registered operations
	always_ff @ (posedge clk, negedge reset_n) begin
    if (!reset_n) begin
      busy <= 0;
      read_pointer <= 0;	
      hough_pointer <= 0;
      nms_pointer <= 0;
      step_hough <= 0;
      step_nms <= 0;
      stage_counter <= 0;
		end
		else begin
			case(NS)

				S_RESET	:	
        begin
          busy <= 0;
          read_pointer <= 0;	
          hough_pointer <= 0;
          nms_pointer <= 0;
          step_hough <= 0;
          step_nms <= 0;
          stage_counter <= 0;
        end

				S_MEMREAD	:	
        begin		
          busy <= 1;	
          if (chipSelect)			
            read_pointer++;
        end

				S_HOUGH	:	
        begin	
          read_pointer <= 0;
          if (step_hough < step_hough_max)
            step_hough++;
          else begin
            hough_pointer++;
            step_hough <= 0;
	        end
        end

				S_NMS_IMAGE	:	
        begin																	
          if (!step_nms)
            step_nms <= 1;
          else begin
            step_nms <= 0;													
            if (stage_counter < stage_counter_max)
              nms_pointer = (nms_pointer + 1) % (x_size * y_size);
            else
              nms_pointer++;
          end
          if (nms_pointer == x_size * y_size - 1 && step_nms)
            stage_counter++;
        end         

			endcase
		end
	end

	always_ff @ (posedge clk) begin
    if (reset_hough)
      circleAccumulator = 0;
		else if (houghInput)
      circleAccumulator++;
  end

	always_ff @ (posedge clk, negedge busy) begin
    if (!busy) begin
      min_nms_x_0 <= x_size - 1; 
      min_nms_y_0 <= y_size - 1; 
      max_nms_x_0 <= 0; 
      max_nms_y_0 <= 0; 
      min_win_x_0 <= 0; 
      min_win_y_0 <= 0; 
      max_win_x_0 <= 0; 
      max_win_y_0 <= 0; 
      center_x_0 <= 0; 
      center_y_0 <= 0; 
      first_0 <= 0;
      is_win_0 <= 0;

      min_nms_x_1 <= x_size - 1; 
      min_nms_y_1 <= y_size - 1; 
      max_nms_x_1 <= 0; 
      max_nms_y_1 <= 0; 
      min_win_x_1 <= 0; 
      min_win_y_1 <= 0; 
      max_win_x_1 <= 0; 
      max_win_y_1 <= 0; 
      center_x_1 <= 0; 
      center_y_1 <= 0; 
      first_1 <= 0;
      is_win_1 <= 0;

      min_nms_x_2 <= x_size - 1; 
      min_nms_y_2 <= y_size - 1; 
      max_nms_x_2 <= 0; 
      max_nms_y_2 <= 0; 
      min_win_x_2 <= 0; 
      min_win_y_2 <= 0; 
      max_win_x_2 <= 0; 
      max_win_y_2 <= 0; 
      center_x_2 <= 0; 
      center_y_2 <= 0; 
      first_2 <= 0;
      is_win_2 <= 0;

      min_nms_x_3 <= x_size - 1; 
      min_nms_y_3 <= y_size - 1; 
      max_nms_x_3 <= 0; 
      max_nms_y_3 <= 0; 
      min_win_x_3 <= 0; 
      min_win_y_3 <= 0; 
      max_win_x_3 <= 0; 
      max_win_y_3 <= 0; 
      center_x_3 <= 0; 
      center_y_3 <= 0; 
      first_3 <= 0;
      is_win_3 <= 0;

      min_nms_x_4 <= x_size - 1; 
      min_nms_y_4 <= y_size - 1; 
      max_nms_x_4 <= 0; 
      max_nms_y_4 <= 0; 
      min_win_x_4 <= 0; 
      min_win_y_4 <= 0; 
      max_win_x_4 <= 0; 
      max_win_y_4 <= 0; 
      center_x_4 <= 0; 
      center_y_4 <= 0; 
      first_4 <= 0;
      is_win_4 <= 0;

      min_nms_x_5 <= x_size - 1; 
      min_nms_y_5 <= y_size - 1; 
      max_nms_x_5 <= 0; 
      max_nms_y_5 <= 0; 
      min_win_x_5 <= 0; 
      min_win_y_5 <= 0; 
      max_win_x_5 <= 0; 
      max_win_y_5 <= 0; 
      center_x_5 <= 0; 
      center_y_5 <= 0; 
      first_5 <= 0;
      is_win_5 <= 0;

      min_nms_x_6 <= x_size - 1; 
      min_nms_y_6 <= y_size - 1; 
      max_nms_x_6 <= 0; 
      max_nms_y_6 <= 0; 
      min_win_x_6 <= 0; 
      min_win_y_6 <= 0; 
      max_win_x_6 <= 0; 
      max_win_y_6 <= 0; 
      center_x_6 <= 0; 
      center_y_6 <= 0; 
      first_6 <= 0;
      is_win_6 <= 0;

      min_nms_x_7 <= x_size - 1; 
      min_nms_y_7 <= y_size - 1; 
      max_nms_x_7 <= 0; 
      max_nms_y_7 <= 0; 
      min_win_x_7 <= 0; 
      min_win_y_7 <= 0; 
      max_win_x_7 <= 0; 
      max_win_y_7 <= 0; 
      center_x_7 <= 0; 
      center_y_7 <= 0; 
      first_7 <= 0;
      is_win_7 <= 0;

      min_nms_x_8 <= x_size - 1; 
      min_nms_y_8 <= y_size - 1; 
      max_nms_x_8 <= 0; 
      max_nms_y_8 <= 0; 
      min_win_x_8 <= 0; 
      min_win_y_8 <= 0; 
      max_win_x_8 <= 0; 
      max_win_y_8 <= 0; 
      center_x_8 <= 0; 
      center_y_8 <= 0; 
      first_8 <= 0;
      is_win_8 <= 0;

      min_nms_x_9 <= x_size - 1; 
      min_nms_y_9 <= y_size - 1; 
      max_nms_x_9 <= 0; 
      max_nms_y_9 <= 0; 
      min_win_x_9 <= 0; 
      min_win_y_9 <= 0; 
      max_win_x_9 <= 0; 
      max_win_y_9 <= 0; 
      center_x_9 <= 0; 
      center_y_9 <= 0; 
      first_9 <= 0;
      is_win_9 <= 0;

      stage_0 <= 1;
      stage_1 <= 0;
      stage_2 <= 0;
      stage_3 <= 0;
      stage_4 <= 0;
      stage_5 <= 0;
      stage_6 <= 0;
      stage_7 <= 0;
      stage_8 <= 0;
      stage_9 <= 0;
      stage_10 <= 0;

		end
		else begin

      if ((min_nms_x_0 != x_size - 1) && (min_nms_y_0 != y_size - 1)) begin
        center_x_0 <= (min_nms_x_0 + max_nms_x_0) / 2;
        center_y_0 <= (min_nms_y_0 + max_nms_y_0) / 2;
      end else begin
        center_x_0 <= -1;
        center_y_0 <= -1;
      end

      if ((min_nms_x_1 != x_size - 1) && (min_nms_y_1 != y_size - 1)) begin
        center_x_1 <= (min_nms_x_1 + max_nms_x_1) / 2;
        center_y_1 <= (min_nms_y_1 + max_nms_y_1) / 2;
      end else begin
        center_x_1 <= -1;
        center_y_1 <= -1;
      end

      if ((min_nms_x_2 != x_size - 1) && (min_nms_y_2 != y_size - 1)) begin
        center_x_2 <= (min_nms_x_2 + max_nms_x_2) / 2;
        center_y_2 <= (min_nms_y_2 + max_nms_y_2) / 2;
      end else begin
        center_x_2 <= -1;
        center_y_2 <= -1;
      end

      if ((min_nms_x_3 != x_size - 1) && (min_nms_y_3 != y_size - 1)) begin
        center_x_3 <= (min_nms_x_3 + max_nms_x_3) / 2;
        center_y_3 <= (min_nms_y_3 + max_nms_y_3) / 2;
      end else begin
        center_x_3 <= -1;
        center_y_3 <= -1;
      end

      if ((min_nms_x_4 != x_size - 1) && (min_nms_y_4 != y_size - 1)) begin
        center_x_4 <= (min_nms_x_4 + max_nms_x_4) / 2;
        center_y_4 <= (min_nms_y_4 + max_nms_y_4) / 2;
      end else begin
        center_x_4 <= -1;
        center_y_4 <= -1;
      end

      if ((min_nms_x_5 != x_size - 1) && (min_nms_y_5 != y_size - 1)) begin
        center_x_5 <= (min_nms_x_5 + max_nms_x_5) / 2;
        center_y_5 <= (min_nms_y_5 + max_nms_y_5) / 2;
      end else begin
        center_x_5 <= -1;
        center_y_5 <= -1;
      end

      if ((min_nms_x_6 != x_size - 1) && (min_nms_y_6 != y_size - 1)) begin
        center_x_6 <= (min_nms_x_6 + max_nms_x_6) / 2;
        center_y_6 <= (min_nms_y_6 + max_nms_y_6) / 2;
      end else begin
        center_x_6 <= -1;
        center_y_6 <= -1;
      end

      if ((min_nms_x_7 != x_size - 1) && (min_nms_y_7 != y_size - 1)) begin
        center_x_7 <= (min_nms_x_7 + max_nms_x_7) / 2;
        center_y_7 <= (min_nms_y_7 + max_nms_y_7) / 2;
      end else begin
        center_x_7 <= -1;
        center_y_7 <= -1;
      end

      if ((min_nms_x_8 != x_size - 1) && (min_nms_y_8 != y_size - 1)) begin
        center_x_8 <= (min_nms_x_8 + max_nms_x_8) / 2;
        center_y_8 <= (min_nms_y_8 + max_nms_y_8) / 2;
      end else begin
        center_x_8 <= -1;
        center_y_8 <= -1;
      end

      if ((min_nms_x_9 != x_size - 1) && (min_nms_y_9 != y_size - 1)) begin
        center_x_9 <= (min_nms_x_9 + max_nms_x_9) / 2;
        center_y_9 <= (min_nms_y_9 + max_nms_y_9) / 2;
      end else begin
        center_x_9 <= -1;
        center_y_9 <= -1;
      end

      if (first_0) begin
        if (x_pointer > min_win_x_0 && x_pointer < max_win_x_0 && y_pointer > min_win_y_0 && y_pointer < max_win_y_0) is_win_0 <= 1;
        else is_win_0 <= 0;
        if (nms_pointer == x_size * y_size - 1) begin
          stage_1 <= 1;
          stage_0 <= 0;
        end
      end

      if (first_1) begin
        if (x_pointer > min_win_x_1 && x_pointer < max_win_x_1 && y_pointer > min_win_y_1 && y_pointer < max_win_y_1) is_win_1 <= 1;
        else is_win_1 <= 0;
        if (nms_pointer == x_size * y_size - 1) begin
          stage_2 <= 1;
          stage_1 <= 0;
        end
      end

      if (first_2) begin
        if (x_pointer > min_win_x_2 && x_pointer < max_win_x_2 && y_pointer > min_win_y_2 && y_pointer < max_win_y_2) is_win_2 <= 1;
        else is_win_2 <= 0;
        if (nms_pointer == x_size * y_size - 1) begin
          stage_3 <= 1;
          stage_2 <= 0;
        end
      end

      if (first_3) begin
        if (x_pointer > min_win_x_3 && x_pointer < max_win_x_3 && y_pointer > min_win_y_3 && y_pointer < max_win_y_3) is_win_3 <= 1;
        else is_win_3 <= 0;
        if (nms_pointer == x_size * y_size - 1) begin
          stage_4 <= 1;
          stage_3 <= 0;
        end
      end

      if (first_4) begin
        if (x_pointer > min_win_x_4 && x_pointer < max_win_x_4 && y_pointer > min_win_y_4 && y_pointer < max_win_y_4) is_win_4 <= 1;
        else is_win_4 <= 0;
        if (nms_pointer == x_size * y_size - 1) begin
          stage_5 <= 1;
          stage_4 <= 0;
        end
      end

      if (first_5) begin
        if (x_pointer > min_win_x_5 && x_pointer < max_win_x_5 && y_pointer > min_win_y_5 && y_pointer < max_win_y_5) is_win_5 <= 1;
        else is_win_5 <= 0;
        if (nms_pointer == x_size * y_size - 1) begin
          stage_6 <= 1;
          stage_5 <= 0;
        end
      end

      if (first_6) begin
        if (x_pointer > min_win_x_6 && x_pointer < max_win_x_6 && y_pointer > min_win_y_6 && y_pointer < max_win_y_6) is_win_6 <= 1;
        else is_win_6 <= 0;
        if (nms_pointer == x_size * y_size - 1) begin
          stage_7 <= 1;
          stage_6 <= 0;
        end
      end

      if (first_7) begin
        if (x_pointer > min_win_x_7 && x_pointer < max_win_x_7 && y_pointer > min_win_y_7 && y_pointer < max_win_y_7) is_win_7 <= 1;
        else is_win_7 <= 0;
        if (nms_pointer == x_size * y_size - 1) begin
          stage_8 <= 1;
          stage_7 <= 0;
        end
      end

      if (first_8) begin
        if (x_pointer > min_win_x_8 && x_pointer < max_win_x_8 && y_pointer > min_win_y_8 && y_pointer < max_win_y_8) is_win_8 <= 1;
        else is_win_8 <= 0;
        if (nms_pointer == x_size * y_size - 1) begin
          stage_9 <= 1;
          stage_8 <= 0;
        end
      end

      if (first_9) begin
        if (x_pointer > min_win_x_9 && x_pointer < max_win_x_9 && y_pointer > min_win_y_9 && y_pointer < max_win_y_9) is_win_9 <= 1;
        else is_win_9 <= 0;
        if (nms_pointer == x_size * y_size - 1) begin
          stage_10 <= 1;
          stage_9 <= 0;
        end
      end

      if (nmsInput) begin 

        if (!first_0 && stage_0) begin
          first_0 <= 1;
          min_win_x_0 <= x_pointer - border;
          max_win_x_0 <= x_pointer + border;
          min_win_y_0 <= y_pointer - border;
          max_win_y_0 <= y_pointer + border;
          min_nms_y_0 <= y_pointer;
        end

        if (!first_1 && stage_1 && !is_win_0) begin
          first_1 <= 1;
          min_win_x_1 <= x_pointer - border;
          max_win_x_1 <= x_pointer + border;
          min_win_y_1 <= y_pointer - border;
          max_win_y_1 <= y_pointer + border;
          min_nms_y_1 <= y_pointer;
        end

        if (!first_2 && stage_2 && !is_win_0 && !is_win_1) begin
          first_2 <= 1;
          min_win_x_2 <= x_pointer - border;
          max_win_x_2 <= x_pointer + border;
          min_win_y_2 <= y_pointer - border;
          max_win_y_2 <= y_pointer + border;
          min_nms_y_2 <= y_pointer;
        end

        if (!first_3 && stage_3 && !is_win_0 && !is_win_1 && !is_win_2) begin
          first_3 <= 1;
          min_win_x_3 <= x_pointer - border;
          max_win_x_3 <= x_pointer + border;
          min_win_y_3 <= y_pointer - border;
          max_win_y_3 <= y_pointer + border;
          min_nms_y_3 <= y_pointer;
        end

        if (!first_4 && stage_4 && !is_win_0 && !is_win_1 && !is_win_2 && !is_win_3) begin
          first_4 <= 1;
          min_win_x_4 <= x_pointer - border;
          max_win_x_4 <= x_pointer + border;
          min_win_y_4 <= y_pointer - border;
          max_win_y_4 <= y_pointer + border;
          min_nms_y_4 <= y_pointer;
        end

        if (!first_5 && stage_5 && !is_win_0 && !is_win_1 && !is_win_2 && !is_win_3 && !is_win_4) begin
          first_5 <= 1;
          min_win_x_5 <= x_pointer - border;
          max_win_x_5 <= x_pointer + border;
          min_win_y_5 <= y_pointer - border;
          max_win_y_5 <= y_pointer + border;
          min_nms_y_5 <= y_pointer;
        end

        if (!first_6 && stage_6 && !is_win_0 && !is_win_1 && !is_win_2 && !is_win_3 && !is_win_4 && !is_win_5) begin
          first_6 <= 1;
          min_win_x_6 <= x_pointer - border;
          max_win_x_6 <= x_pointer + border;
          min_win_y_6 <= y_pointer - border;
          max_win_y_6 <= y_pointer + border;
          min_nms_y_6 <= y_pointer;
        end

        if (!first_7 && stage_7 && !is_win_0 && !is_win_1 && !is_win_2 && !is_win_3 && !is_win_4 && !is_win_5 && !is_win_6) begin
          first_7 <= 1;
          min_win_x_7 <= x_pointer - border;
          max_win_x_7 <= x_pointer + border;
          min_win_y_7 <= y_pointer - border;
          max_win_y_7 <= y_pointer + border;
          min_nms_y_7 <= y_pointer;
        end

        if (!first_8 && stage_8 && !is_win_0 && !is_win_1 && !is_win_2 && !is_win_3 && !is_win_4 && !is_win_5 && !is_win_6 && !is_win_7) begin
          first_8 <= 1;
          min_win_x_8 <= x_pointer - border;
          max_win_x_8 <= x_pointer + border;
          min_win_y_8 <= y_pointer - border;
          max_win_y_8 <= y_pointer + border;
          min_nms_y_8 <= y_pointer;
        end

        if (!first_9 && stage_9 && !is_win_0 && !is_win_1 && !is_win_2 && !is_win_3 && !is_win_4 && !is_win_5 && !is_win_6 && !is_win_7 && !is_win_8) begin
          first_9 <= 1;
          min_win_x_9 <= x_pointer - border;
          max_win_x_9 <= x_pointer + border;
          min_win_y_9 <= y_pointer - border;
          max_win_y_9 <= y_pointer + border;
          min_nms_y_9 <= y_pointer;
        end

        if (is_win_0 && stage_0) begin
          max_nms_y_0 <= y_pointer;
          if (x_pointer <= min_nms_x_0) 
            min_nms_x_0 <= x_pointer;
          if (x_pointer >= max_nms_x_0) 
            max_nms_x_0 <= x_pointer; 
        end 

        if (is_win_1 && stage_1) begin
          max_nms_y_1 <= y_pointer;
          if (x_pointer <= min_nms_x_1) 
            min_nms_x_1 <= x_pointer;
          if (x_pointer >= max_nms_x_1) 
            max_nms_x_1 <= x_pointer; 
        end 

        if (is_win_2 && stage_2) begin
          max_nms_y_2 <= y_pointer;
          if (x_pointer <= min_nms_x_2) 
            min_nms_x_2 <= x_pointer;
          if (x_pointer >= max_nms_x_2) 
            max_nms_x_2 <= x_pointer; 
        end 

        if (is_win_3 && stage_3) begin
          max_nms_y_3 <= y_pointer;
          if (x_pointer <= min_nms_x_3) 
            min_nms_x_3 <= x_pointer;
          if (x_pointer >= max_nms_x_3) 
            max_nms_x_3 <= x_pointer; 
        end 

        if (is_win_4 && stage_4) begin
          max_nms_y_4 <= y_pointer;
          if (x_pointer <= min_nms_x_4) 
            min_nms_x_4 <= x_pointer;
          if (x_pointer >= max_nms_x_4) 
            max_nms_x_4 <= x_pointer; 
        end 

        if (is_win_5 && stage_5) begin
          max_nms_y_5 <= y_pointer;
          if (x_pointer <= min_nms_x_5) 
            min_nms_x_5 <= x_pointer;
          if (x_pointer >= max_nms_x_5) 
            max_nms_x_5 <= x_pointer; 
        end 

        if (is_win_6 && stage_6) begin
          max_nms_y_6 <= y_pointer;
          if (x_pointer <= min_nms_x_6) 
            min_nms_x_6 <= x_pointer;
          if (x_pointer >= max_nms_x_6) 
            max_nms_x_6 <= x_pointer; 
        end 

        if (is_win_7 && stage_7) begin
          max_nms_y_7 <= y_pointer;
          if (x_pointer <= min_nms_x_7) 
            min_nms_x_7 <= x_pointer;
          if (x_pointer >= max_nms_x_7) 
            max_nms_x_7 <= x_pointer; 
        end 

        if (is_win_8 && stage_8) begin
          max_nms_y_8 <= y_pointer;
          if (x_pointer <= min_nms_x_8) 
            min_nms_x_8 <= x_pointer;
          if (x_pointer >= max_nms_x_8) 
            max_nms_x_8 <= x_pointer; 
        end 

        if (is_win_9 && stage_9) begin
          max_nms_y_9 <= y_pointer;
          if (x_pointer <= min_nms_x_9) 
            min_nms_x_9 <= x_pointer;
          if (x_pointer >= max_nms_x_9) 
            max_nms_x_9 <= x_pointer; 
        end 

      end
    end
  end

	always_ff @ (posedge clk, negedge reset_n) begin
    if (!reset_n) begin
      print_pointer <= 0;
      printMem <= 0;
      x_print <= 0;
      y_print <= 0;
    end
    else begin
      if (sof) begin
        print_pointer <= 0;
        printMem <= 0;
        x_print <= 0;
        y_print <= 0;
      end
      else if (chipSelect) begin
        print_pointer++;
        x_print <= print_pointer % x_size;
        y_print <= (print_pointer / x_size) % y_size;
        if ((x_print + 0 == latch_x_0 && y_print + 0 == latch_y_0) || 
            (x_print + 0 == latch_x_1 && y_print + 0 == latch_y_1) ||
            (x_print + 0 == latch_x_2 && y_print + 0 == latch_y_2) ||
            (x_print + 0 == latch_x_3 && y_print + 0 == latch_y_3) ||
            (x_print + 0 == latch_x_4 && y_print + 0 == latch_y_4) ||
            (x_print + 0 == latch_x_5 && y_print + 0 == latch_y_5) ||
            (x_print + 0 == latch_x_6 && y_print + 0 == latch_y_6) ||
            (x_print + 0 == latch_x_7 && y_print + 0 == latch_y_7) ||
            (x_print + 0 == latch_x_8 && y_print + 0 == latch_y_8) ||
            (x_print + 0 == latch_x_9 && y_print + 0 == latch_y_9) ||
            // center +/- 1
            (x_print - 1 == latch_x_0 && y_print + 0 == latch_y_0) ||
            (x_print - 1 == latch_x_1 && y_print + 0 == latch_y_1) ||
            (x_print - 1 == latch_x_2 && y_print + 0 == latch_y_2) ||
            (x_print - 1 == latch_x_3 && y_print + 0 == latch_y_3) ||
            (x_print - 1 == latch_x_4 && y_print + 0 == latch_y_4) ||
            (x_print - 1 == latch_x_5 && y_print + 0 == latch_y_5) ||
            (x_print - 1 == latch_x_6 && y_print + 0 == latch_y_6) ||
            (x_print - 1 == latch_x_7 && y_print + 0 == latch_y_7) ||
            (x_print - 1 == latch_x_8 && y_print + 0 == latch_y_8) ||
            (x_print - 1 == latch_x_9 && y_print + 0 == latch_y_9) ||

            (x_print + 0 == latch_x_0 && y_print - 1 == latch_y_0) ||
            (x_print + 0 == latch_x_1 && y_print - 1 == latch_y_1) ||
            (x_print + 0 == latch_x_2 && y_print - 1 == latch_y_2) ||
            (x_print + 0 == latch_x_3 && y_print - 1 == latch_y_3) ||
            (x_print + 0 == latch_x_4 && y_print - 1 == latch_y_4) ||
            (x_print + 0 == latch_x_5 && y_print - 1 == latch_y_5) ||
            (x_print + 0 == latch_x_6 && y_print - 1 == latch_y_6) ||
            (x_print + 0 == latch_x_7 && y_print - 1 == latch_y_7) ||
            (x_print + 0 == latch_x_8 && y_print - 1 == latch_y_8) ||
            (x_print + 0 == latch_x_9 && y_print - 1 == latch_y_9) ||

            (x_print + 1 == latch_x_0 && y_print + 0 == latch_y_0) ||
            (x_print + 1 == latch_x_1 && y_print + 0 == latch_y_1) ||
            (x_print + 1 == latch_x_2 && y_print + 0 == latch_y_2) ||
            (x_print + 1 == latch_x_3 && y_print + 0 == latch_y_3) ||
            (x_print + 1 == latch_x_4 && y_print + 0 == latch_y_4) ||
            (x_print + 1 == latch_x_5 && y_print + 0 == latch_y_5) ||
            (x_print + 1 == latch_x_6 && y_print + 0 == latch_y_6) ||
            (x_print + 1 == latch_x_7 && y_print + 0 == latch_y_7) ||
            (x_print + 1 == latch_x_8 && y_print + 0 == latch_y_8) ||
            (x_print + 1 == latch_x_9 && y_print + 0 == latch_y_9) ||

            (x_print + 0 == latch_x_0 && y_print + 1 == latch_y_0) ||
            (x_print + 0 == latch_x_1 && y_print + 1 == latch_y_1) ||
            (x_print + 0 == latch_x_2 && y_print + 1 == latch_y_2) ||
            (x_print + 0 == latch_x_3 && y_print + 1 == latch_y_3) ||
            (x_print + 0 == latch_x_4 && y_print + 1 == latch_y_4) ||
            (x_print + 0 == latch_x_5 && y_print + 1 == latch_y_5) ||
            (x_print + 0 == latch_x_6 && y_print + 1 == latch_y_6) ||
            (x_print + 0 == latch_x_7 && y_print + 1 == latch_y_7) ||
            (x_print + 0 == latch_x_8 && y_print + 1 == latch_y_8) ||
            (x_print + 0 == latch_x_9 && y_print + 1 == latch_y_9) ||
            // center +/- 2
            (x_print - 2 == latch_x_0 && y_print + 0 == latch_y_0) ||
            (x_print - 2 == latch_x_1 && y_print + 0 == latch_y_1) ||
            (x_print - 2 == latch_x_2 && y_print + 0 == latch_y_2) ||
            (x_print - 2 == latch_x_3 && y_print + 0 == latch_y_3) ||
            (x_print - 2 == latch_x_4 && y_print + 0 == latch_y_4) ||
            (x_print - 2 == latch_x_5 && y_print + 0 == latch_y_5) ||
            (x_print - 2 == latch_x_6 && y_print + 0 == latch_y_6) ||
            (x_print - 2 == latch_x_7 && y_print + 0 == latch_y_7) ||
            (x_print - 2 == latch_x_8 && y_print + 0 == latch_y_8) ||
            (x_print - 2 == latch_x_9 && y_print + 0 == latch_y_9) ||

            (x_print + 0 == latch_x_0 && y_print - 2 == latch_y_0) ||
            (x_print + 0 == latch_x_1 && y_print - 2 == latch_y_1) ||
            (x_print + 0 == latch_x_2 && y_print - 2 == latch_y_2) ||
            (x_print + 0 == latch_x_3 && y_print - 2 == latch_y_3) ||
            (x_print + 0 == latch_x_4 && y_print - 2 == latch_y_4) ||
            (x_print + 0 == latch_x_5 && y_print - 2 == latch_y_5) ||
            (x_print + 0 == latch_x_6 && y_print - 2 == latch_y_6) ||
            (x_print + 0 == latch_x_7 && y_print - 2 == latch_y_7) ||
            (x_print + 0 == latch_x_8 && y_print - 2 == latch_y_8) ||
            (x_print + 0 == latch_x_9 && y_print - 2 == latch_y_9) ||

            (x_print + 2 == latch_x_0 && y_print + 0 == latch_y_0) ||
            (x_print + 2 == latch_x_1 && y_print + 0 == latch_y_1) ||
            (x_print + 2 == latch_x_2 && y_print + 0 == latch_y_2) ||
            (x_print + 2 == latch_x_3 && y_print + 0 == latch_y_3) ||
            (x_print + 2 == latch_x_4 && y_print + 0 == latch_y_4) ||
            (x_print + 2 == latch_x_5 && y_print + 0 == latch_y_5) ||
            (x_print + 2 == latch_x_6 && y_print + 0 == latch_y_6) ||
            (x_print + 2 == latch_x_7 && y_print + 0 == latch_y_7) ||
            (x_print + 2 == latch_x_8 && y_print + 0 == latch_y_8) ||
            (x_print + 2 == latch_x_9 && y_print + 0 == latch_y_9) ||

            (x_print + 0 == latch_x_0 && y_print + 2 == latch_y_0) ||
            (x_print + 0 == latch_x_1 && y_print + 2 == latch_y_1) ||
            (x_print + 0 == latch_x_2 && y_print + 2 == latch_y_2) ||
            (x_print + 0 == latch_x_3 && y_print + 2 == latch_y_3) ||
            (x_print + 0 == latch_x_4 && y_print + 2 == latch_y_4) ||
            (x_print + 0 == latch_x_5 && y_print + 2 == latch_y_5) ||
            (x_print + 0 == latch_x_6 && y_print + 2 == latch_y_6) ||
            (x_print + 0 == latch_x_7 && y_print + 2 == latch_y_7) ||
            (x_print + 0 == latch_x_8 && y_print + 2 == latch_y_8) ||
            (x_print + 0 == latch_x_9 && y_print + 2 == latch_y_9))         
        printMem <= 1;
      else
        printMem <= 0;
      end
    end
  end

  always_ff @ (negedge busy) begin
    latch_x_0 <= center_x_0;
    latch_x_1 <= center_x_1;
    latch_x_2 <= center_x_2;
    latch_x_3 <= center_x_3;
    latch_x_4 <= center_x_4;
    latch_x_5 <= center_x_5;
    latch_x_6 <= center_x_6;
    latch_x_7 <= center_x_7;
    latch_x_8 <= center_x_8;
    latch_x_9 <= center_x_9;
    latch_y_0 <= center_y_0 + 3;
    latch_y_1 <= center_y_1 + 3;
    latch_y_2 <= center_y_2 + 3;
    latch_y_3 <= center_y_3 + 3;
    latch_y_4 <= center_y_4 + 3;
    latch_y_5 <= center_y_5 + 3;
    latch_y_6 <= center_y_6 + 3;
    latch_y_7 <= center_y_7 + 3;
    latch_y_8 <= center_y_8 + 3;
    latch_y_9 <= center_y_9 + 3;
  end

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

  CIRCLE_HOUGH_DPRAM 
  #(.DATA_WIDTH(5),
    .ADDRESS_WIDTH(18)) 
  i_CIRCLE_HOUGH_DPRAM(
  .we_a(NS == S_HOUGH && step_hough == 0 ? 1'b1 : 1'b0),
  .clk_a(clk),
  .addr_a(hough_pointer - 1),
  .data_a((y_pointer > radius && y_pointer < y_size - radius - 1 && x_pointer > radius && x_pointer < x_size - radius - 1) ? circleAccumulator == step_hough_max ? 5'b1 : 5'b0 : 5'b0),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(NS == S_NMS_IMAGE ? nms_pointer : 18'b0),
  .data_b(),
  .q_b(nmsInput));

endmodule