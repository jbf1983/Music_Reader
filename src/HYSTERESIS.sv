/*
	Description: Hysteresis on weak pixels
*/

`timescale 1ns/1ps

module HYSTERESIS
#(parameter x_input_size = 634,
  parameter y_input_size = 474,
  parameter x_conv_size = 3,
  parameter y_conv_size = 3)
 (input clk,
	input reset,
	input startConv,
	input [1:0] bufferInput [0:x_conv_size-1],
	output reg busyConv,
	output reg endOfConv,
	output reg inLineConv,		
  output reg bufferOutput);
  
	reg [9:0] counter; // max = x_input_size-x_conv_size = 631
  
  reg [1:0] L0C0;
  reg [1:0] L0C1;
  reg [1:0] L0C2;
  reg [1:0] L1C0;
  reg [1:0] L1C1;
  reg [1:0] L1C2;
  reg [1:0] L2C0;
  reg [1:0] L2C1;
  reg [1:0] L2C2;
  
  logic Output;
  
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
		case(CS) 
			RESET	:	
      begin
        Output = 0;
        if(reset && startConv) begin
          NS = S_CONV;
        end
        else begin
          NS = RESET;
        end
      end
			S_CONV :
      begin
      
      Output =  (L1C1 == 2'd0) ? 1'b0 :
                (L1C1 == 2'd2) ? 1'b1 :
               ((L1C2 == 2'd2) ||
                (L0C2 == 2'd2) ||          
                (L0C1 == 2'd2) ||          
                (L0C0 == 2'd2) ||          
                (L1C0 == 2'd2) ||          
                (L2C0 == 2'd2) ||          
                (L2C1 == 2'd2) ||          
                (L2C2 == 2'd2)) ? 1'b1 : 1'b0;
                  
        if(counter < x_input_size+6) 
          NS = S_CONV;
        else 
          NS = S_ConvDone;
      end
			S_ConvDone :	
      begin
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
      bufferOutput <= 1'd0;
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
          bufferOutput <= 1'd0;
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
          if(counter == x_conv_size+7) begin
            startOfLine <= 1'b1;
            inLineConv <= 1'b1;
          end
          if(counter == x_input_size+7) begin
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
