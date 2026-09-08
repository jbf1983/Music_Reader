/*
	Description: Performing convolution with Sobel filter 3X3 for horizontal and vertical edges detection, as the second step in the convolution of the Canny Edge Detection algorithm
                                
                                -1 +0 +1 
      Sobel Horizontal Filter = -2 +0 +2
                                -1 +0 +1

                                -1 -2 -1
			Sobel Vertical Filter   = +0 +0 +0
                                +1 +2 +1
*/

`timescale 1ns/1ps

module SOBEL
#(parameter x_input_size = 638,
  parameter y_input_size = 478,
  parameter x_conv_size = 3,
  parameter y_conv_size = 3)
 (input clk,
	input reset,
	input startConv,
	input [7:0] bufferInput [0:x_conv_size-1],
	output reg busyConv,
	output reg endOfConv,
	output reg inLineConv,	
  output reg [11:0] bufferOutput,
	output reg [11:0] maxOutput,
  input inFrame);

	reg [9:0] counter; // max = x_input_size-x_conv_size = 635

  reg [11:0] maxOutputRun;
  reg [7:0] L0C0; // max = 255
  reg [7:0] L0C1; // max = 255
  reg [7:0] L0C2; // max = 255
  reg [7:0] L1C0; // max = 255
  reg [7:0] L1C1; // max = 255
  reg [7:0] L1C2; // max = 255
  reg [7:0] L2C0; // max = 255
  reg [7:0] L2C1; // max = 255
  reg [7:0] L2C2; // max = 255
	reg [10:0] L0H; // [-510;510]
	reg [10:0] L1H; // [-1020;1020]
	reg [10:0] L2H; // [-510;510]
	reg [11:0] SumH; // [-2040;2040]
	reg [10:0] L0V; // [-1020;1020]
	reg [10:0] L2V; // [-1020;1020]
	reg [11:0] SumV; // [-2040;2040]
	reg [10:0] SumHAbs; // [0;2040]
	reg [10:0] SumVAbs; // [0;2040]
	reg [22:0] Sum; // [0;8323200] max = 2040²+2040²
	reg [11:0] Output; // [0;2885] max = sqrt(8323200)
  logic startOfLine;
  logic endOfLine;
  
	enum reg [1:0]{
		RESET,
		S_CONV,
		S_ConvDone
	}CS, NS;
  
  reg [15:0] sqr;

  // Verilog function to find square root of a 32 bit number
  // The output is 16 bit
  function [15:0] sqrt;
    input [31:0] num; // declare input
    // intermediate signals
    reg [31:0] a;
    reg [15:0] q;
    reg [17:0] left;    
    reg [17:0] right;    
    reg [17:0] r;    
    integer i;
    
    begin
      // initialize all the variables
      a = num;
      q = 0;
      i = 0;
      left = 0; // input to adder/sub
      right = 0; // input to adder/sub
      r = 0;  // remainder
      // run the calculations for 16 iterations
      for (i = 0; i < 16; i++) begin 
        right = {q,r[17],1'b1};
        left = {r[15:0],a[31:30]};
        a = {a[29:0],2'b00}; // left shift by 2 bits
        if (r[17] == 1) // add if r is negative
          r = left + right;
        else //subtract if r is positive
          r = left - right;
        q = {q[14:0],!r[17]};       
      end
      sqrt = q; // final assignment of output
    end
  endfunction

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
        L0H = 0;
        L1H = 0;
        L2H = 0;
        SumH = 0;
        L0V = 0;
        L2V = 0;
        SumV = 0;
        SumHAbs = 0;
        SumVAbs = 0;
        Sum = 0;
        Output = 0;
        if(reset && startConv) 
          NS = S_CONV;
        else 
          NS = RESET;
      end
			S_CONV :
      begin
        L0H = ({2'b0, L0C0})*(-1) + ({2'b0, L0C2})*(+1);
        L1H = ({2'b0, L1C0})*(0) + ({2'b0, L1C2})*(0);        
        //L1H = ({2'b0, L1C0})*(-2) + ({2'b0, L1C2})*(+2);
        L2H = ({2'b0, L2C0})*(-1) + ({2'b0, L2C2})*(+1);
        SumH = {{2{L0H[10]}},L0H} + {{2{L1H[10]}},L1H} + {{2{L2H[10]}},L2H}; // Sobel Horizontal Edge Detector
        
        L0V = ({2'b0, L0C0})*(-1) + ({2'b0, L0C1})*(0) + ({2'b0, L0C2})*(-1);
        L2V = ({2'b0, L2C0})*(+1) + ({2'b0, L2C1})*(0) + ({2'b0, L2C2})*(+1);
        //L0V = ({2'b0, L0C0})*(-1) + ({2'b0, L0C1})*(-2) + ({2'b0, L0C2})*(-1);
        //L2V = ({2'b0, L2C0})*(+1) + ({2'b0, L2C1})*(+2) + ({2'b0, L2C2})*(+1);
        SumV = {{2{L0V[10]}},L0V} + {{2{L2V[10]}},L2V}; // Sobel Vertical Edge Detector

        SumHAbs = SumH[11] ? -SumH : SumH;
        SumVAbs = SumV[11] ? -SumV : SumV;
        
        Sum = SumHAbs**2 + SumVAbs**2; // Sobel Edge Detector magnitude
        Output = sqrt(Sum); // take square root 
      
        if(counter < x_input_size+2) 
          NS = S_CONV;
        else 
          NS = S_ConvDone;
      end
			S_ConvDone :	
      begin
        L0H = 0;
        L1H = 0;
        L2H = 0;
        SumH = 0;
        L0V = 0;
        L2V = 0;
        SumV = 0;
        SumHAbs= 0;
        SumVAbs= 0;
        Sum = 0;
        Output = 0;
        NS = RESET;
      end
		endcase
	end
	
  always_ff @ (negedge inFrame)
    maxOutput <= maxOutputRun;

  //Registered output always block for the FSM
  always_ff @ (posedge clk, negedge reset) begin
    if(!reset) begin
      startOfLine <= 1'b0;
      endOfLine <= 1'b0;
      busyConv <= 1'b0;
      endOfConv <= 1'b0;
      inLineConv <= 1'b0;
      bufferOutput <= 12'd0;
      maxOutputRun <= 12'd0;
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
          bufferOutput <= 12'd0;
          if (!inFrame) 
            maxOutputRun <= 12'd0;
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
          maxOutputRun <= Output > maxOutputRun ? Output : maxOutputRun;
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
          if(counter == x_conv_size+3) begin
            startOfLine <= 1'b1;
            inLineConv <= 1'b1;
          end
          if(counter == x_input_size+3) begin
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
