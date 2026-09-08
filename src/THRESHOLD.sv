/*
	Description: Suppressing non-maximum with a 3x3 mask and Double Threshold
*/

`timescale 1ns/1ps

module THRESHOLD
#(parameter x_input_size = 636,
  parameter y_input_size = 476,
  parameter x_conv_size = 3,
  parameter y_conv_size = 3)
 (input clk,
	input reset,
	input startConv,
	input [11:0] bufferInput [0:x_conv_size-1],
	input [11:0] maxInput,  
  output reg busyConv,
	output reg endOfConv,
	output reg inLineConv,	
	output reg [1:0] bufferOutput);
  
	reg [9:0] counter; // max = x_input_size-x_conv_size = 633
  
  reg [11:0] L0C0; // [0;2885] max = sqrt(8323200)
  reg [11:0] L0C1; // [0;2885] max = sqrt(8323200)
  reg [11:0] L0C2; // [0;2885] max = sqrt(8323200)
  reg [11:0] L1C0; // [0;2885] max = sqrt(8323200)
  reg [11:0] L1C1; // [0;2885] max = sqrt(8323200)
  reg [11:0] L1C2; // [0;2885] max = sqrt(8323200)
  reg [11:0] L2C0; // [0;2885] max = sqrt(8323200)
  reg [11:0] L2C1; // [0;2885] max = sqrt(8323200)
  reg [11:0] L2C2; // [0;2885] max = sqrt(8323200)

	reg [11:0] centerVal; // [0;2885]
	reg [1:0] Output;
  
  reg [11:0] E; // [0;2885]
	reg [11:0] NE; // [0;2885]
	reg [11:0] N; // [0;2885]
	reg [11:0] NO; // [0;2885]
  reg [11:0] O; // [0;2885]
	reg [11:0] SO; // [0;2885]
	reg [11:0] S; // [0;2885]
	reg [11:0] SE; // [0;2885]
  
  reg [12:0] E_O; // [0;5770]
	reg [12:0] NE_SO; // [0;5770]
	reg [12:0] N_S; // [0;5770]
	reg [12:0] NO_SE; // [0;5770]
  	
  logic max_dir_E_O;
  logic max_dir_NE_SO;
  logic max_dir_N_S;
  logic max_dir_NO_SE;
  
  reg [11:0] highThreshold;
  reg [11:0] lowThreshold;
  
  logic startOfLine;
  logic endOfLine;
    
	enum reg [1:0]{
		RESET,
		S_CONV,
		S_ConvDone
	}CS, NS;

	//Next State logic for the FSM
	always_ff @ (posedge clk, negedge reset) begin
		if(!reset)
			CS <= RESET;
		else
			CS <= NS;
	end
	
	//Combination logic always block of the FSM
	always_comb begin
		NS = RESET;
    highThreshold = maxInput >> 3; // 934 / 8 = 116
    lowThreshold = highThreshold >> 2; // 116 / 4 = 29 
		case(CS) 
			RESET	:	
      begin
        centerVal = 0;
        E = 0; 
        NE = 0;
        N = 0; 
        NO = 0;
        O = 0; 
        SO = 0;
        S = 0; 
        SE = 0;
        E_O = 0; 
        NE_SO = 0;
        N_S = 0; 
        NO_SE = 0;
        max_dir_E_O = 1'b0;
        max_dir_NE_SO = 1'b0;
        max_dir_N_S = 1'b0;
        max_dir_NO_SE = 1'b0;
        Output = 0;
        if(reset && startConv)
          NS = S_CONV;
        else 
          NS = RESET;
      end
			S_CONV :
      begin
        E  = (L1C2 >= L1C1) ? 
              L1C2 -  L1C1 : 
             -L1C2 +  L1C1;
        NE = (L0C2 >= L1C1) ? 
              L0C2 -  L1C1 : 
             -L0C2 +  L1C1;
        N  = (L0C1 >= L1C1) ? 
              L0C1 -  L1C1 : 
             -L0C1 +  L1C1;
        NO = (L0C0 >= L1C1) ? 
              L0C0 -  L1C1 : 
             -L0C0 +  L1C1;
        O  = (L1C0 >= L1C1) ? 
              L1C0 -  L1C1 : 
             -L1C0 +  L1C1;
        SO = (L2C0 >= L1C1) ? 
              L2C0 -  L1C1 : 
             -L2C0 +  L1C1;
        S  = (L2C1 >= L1C1) ? 
              L2C1 -  L1C1 : 
             -L2C1 +  L1C1;
        SE = (L2C2 >= L1C1) ? 
              L2C2 -  L1C1 : 
             -L2C2 +  L1C1;
      
        E_O = E + O;
        NE_SO = NE + SO;
        N_S = N + S;
        NO_SE = NO + SE;
        
        max_dir_E_O  = ((E_O >= NE_SO) && (E_O >= N_S)   && (E_O >= NO_SE))  ? 1 : 0;
        max_dir_NE_SO = ((NE_SO >= E_O) && (NE_SO >= N_S)  && (NE_SO >= NO_SE)) ? 1 : 0;
        max_dir_N_S  = ((N_S >= E_O)  && (N_S >= NE_SO)  && (N_S >= NO_SE))  ? 1 : 0;
        max_dir_NO_SE = ((NO_SE >= E_O) && (NO_SE >= NE_SO) && (NO_SE >= N_S)) ? 1 : 0;

        centerVal = (((max_dir_E_O)   && ((L1C2 >= L1C1) || (L1C0 >= L1C1))) || 
                     ((max_dir_NE_SO) && ((L0C2 >= L1C1) || (L2C0 >= L1C1))) || 
                     ((max_dir_N_S)   && ((L0C1 >= L1C1) || (L2C1 >= L1C1))) || 
                     ((max_dir_NO_SE) && ((L0C0 >= L1C1) || (L2C2 >= L1C1)))) ? 
                       0 : L1C1;
    
        Output = (centerVal < lowThreshold) ? 2'd0 : (centerVal > highThreshold) ? 2'd2 : 2'd1;

        if(counter < x_input_size+4) 
          NS = S_CONV;
        else 
          NS = S_ConvDone;
      end
			S_ConvDone :	
      begin
        centerVal = 0;
        E = 0; 
        NE = 0;
        N = 0; 
        NO = 0;
        O = 0; 
        SO = 0;
        S = 0; 
        SE = 0;
        E_O = 0; 
        NE_SO = 0;
        N_S = 0; 
        NO_SE = 0;
        max_dir_E_O = 1'b0;
        max_dir_NE_SO = 1'b0;
        max_dir_N_S = 1'b0;
        max_dir_NO_SE = 1'b0;
        Output = 0;
        NS = RESET;
      end
		endcase
	end
	
  //Registered output always block for the FSM
  always_ff @ (posedge clk, negedge reset) begin
    if(!reset) begin
      startOfLine <= 1'b0;
      endOfLine <= 1'b0;
      busyConv <= 1'b0;
      endOfConv <= 1'b0;
      inLineConv <= 1'b0;
      bufferOutput <= 2'd0;
      counter <= 10'd0;
      L0C0 <= 1'b0;
      L1C0 <= 1'b0;
      L2C0 <= 1'b0;
      L0C1 <= 1'b0;
      L1C1 <= 1'b0;
      L2C1 <= 1'b0;
      L0C2 <= 1'b0;
      L1C2 <= 1'b0;
      L2C2 <= 1'b0;
    end
    else begin
      case(CS)
        RESET	:	
        begin
          startOfLine <= 1'b0;
          endOfLine <= 1'b0;
          busyConv <= 1'b0;
          endOfConv <= 1'b0;
          inLineConv <= 1'b0;
          bufferOutput <= 2'd0;
          counter <= 10'd0;
          L0C0 <= 1'b0;
          L1C0 <= 1'b0;
          L2C0 <= 1'b0;
          L0C1 <= 1'b0;
          L1C1 <= 1'b0;
          L2C1 <= 1'b0;
          L0C2 <= 1'b0;
          L1C2 <= 1'b0;
          L2C2 <= 1'b0;
        end
        S_CONV : 
        begin
          startOfLine <= 1'b0;
          endOfLine <= 1'b0;
          busyConv <= 1'b1;
          endOfConv <= 1'b0;
          bufferOutput <= Output;
          counter++;
          L0C0 <= L0C1;
          L1C0 <= L1C1;
          L2C0 <= L2C1;
          L0C1 <= L0C2;
          L1C1 <= L1C2;
          L2C1 <= L2C2;
          L0C2 <= bufferInput[2];
          L1C2 <= bufferInput[1];
          L2C2 <= bufferInput[0];
          if(counter == x_conv_size+5) begin
            startOfLine <= 1'b1;
            inLineConv <= 1'b1;
          end
          if(counter == x_input_size+5) begin
            endOfLine <= 1'b1;
            endOfConv <= 1'b1;
            inLineConv <= 1'b1;
          end
        end
        S_ConvDone :   
        begin
          busyConv <= 1'b0;
          endOfLine <= 1'b0;
          endOfConv <= 1'b0;
          inLineConv <= 1'b0;
        end
      endcase
    end
  end
	
endmodule
