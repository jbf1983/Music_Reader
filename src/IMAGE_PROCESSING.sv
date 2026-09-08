`timescale 1ns/1ps

module IMAGE_PROCESSING
#(parameter x_input_size_step1 = 640,
  parameter y_input_size_step1 = 480,
  parameter x_conv_size_step1 = 3,
  parameter y_conv_size_step1 = 3,
  parameter x_input_size_step2 = x_input_size_step1-x_conv_size_step1+1, // 638
  parameter y_input_size_step2 = y_input_size_step1-y_conv_size_step1+1, // 478
  parameter x_conv_size_step2 = 3,
  parameter y_conv_size_step2 = 3,
  parameter x_input_size_step3 = x_input_size_step2-x_conv_size_step2+1, // 636
  parameter y_input_size_step3 = y_input_size_step2-y_conv_size_step2+1, // 476
  parameter x_conv_size_step3 = 3,
  parameter y_conv_size_step3 = 3,
  parameter x_input_size_step4 = x_input_size_step3-x_conv_size_step3+1, // 634
  parameter y_input_size_step4 = y_input_size_step3-y_conv_size_step3+1, // 474
  parameter x_conv_size_step4 = 3,
  parameter y_conv_size_step4 = 3)
 (input clk,
	input reset,
	input startConv,
	input endConv,
	input [7:0] pixelValue,
	output reg pixelOutput
);

  logic [14:0] countCircle;

	logic [7:0] inputConvGauss [0:x_conv_size_step1-1]; // input to first convolution step, size 3
	logic [7:0] inputConvSobel [0:x_conv_size_step2-1]; // input to second convolution step, size 3
	logic [11:0] inputConvThreshold [0:x_conv_size_step3-1]; // input to third convolution step, size 3
	logic [1:0] inputConvHysteresis [0:x_conv_size_step4-1]; // input to third convolution step, size 3
		
	logic [9:0] writeCounterGauss0;
	logic [9:0] writeCounterGauss1;
	logic [9:0] writeCounterGauss2;
	logic [9:0] writeCounterSobel0;
	logic [9:0] writeCounterSobel1;
	logic [9:0] writeCounterSobel2;
	logic [9:0] writeCounterThreshold0;
	logic [9:0] writeCounterThreshold1;
	logic [9:0] writeCounterThreshold2;
	logic [9:0] writeCounterHysteresis0;
	logic [9:0] writeCounterHysteresis1;
	logic [9:0] writeCounterHysteresis2;
  
	logic [7:0] outputConvGauss; // output from first convolution step
	logic [11:0] outputConvSobel; // output from second convolution step
	logic [1:0] outputConvThreshold; // output from third convolution step and after double threshold
	logic outputConvHysteresis; // output from fourth convolution step
	
	logic busyConvGauss;								
	logic busyConvSobel;								
	logic busyConvThreshold;								
	logic busyConvHysteresis;								
	
	logic startConvGauss;
	logic startConvSobel;
	logic startConvThreshold;
	logic startConvHysteresis;
	
	logic [8:0] rowsCompletedGauss; // max = 478
	logic [8:0] rowsCompletedSobel; // max = 476
	logic [8:0] rowsCompletedThreshold; // max = 474
	logic [8:0] rowsCompletedHysteresis; // max = 472

  logic [11:0] maxOutputSobel;
  
  logic [7:0] readDataGaussL0;
  logic [7:0] readDataGaussL1;
  logic [7:0] readDataGaussL2;
  logic [7:0] readDataGaussL0rr;
  logic [7:0] readDataGaussL0r;
  logic [7:0] readDataGaussL1r;
  logic [11:0] readDataSobelL0;
  logic [11:0] readDataSobelL1;
  logic [11:0] readDataSobelL2;
  logic [11:0] readDataSobelL0rr;
  logic [11:0] readDataSobelL0r;
  logic [11:0] readDataSobelL1r;
  logic [11:0] readDataThresholdL0; // only 2 lsb are usefull
  logic [11:0] readDataThresholdL1; // only 2 lsb are usefull
  logic [11:0] readDataThresholdL2; // only 2 lsb are usefull
  logic [11:0] readDataThresholdL0rr; // only 2 lsb are usefull
  logic [11:0] readDataThresholdL0r; // only 2 lsb are usefull
  logic [11:0] readDataThresholdL1r; // only 2 lsb are usefull
  logic [1:0] readDataHysteresisL0; // only 1 lsb are usefull
  logic [1:0] readDataHysteresisL1; // only 1 lsb are usefull
  logic [1:0] readDataHysteresisL2; // only 1 lsb are usefull
  logic [1:0] readDataHysteresisL0rr; // only 1 lsb are usefull
  logic [1:0] readDataHysteresisL0r; // only 1 lsb are usefull
  logic [1:0] readDataHysteresisL1r; // only 1 lsb are usefull
  
  logic startConvGauss0;
  logic startConvGauss1;
  logic startConvGauss2;
  logic startConvGauss3;
  logic startConvSobel0;
  logic startConvSobel1;
  logic startConvSobel2;
  logic startConvSobel3;
  logic startConvSobel4;
  logic startConvSobel5;
  logic startConvThreshold0;
  logic startConvThreshold1;
  logic startConvThreshold2;
  logic startConvThreshold3;
  logic startConvThreshold4;
  logic startConvThreshold5;
  logic startConvThreshold6;
  logic startConvThreshold7;
  logic startConvThreshold8;
  logic startConvHysteresis0;
  logic startConvHysteresis1;
  logic startConvHysteresis2;
  logic startConvHysteresis3;
  logic startConvHysteresis4;
  logic startConvHysteresis5;
  logic startConvHysteresis6;
  logic startConvHysteresis7;
  logic startConvHysteresis8;
  logic startConvHysteresis9;
  logic startConvHysteresis10;
  logic startConvHysteresis11;
    
//synthesis translate_off
  int fdGauss;
  int fdSobel;
  int fdThreshold;
  int fdHysteresis;
//synthesis translate_on

	enum logic [1:0]{
		S_RESET,
		S_CONV,
		S_WAIT
	} CS_GAUSS, NS_GAUSS, 
    CS_SOBEL, NS_SOBEL,
    CS_THRESHOLD, NS_THRESHOLD,
    CS_HYSTERESIS, NS_HYSTERESIS;

//synthesis translate_off
  initial begin
    fdGauss = $fopen("./python/landscape_large_8b_gauss_out.txt","w");
    fdSobel = $fopen("./python/landscape_large_12b_sobel_out.txt","w");
    fdThreshold = $fopen("./python/landscape_large_2b_threshold_out.txt","w");
    fdHysteresis = $fopen("./python/landscape_large_1b_hysteresis_out.txt","w");
  end
//synthesis translate_on

  assign startConvGauss0 = startConv;
  assign startConvSobel0 = busyConvGauss;
  assign startConvThreshold0 = busyConvSobel;
  assign startConvHysteresis0 = busyConvThreshold;

  assign pixelOutput = outputConvHysteresis;
  
	GAUSS 
  #(.x_input_size(x_input_size_step1),
    .y_input_size(y_input_size_step1),
    .x_conv_size(x_conv_size_step1),
    .y_conv_size(y_conv_size_step1))
  i_GAUSS(
    .clk(clk),
		.reset(reset),
		.startConv(startConvGauss),
		.bufferInput(inputConvGauss),
		.busyConv(busyConvGauss),
    .endOfConv(endOfConvGauss),
    .inLineConv(inLineConvGauss),
		.bufferOutput(outputConvGauss));
	
	SOBEL 
  #(.x_input_size(x_input_size_step2),
    .y_input_size(y_input_size_step2),
    .x_conv_size(x_conv_size_step2),
    .y_conv_size(y_conv_size_step2))
  i_SOBEL(
		.clk(clk),
		.reset(reset),
		.startConv(startConvSobel4),
		.bufferInput(inputConvSobel),
    .busyConv(busyConvSobel),
		.endOfConv(endOfConvSobel),
    .inLineConv(inLineConvSobel),
		.bufferOutput(outputConvSobel),
    .maxOutput(maxOutputSobel),
    .inFrame(!endConv));
  
	THRESHOLD
  #(.x_input_size(x_input_size_step3),
    .y_input_size(y_input_size_step3),
    .x_conv_size(x_conv_size_step3),
    .y_conv_size(y_conv_size_step3))
  i_THRESHOLD(
		.clk(clk),
		.reset(reset),
		.startConv(startConvThreshold4),
		.bufferInput(inputConvThreshold),
    .maxInput(maxOutputSobel),
    .busyConv(busyConvThreshold),
    .endOfConv(endOfConvThreshold),
    .inLineConv(inLineConvThreshold),		
    .bufferOutput(outputConvThreshold));
  
	HYSTERESIS 
  #(.x_input_size(x_input_size_step4),
    .y_input_size(y_input_size_step4),
    .x_conv_size(x_conv_size_step4),
    .y_conv_size(y_conv_size_step4))
  i_HYSTERESIS(
		.clk(clk),
		.reset(reset),
		.startConv(startConvHysteresis4),
		.bufferInput(inputConvHysteresis),
    .busyConv(busyConvHysteresis),
    .endOfConv(endOfConvHysteresis),
    .inLineConv(inLineConvHysteresis),		
		.bufferOutput(outputConvHysteresis));	  
  
	//Next State Logic
	always_ff @ (posedge clk, negedge reset) begin
		if(!reset) begin
			CS_GAUSS <= S_RESET;
			CS_SOBEL <= S_RESET;
			CS_THRESHOLD <= S_RESET;
			CS_HYSTERESIS <= S_RESET;
		end
		else begin
			CS_GAUSS <= NS_GAUSS;
			CS_SOBEL <= NS_SOBEL;
			CS_THRESHOLD <= NS_THRESHOLD;
			CS_HYSTERESIS <= NS_HYSTERESIS;
		end
	end	
	
	//Combinational Logic
	always_comb begin
		case(CS_GAUSS)
			S_RESET :	
      begin
        if(startConvGauss2 || startConvGauss3)			
          NS_GAUSS = S_CONV;
        else
          NS_GAUSS = S_RESET;
      end
      S_WAIT : 
      begin
        if((startConvGauss2 || startConvGauss3) && !endConv) 			
          NS_GAUSS = S_CONV;
        else 
          NS_GAUSS = S_WAIT;
      end
			S_CONV :	
      begin
        if((startConvGauss2 || startConvGauss3) && !endConv) 			
          NS_GAUSS = S_CONV;
        else 
          NS_GAUSS = S_WAIT;
      end			
		endcase
	end
  
	always_comb begin
		case(CS_SOBEL)
			S_RESET :	
      begin
        if(startConvSobel3 || startConvSobel4) 			
          NS_SOBEL = S_CONV;
        else 
          NS_SOBEL = S_RESET;
      end
      S_WAIT : 
      begin
        if((startConvSobel3 || startConvSobel4) && !endConv) 			
          NS_SOBEL = S_CONV;
        else 
          NS_SOBEL = S_WAIT;
      end
			S_CONV :	
      begin
        if((startConvSobel3 || startConvSobel4) && !endConv) 			
          NS_SOBEL = S_CONV;
        else 
          NS_SOBEL = S_WAIT;
      end			
		endcase
	end
	
	always_comb begin
		case(CS_THRESHOLD)
			S_RESET :	
      begin
        if(startConvThreshold4 || startConvThreshold5) 			
          NS_THRESHOLD = S_CONV;
        else 
          NS_THRESHOLD = S_RESET;
      end
      S_WAIT : 
      begin
        if((startConvThreshold4 || startConvThreshold5) && !endConv) 			
          NS_THRESHOLD = S_CONV;
        else 
          NS_THRESHOLD = S_WAIT;
      end
			S_CONV :	
      begin
        if((startConvThreshold4 || startConvThreshold5) && !endConv) 			
          NS_THRESHOLD = S_CONV;
        else 
          NS_THRESHOLD = S_WAIT;
      end			
		endcase
	end
  
	always_comb begin
		case(CS_HYSTERESIS)
			S_RESET :	
      begin
        if(startConvHysteresis5 || startConvHysteresis6) 			
          NS_HYSTERESIS = S_CONV;
        else 
          NS_HYSTERESIS = S_RESET;
      end
      S_WAIT : 
      begin
        if((startConvHysteresis5 || startConvHysteresis6) && !endConv) 			
          NS_HYSTERESIS = S_CONV;
        else 
          NS_HYSTERESIS = S_WAIT;
      end
			S_CONV :	
      begin
        if((startConvHysteresis5 || startConvHysteresis6) && !endConv) 			
          NS_HYSTERESIS = S_CONV;
        else 
          NS_HYSTERESIS = S_WAIT;
      end			
		endcase
	end
	//Registered operations
	always_ff @ (posedge clk, negedge reset) begin
    if (!reset) begin
      // GAUSS
      startConvGauss <= 0;
      rowsCompletedGauss <= 0;
      inputConvGauss <= '{default:'b0};
      writeCounterGauss0 <= 0;
      writeCounterGauss1 <= 0;
      writeCounterGauss2 <= 0;
      startConvGauss1 <= 0;
      startConvGauss2 <= 0;
      startConvGauss3 <= 0;
      readDataGaussL0rr <= 0;
      readDataGaussL0r <= 0;
      readDataGaussL1r <= 0;  
      // SOBEL      
      startConvSobel <= 0;
      rowsCompletedSobel <= 0;
      inputConvSobel <= '{default:'b0};
      writeCounterSobel0 <= 0;
      writeCounterSobel1 <= 0;
      writeCounterSobel2 <= 0;
      startConvSobel1 <= 0;
      startConvSobel2 <= 0;
      startConvSobel3 <= 0;
      startConvSobel4 <= 0;
      startConvSobel5 <= 0;
      readDataSobelL0rr <= 0;
      readDataSobelL0r <= 0;
      readDataSobelL1r <= 0;      
      // THRESHOLD      
      startConvThreshold <= 0;
      rowsCompletedThreshold <= 0;
      inputConvThreshold <= '{default:'b0};
      writeCounterThreshold0 <= 0;
      writeCounterThreshold1 <= 0;
      writeCounterThreshold2 <= 0;
      startConvThreshold1 <= 0;
      startConvThreshold2 <= 0;
      startConvThreshold3 <= 0;
      startConvThreshold4 <= 0;
      startConvThreshold5 <= 0;
      startConvThreshold6 <= 0;
      startConvThreshold7 <= 0;
      startConvThreshold8 <= 0;
      readDataThresholdL0rr <= 0;
      readDataThresholdL0r <= 0;
      readDataThresholdL1r <= 0; 
      // HYSTERESIS      
      startConvHysteresis <= 0;
      rowsCompletedHysteresis <= 0;
      inputConvHysteresis <= '{default:'b0};
      writeCounterHysteresis0 <= 0;
      writeCounterHysteresis1 <= 0;
      writeCounterHysteresis2 <= 0;
      startConvHysteresis1 <= 0;
      startConvHysteresis2 <= 0;
      startConvHysteresis3 <= 0;
      startConvHysteresis4 <= 0;
      startConvHysteresis5 <= 0;
      startConvHysteresis6 <= 0;
      startConvHysteresis7 <= 0;
      startConvHysteresis8 <= 0;
      startConvHysteresis9 <= 0;
      startConvHysteresis10 <= 0;
      startConvHysteresis11 <= 0;
      readDataHysteresisL0rr <= 0;
      readDataHysteresisL0r <= 0;
      readDataHysteresisL1r <= 0;  
		end
		else begin
      // GAUSS
      if(endOfConvGauss)
        rowsCompletedGauss <= rowsCompletedGauss + 1;
      startConvGauss1 <= startConvGauss0;
      startConvGauss2 <= startConvGauss1;
      startConvGauss3 <= startConvGauss2;
      readDataGaussL0rr <= readDataGaussL0r;
      readDataGaussL0r <= readDataGaussL0;
      readDataGaussL1r <= readDataGaussL1;
      if(startConvGauss0)
        writeCounterGauss0 <= writeCounterGauss0 + 1;
      else
        writeCounterGauss0 <= 0;
      if(startConvGauss1)
        writeCounterGauss1 <= writeCounterGauss1 + 1;
      else
        writeCounterGauss1 <= 0;
      if(startConvGauss2)
        writeCounterGauss2 <= writeCounterGauss2 + 1;
      else
        writeCounterGauss2 <= 0;
			case(NS_GAUSS)
				S_RESET :	
        begin
          rowsCompletedGauss <= 0;
          inputConvGauss <= '{default:'b0};
          inputConvGauss[0] <= '{default:'b0};
          inputConvGauss[1] <= '{default:'b0};
          inputConvGauss[2] <= '{default:'b0};
        end
        S_WAIT :	
        begin
          startConvGauss <= 0;
          inputConvGauss[0] <= '{default:'b0};
          inputConvGauss[1] <= '{default:'b0};
          inputConvGauss[2] <= '{default:'b0};
        end
				S_CONV :	
        begin
          startConvGauss <= 1;
          inputConvGauss[0] <= readDataGaussL0rr;
          inputConvGauss[1] <= readDataGaussL1r;
          inputConvGauss[2] <= readDataGaussL2;
        end
			endcase
      // SOBEL  
      if(endOfConvSobel)
        rowsCompletedSobel <= rowsCompletedSobel + 1;      
      startConvSobel1 <= startConvSobel0;
      startConvSobel2 <= startConvSobel1;
      startConvSobel3 <= startConvSobel2;
      startConvSobel4 <= startConvSobel3;
      startConvSobel5 <= startConvSobel4;
      readDataSobelL0rr <= readDataSobelL0r;
      readDataSobelL0r <= readDataSobelL0;
      readDataSobelL1r <= readDataSobelL1;
      if(startConvSobel3)
        writeCounterSobel0 <= writeCounterSobel0 + 1;
      else
        writeCounterSobel0 <= 0;
      if(startConvSobel4)
        writeCounterSobel1 <= writeCounterSobel1 + 1;
      else
        writeCounterSobel1 <= 0;
      if(startConvSobel5)
        writeCounterSobel2 <= writeCounterSobel2 + 1;
      else
        writeCounterSobel2 <= 0;  
			case(NS_SOBEL)
				S_RESET :	
        begin
          rowsCompletedSobel <= 0;
          inputConvSobel <= '{default:'b0};
          inputConvSobel[0] <= '{default:'b0};
          inputConvSobel[1] <= '{default:'b0};
          inputConvSobel[2] <= '{default:'b0};
        end
        S_WAIT :	
        begin
          startConvSobel <= 0;
          inputConvSobel[0] <= '{default:'b0};
          inputConvSobel[1] <= '{default:'b0};
          inputConvSobel[2] <= '{default:'b0};
        end
				S_CONV :	
        begin
          startConvSobel <= 1;
          inputConvSobel[0] <= readDataSobelL0rr;
          inputConvSobel[1] <= readDataSobelL1r;
          inputConvSobel[2] <= readDataSobelL2;
        end
			endcase
      // THRESHOLD  
      if(endOfConvThreshold)
        rowsCompletedThreshold <= rowsCompletedThreshold + 1;      
      startConvThreshold1 <= startConvThreshold0;
      startConvThreshold2 <= startConvThreshold1;
      startConvThreshold3 <= startConvThreshold2;
      startConvThreshold4 <= startConvThreshold3;
      startConvThreshold5 <= startConvThreshold4;
      startConvThreshold6 <= startConvThreshold5;
      startConvThreshold7 <= startConvThreshold6;
      startConvThreshold8 <= startConvThreshold7;
      readDataThresholdL0rr <= readDataThresholdL0r;
      readDataThresholdL0r <= readDataThresholdL0;
      readDataThresholdL1r <= readDataThresholdL1;
      if(startConvThreshold6)
        writeCounterThreshold0 <= writeCounterThreshold0 + 1;
      else
        writeCounterThreshold0 <= 0;
      if(startConvThreshold7)
        writeCounterThreshold1 <= writeCounterThreshold1 + 1;
      else
        writeCounterThreshold1 <= 0;
      if(startConvThreshold8)
        writeCounterThreshold2 <= writeCounterThreshold2 + 1;
      else
        writeCounterThreshold2 <= 0;    
			case(NS_SOBEL)
				S_RESET :	
        begin
          rowsCompletedThreshold <= 0;
          inputConvThreshold <= '{default:'b0};
          inputConvThreshold[0] <= '{default:'b0};
          inputConvThreshold[1] <= '{default:'b0};
          inputConvThreshold[2] <= '{default:'b0};
        end
        S_WAIT :	
        begin
          startConvThreshold <= 0;
          inputConvThreshold[0] <= '{default:'b0};
          inputConvThreshold[1] <= '{default:'b0};
          inputConvThreshold[2] <= '{default:'b0};
        end
				S_CONV :	
        begin
          startConvThreshold <= 1;
          inputConvThreshold[0] <= readDataThresholdL0rr;
          inputConvThreshold[1] <= readDataThresholdL1r;
          inputConvThreshold[2] <= readDataThresholdL2;
        end
			endcase
      // HYSTERESIS  
      if(endOfConvHysteresis)
        rowsCompletedHysteresis <= rowsCompletedHysteresis + 1;      
      startConvHysteresis1 <= startConvHysteresis0;
      startConvHysteresis2 <= startConvHysteresis1;
      startConvHysteresis3 <= startConvHysteresis2;
      startConvHysteresis4 <= startConvHysteresis3;
      startConvHysteresis5 <= startConvHysteresis4;
      startConvHysteresis6 <= startConvHysteresis5;
      startConvHysteresis7 <= startConvHysteresis6;
      startConvHysteresis8 <= startConvHysteresis7;
      startConvHysteresis9 <= startConvHysteresis8;
      startConvHysteresis10 <= startConvHysteresis9;
      startConvHysteresis11 <= startConvHysteresis10;
      readDataHysteresisL0rr <= readDataHysteresisL0r;
      readDataHysteresisL0r <= readDataHysteresisL0;
      readDataHysteresisL1r <= readDataHysteresisL1;
      if(startConvHysteresis9)
        writeCounterHysteresis0 <= writeCounterHysteresis0 + 1;
      else
        writeCounterHysteresis0 <= 0;
      if(startConvHysteresis10)
        writeCounterHysteresis1 <= writeCounterHysteresis1 + 1;
      else
        writeCounterHysteresis1 <= 0;
      if(startConvHysteresis11)
        writeCounterHysteresis2 <= writeCounterHysteresis2 + 1;
      else
        writeCounterHysteresis2 <= 0;   
			case(NS_SOBEL)
				S_RESET :	
        begin
          rowsCompletedHysteresis <= 0;
          inputConvHysteresis <= '{default:'b0};
          inputConvHysteresis[0] <= '{default:'b0};
          inputConvHysteresis[1] <= '{default:'b0};
          inputConvHysteresis[2] <= '{default:'b0};
        end
        S_WAIT :	
        begin
          startConvHysteresis <= 0;
          inputConvHysteresis[0] <= '{default:'b0};
          inputConvHysteresis[1] <= '{default:'b0};
          inputConvHysteresis[2] <= '{default:'b0};
        end
				S_CONV :	
        begin
          startConvHysteresis <= 1;
          inputConvHysteresis[0] <= readDataHysteresisL0rr;
          inputConvHysteresis[1] <= readDataHysteresisL1r;
          inputConvHysteresis[2] <= readDataHysteresisL2;
        end
			endcase
		end
	end

  // GAUSS DPRAM
  // input 8 bits
  // output 8 bits
  CANNY_DPRAM 
  #(.DATA_WIDTH(8),
    .ADDRESS_WIDTH(10)) 
  i_GAUSS_L0_DPRAM(
  .we_a(startConvGauss0),
  .clk_a(clk),
  .addr_a(writeCounterGauss0),
  .data_a(pixelValue),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounterGauss0),
  .data_b(8'd0),
  .q_b(readDataGaussL0));
  
  CANNY_DPRAM 
  #(.DATA_WIDTH(8),
    .ADDRESS_WIDTH(10)) 
  i_GAUSS_L1_DPRAM(
  .we_a(startConvGauss1),
  .clk_a(clk),
  .addr_a(writeCounterGauss1),
  .data_a(readDataGaussL0),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounterGauss1),
  .data_b(8'd0),
  .q_b(readDataGaussL1));
  
  CANNY_DPRAM 
  #(.DATA_WIDTH(8),
    .ADDRESS_WIDTH(10)) 
  i_GAUSS_L2_DPRAM(
  .we_a(startConvGauss2),
  .clk_a(clk),
  .addr_a(writeCounterGauss2),
  .data_a(readDataGaussL1),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounterGauss2),
  .data_b(8'd0),
  .q_b(readDataGaussL2));
  
  // SOBEL DPRAM
  // input 8 bits
  // output 12 bits
  CANNY_DPRAM 
  #(.DATA_WIDTH(12),
    .ADDRESS_WIDTH(10)) 
  i_SOBEL_L0_DPRAM(
  .we_a(startConvSobel3),
  .clk_a(clk),
  .addr_a(writeCounterSobel0),
  .data_a({4'd0,outputConvGauss}),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounterSobel0),
  .data_b(12'd0),
  .q_b(readDataSobelL0));
  
  CANNY_DPRAM 
  #(.DATA_WIDTH(12),
    .ADDRESS_WIDTH(10)) 
  i_SOBEL_L1_DPRAM(
  .we_a(startConvSobel4),
  .clk_a(clk),
  .addr_a(writeCounterSobel1),
  .data_a(readDataSobelL0),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounterSobel1),
  .data_b(12'd0),
  .q_b(readDataSobelL1));
  
  CANNY_DPRAM 
  #(.DATA_WIDTH(12),
    .ADDRESS_WIDTH(10)) 
  i_SOBEL_L2_DPRAM(
  .we_a(startConvSobel5),
  .clk_a(clk),
  .addr_a(writeCounterSobel2),
  .data_a(readDataSobelL1),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounterSobel2),
  .data_b(12'd0),
  .q_b(readDataSobelL2));
  
  // THRESHOLD DPRAM
  // input 12 bits
  // output 2 bits -> must be extended to 12 bits
  CANNY_DPRAM 
  #(.DATA_WIDTH(12),
    .ADDRESS_WIDTH(10)) 
  i_THRESHOLD_L0_DPRAM(
  .we_a(startConvThreshold6),
  .clk_a(clk),
  .addr_a(writeCounterThreshold0),
  .data_a(outputConvSobel),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounterThreshold0),
  .data_b(12'd0),
  .q_b(readDataThresholdL0));
  
  CANNY_DPRAM 
  #(.DATA_WIDTH(12),
    .ADDRESS_WIDTH(10)) 
  i_THRESHOLD_L1_DPRAM(
  .we_a(startConvThreshold7),
  .clk_a(clk),
  .addr_a(writeCounterThreshold1),
  .data_a(readDataThresholdL0),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounterThreshold1),
  .data_b(12'd0),
  .q_b(readDataThresholdL1));
  
  CANNY_DPRAM 
  #(.DATA_WIDTH(12),
    .ADDRESS_WIDTH(10)) 
  i_THRESHOLD_L2_DPRAM(
  .we_a(startConvThreshold8),
  .clk_a(clk),
  .addr_a(writeCounterThreshold2),
  .data_a(readDataThresholdL1),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounterThreshold2),
  .data_b(12'd0),
  .q_b(readDataThresholdL2));

  // HYSTERESIS DPRAM
  CANNY_DPRAM 
  #(.DATA_WIDTH(2),
    .ADDRESS_WIDTH(10)) 
  i_HYSTERESIS_L0_DPRAM(
  .we_a(startConvHysteresis9),
  .clk_a(clk),
  .addr_a(writeCounterHysteresis0),
  .data_a(outputConvThreshold),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounterHysteresis0),
  .data_b(2'd0),
  .q_b(readDataHysteresisL0));
  
  CANNY_DPRAM 
  #(.DATA_WIDTH(2),
    .ADDRESS_WIDTH(10)) 
  i_HYSTERESIS_L1_DPRAM(
  .we_a(startConvHysteresis10),
  .clk_a(clk),
  .addr_a(writeCounterHysteresis1),
  .data_a(readDataHysteresisL0),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounterHysteresis1),
  .data_b(2'd0),
  .q_b(readDataHysteresisL1));
  
  CANNY_DPRAM 
  #(.DATA_WIDTH(2),
    .ADDRESS_WIDTH(10)) 
  i_HYSTERESIS_L2_DPRAM(
  .we_a(startConvHysteresis11),
  .clk_a(clk),
  .addr_a(writeCounterHysteresis2),
  .data_a(readDataHysteresisL1),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounterHysteresis2),
  .data_b(2'd0),
  .q_b(readDataHysteresisL2));
  
//synthesis translate_off
  // 3 <= rows <= 480 => 478 rows
	always_ff @ (posedge clk iff inLineConvGauss && rowsCompletedGauss >= y_conv_size_step1 && rowsCompletedGauss <= y_input_size_step1)
    $fdisplay(fdGauss,"%2h",outputConvGauss);
  // 6 <= rows <= 481 => 476 rows
	always_ff @ (posedge clk iff inLineConvSobel && rowsCompletedSobel >= y_conv_size_step1+y_conv_size_step2 && rowsCompletedSobel <= y_input_size_step1+1)
    $fdisplay(fdSobel,"%3h",outputConvSobel);
  // 9 <= rows <= 482 => 634 rows
	always_ff @ (posedge clk iff inLineConvThreshold && rowsCompletedThreshold >= y_conv_size_step1+y_conv_size_step2+y_conv_size_step3 && rowsCompletedThreshold <= y_input_size_step1+2)
    $fdisplay(fdThreshold,"%1h",outputConvThreshold);
  // 12 <= rows <= 483 => 632 rows
	always_ff @ (posedge clk iff inLineConvHysteresis && rowsCompletedHysteresis >= y_conv_size_step1+y_conv_size_step2+y_conv_size_step3+y_conv_size_step4 && rowsCompletedHysteresis <= y_input_size_step1+3)
    $fdisplay(fdHysteresis,"%1h",outputConvHysteresis);
//synthesis translate_on

endmodule
