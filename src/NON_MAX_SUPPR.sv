/*
	Description: Suppressing non-maximum with a 3x3 mask and Double Threshold
*/

`timescale 1ns/1ps

module NON_MAX_SUPPR
#(parameter x_input_size = 636,
  parameter y_input_size = 476,
  parameter x_conv_size = 3,
  parameter y_conv_size = 3)
 (input clk,
	input reset,
	input startConv,
	input [11:0] bufferInput [0:x_input_size*x_conv_size-1],
	input [11:0] maxInput,  
	output reg convDone,
	output reg [11:0] bufferOutputNonMaxSuppr [0:x_input_size-x_conv_size],
	output reg [1:0] bufferOutputThreshold [0:x_input_size-x_conv_size]);
  
	reg [9:0] counter; // max = x_input_size-x_conv_size = 633

	reg [11:0] centerVal; // [0;2885]
  
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
  
  shortint highThreshold;
  shortint lowThreshold;
  
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
        highThreshold = maxInput >> 2; 
        lowThreshold = highThreshold >> 1;
        if(reset == 1'b1 && startConv == 1'b1)
          NS = S_CONV;
        else 
          NS = RESET;
      end
			S_CONV :
      begin

        E  = (bufferInput[counter+1*x_input_size+2] >= bufferInput[counter+1*x_input_size+1]) ? 
              bufferInput[counter+1*x_input_size+2] -  bufferInput[counter+1*x_input_size+1] : 
             -bufferInput[counter+1*x_input_size+2] +  bufferInput[counter+1*x_input_size+1];
        NE = (bufferInput[counter+0*x_input_size+2] >= bufferInput[counter+1*x_input_size+1]) ? 
              bufferInput[counter+0*x_input_size+2] -  bufferInput[counter+1*x_input_size+1] : 
             -bufferInput[counter+0*x_input_size+2] +  bufferInput[counter+1*x_input_size+1];
        N  = (bufferInput[counter+0*x_input_size+1] >= bufferInput[counter+1*x_input_size+1]) ? 
              bufferInput[counter+0*x_input_size+1] -  bufferInput[counter+1*x_input_size+1] : 
             -bufferInput[counter+0*x_input_size+1] +  bufferInput[counter+1*x_input_size+1];
        NO = (bufferInput[counter+0*x_input_size+0] >= bufferInput[counter+1*x_input_size+1]) ? 
              bufferInput[counter+0*x_input_size+0] -  bufferInput[counter+1*x_input_size+1] : 
             -bufferInput[counter+0*x_input_size+0] +  bufferInput[counter+1*x_input_size+1];
        O  = (bufferInput[counter+1*x_input_size+0] >= bufferInput[counter+1*x_input_size+1]) ? 
              bufferInput[counter+1*x_input_size+0] -  bufferInput[counter+1*x_input_size+1] : 
             -bufferInput[counter+1*x_input_size+0] +  bufferInput[counter+1*x_input_size+1];
        SO = (bufferInput[counter+2*x_input_size+0] >= bufferInput[counter+1*x_input_size+1]) ? 
              bufferInput[counter+2*x_input_size+0] -  bufferInput[counter+1*x_input_size+1] : 
             -bufferInput[counter+2*x_input_size+0] +  bufferInput[counter+1*x_input_size+1];
        S  = (bufferInput[counter+2*x_input_size+1] >= bufferInput[counter+1*x_input_size+1]) ? 
              bufferInput[counter+2*x_input_size+1] -  bufferInput[counter+1*x_input_size+1] : 
             -bufferInput[counter+2*x_input_size+1] +  bufferInput[counter+1*x_input_size+1];
        SE = (bufferInput[counter+2*x_input_size+2] >= bufferInput[counter+1*x_input_size+1]) ? 
              bufferInput[counter+2*x_input_size+2] -  bufferInput[counter+1*x_input_size+1] : 
             -bufferInput[counter+2*x_input_size+2] +  bufferInput[counter+1*x_input_size+1];
      
        E_O = E + O;
        NE_SO = NE + SO;
        N_S = N + S;
        NO_SE = NO + SE;
        
        max_dir_E_O  = ((E_O >= NE_SO) && (E_O >= N_S)   && (E_O >= NO_SE))  ? 1 : 0;
        max_dir_NE_SO = ((NE_SO >= E_O) && (NE_SO >= N_S)  && (NE_SO >= NO_SE)) ? 1 : 0;
        max_dir_N_S  = ((N_S >= E_O)  && (N_S >= NE_SO)  && (N_S >= NO_SE))  ? 1 : 0;
        max_dir_NO_SE = ((NO_SE >= E_O) && (NO_SE >= NE_SO) && (NO_SE >= N_S)) ? 1 : 0;

        centerVal = (((max_dir_E_O)  && ((bufferInput[counter+1*x_input_size+2] >= bufferInput[counter+1*x_input_size+1]) || (bufferInput[counter+1*x_input_size+0] >= bufferInput[counter+1*x_input_size+1]))) || 
                     ((max_dir_NE_SO) && ((bufferInput[counter+0*x_input_size+2] >= bufferInput[counter+1*x_input_size+1]) || (bufferInput[counter+2*x_input_size+0] >= bufferInput[counter+1*x_input_size+1]))) || 
                     ((max_dir_N_S)  && ((bufferInput[counter+0*x_input_size+1] >= bufferInput[counter+1*x_input_size+1]) || (bufferInput[counter+2*x_input_size+1] >= bufferInput[counter+1*x_input_size+1]))) || 
                     ((max_dir_NO_SE) && ((bufferInput[counter+0*x_input_size+0] >= bufferInput[counter+1*x_input_size+1]) || (bufferInput[counter+2*x_input_size+2] >= bufferInput[counter+1*x_input_size+1])))) ? 
                   0 : bufferInput[counter+1*x_input_size+1];
    
        if(counter < (x_input_size-x_conv_size)) 
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
        NS = RESET;
      end
		endcase
	end
	
	//Registered output always block for the FSM
	always_ff @ (posedge clk, negedge reset) begin
		if(!reset) begin
      convDone <= 1'b0;
      counter <= 0;
      bufferOutputNonMaxSuppr <= '{default:'b0};
      bufferOutputThreshold <= '{default:'b0};
    end
		else begin
			case(CS)
				RESET	:	
        begin
          convDone <= 1'b0;
          counter <= 0;
        end
				S_CONV :
        begin
          convDone <= 1'b0;
          // Non Max Suppression Output
          bufferOutputNonMaxSuppr[counter] <= centerVal;
          // Double Threshold Output
          bufferOutputThreshold[counter] <= (centerVal < lowThreshold) ? 2'd0 : (centerVal > highThreshold) ? 2'd2 : 2'd1;
          if(counter < (x_input_size-x_conv_size)) 
            counter++;
        end
				S_ConvDone :	
        begin
          convDone <= 1'b1;
        end
			endcase
		end
	end
	
endmodule
