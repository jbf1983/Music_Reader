/*
	Description: Performing convolution with gaussian filter of 3X3, as the first step in the convolution of the Canny Edge Detection algorithm
*/

`timescale 1ns/1ps

module GAUSS
#(parameter x_input_size = 640,
  parameter y_input_size = 480,
  parameter x_conv_size = 3,
  parameter y_conv_size = 3)
 (input clk,
	input reset,
	input startConv,
	input [7:0] bufferInput [0:x_conv_size-1],
	output reg busyConv,
	output reg endOfConv,
	output reg inLineConv,
	output reg [7:0] bufferOutput);

  reg [9:0] counter; // max = x_input_size-x_conv_size = 637

  reg [7:0] L0C0; // max = 255
  reg [7:0] L0C1; // max = 255
  reg [7:0] L0C2; // max = 255
  reg [7:0] L1C0; // max = 255
  reg [7:0] L1C1; // max = 255
  reg [7:0] L1C2; // max = 255
  reg [7:0] L2C0; // max = 255
  reg [7:0] L2C1; // max = 255
  reg [7:0] L2C2; // max = 255
  reg [9:0] L0; // max = 255*1*2+255*2 = 1020
  reg [10:0] L1; // max = 255*2*4+255*2 = 2040
  reg [9:0] L2; // max = 255*1*2+255*2 = 1020
  reg [11:0] Sum; // max = 1020+2040+1020 = 4080
  reg [7:0] Output; // max = 4080 / 16 = 255
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
        L0 = 0;
        L1 = 0;
        L2 = 0;
        Sum = 0;
        Output = 0;
        if(reset && startConv) 
          NS = S_CONV;
        else 
          NS = RESET;
      end
      S_CONV :   
      begin
        // 3*3 gauss filter
        L0 = L0C0*1+L0C1*2+L0C2*1;
        L1 = L1C0*2+L1C1*4+L1C2*2;
        L2 = L2C0*1+L2C1*2+L2C2*1;
        Sum = L0 + L1 + L2;        ;
        Output = Sum >> 4; //division by 16
        if(counter < x_input_size) 
          NS = S_CONV;
        else 
          NS = S_ConvDone;
      end
      S_ConvDone :	
      begin
        L0 = 0;
        L1 = 0;
        L2 = 0;
        Sum = 0;
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
      bufferOutput <= 8'd0;
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
          bufferOutput <= 8'd0;
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
          if(counter == x_conv_size+1) begin
            startOfLine <= 1'b1;
            inLineConv <= 1'b1;
          end
          if(counter == x_input_size+1) begin
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
