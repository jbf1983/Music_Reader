`timescale 1ns/1ps

module IMAGE_PROCESSING_TB();
    
	//Inputs
	reg clk;
	reg reset;
	reg [7:0] pixelValue;
	
	//Outputs
  reg visiblePixel;
  reg endOfFrame;
	wire busy;
	
	//Internal Signals
	reg [7:0] image [0:307199];  
  shortint visiblePixelCounter;
  shortint visibleLineCounter;
  logic VGA_HS;
  logic VGA_VS;
  shortint HFP;
  shortint HS;
  shortint HBP;
  shortint VFP;
  shortint VS;
  shortint VBP;
      
	
	IMAGE_PROCESSING i_IMAGE_PROCESSING(
		.clk(clk),
		.reset(reset),
		.startConv(visiblePixel),
		.endConv(endOfFrame),
		.pixelValue(pixelValue),
		.busy(busy)
	);
	
	initial $readmemh("./python/landscape_large_8b.txt", image, 0, 307199);
	
	initial begin
		clk = 0;
		reset = 0;
    pixelValue <= 8'b01010101;
    VGA_HS <= 0;
    VGA_VS <= 0;
    HFP <= 0;
    HS <= 0;
    HBP <= 0;
    VFP <= 0;
    VS <= 0;
    VBP <= 0;
    visiblePixel <= 0;
    endOfFrame <= 0;
		#150ns;
		reset = 1;
	end
  	
	always @ (posedge clk) begin
    if(!reset) begin
      pixelValue <= 8'b01010101;
      VGA_HS <= 0;
      VGA_VS <= 0;
      HFP <= 0;
      HS <= 0;
      HBP <= 0;
      VFP <= 0;
      VS <= 0;
      VBP <= 0;
      visiblePixel <= 0;
      endOfFrame <= 0;
    end 
    else begin
      // blanking
      VGA_HS <= 0;
      VGA_VS <= 0;
      wait(clk);
      // visible line
      VGA_HS <= 1;
      VGA_VS <= 1;
      for (visibleLineCounter = 0; visibleLineCounter < 484; visibleLineCounter++) begin
        for (visiblePixelCounter = 0; visiblePixelCounter < 640; visiblePixelCounter++) begin
          visiblePixel <= 1;
          pixelValue <= image[visibleLineCounter*640+visiblePixelCounter];
          wait(!clk); wait(clk);
        end
        // horizontal front porch
        visiblePixel <= 0;
        pixelValue <= 8'h55;
        for (HFP = 0; HFP < 16; HFP++) begin
          wait(!clk); wait(clk);
        end
        // horizontal synch
        VGA_HS <= 0;
        for (HS = 0; HS < 96; HS++) begin
          wait(!clk); wait(clk);
        end
        // horizontal back porch
        VGA_HS <= 1;
        for (HBP = 0; HBP < 48; HBP++) begin
          wait(!clk); wait(clk);
        end      
      end
      // vertical front porch
      pixelValue <= 8'h55;
      for (VFP = 0; VFP < 10; VFP++) begin
        wait(!clk); wait(clk);
      end
      // vertical synch
      VGA_VS <= 0;
      for (VS = 0; VS < 2; VS++) begin
        wait(!clk); wait(clk);
      end
      // vertical back porch
      VGA_VS <= 1;
      for (VBP = 0; VBP < 33; VBP++) begin
        wait(!clk); wait(clk);
      end          
      endOfFrame <= 1;
    end
	end
	    
	always #20ns clk = ~clk; // freq = 25MHz (approx pixel clock for VGA@60Hz, perfect freq is 25,175MHz))
  
// VGA Signal 640 x 480 @ 60 Hz Industry standard timing
// 
// General timing
// Screen refresh rate	60 Hz
// Vertical refresh	31.46875 kHz ---------> 31.25 kHz
// Pixel freq.	25.175 MHz ---------> 25.000 MHz
// 
// Horizontal timing (line)
// Polarity of horizontal sync pulse is negative.
// Scanline part	Pixels	Time [µs]
// Visible area	640	25.422045680238 ---------> 25.6
// Front porch	16	0.63555114200596 ---------> 
// Sync pulse	96	3.8133068520357 ---------> 
// Back porch	48	1.9066534260179 ---------> 
// Whole line	800	31.777557100298 ---------> 32.0
// 
// Vertical timing (frame)
// Polarity of vertical sync pulse is negative.
// Frame part	Lines	Time [ms]
// Visible area	480	15.253227408143 ---------> 15.360
// Front porch	10	0.31777557100298 ---------> 
// Sync pulse	2	0.063555114200596 ---------> 
// Back porch	33	1.0486593843098 ---------> 
// Whole frame	525	16.683217477656 ---------> 16.40625
	
endmodule
