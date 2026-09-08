`timescale 1ns/1ps

module LINE_THRESHOLD_DPRAM
#(parameter DATA_WIDTH = 10,
  parameter ADDRESS_WIDTH = 16) 
(	input clk_a, clk_b,
  input [DATA_WIDTH-1:0] data_a, data_b,
	input [ADDRESS_WIDTH-1:0] addr_a, addr_b,
	input we_a, we_b,
	output reg [DATA_WIDTH-1:0] q_a, q_b);
  
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[0:(1<<ADDRESS_WIDTH)-1];
	
  //initial $readmemh("/home/jb/Documents/Electronique/DE10-Standard/D8M/DE10_Standard_D8M_RTL_card_identification_v1_2021_11_07/src/THRESHOLD_DPRAM.init", ram, 0, 52317);
  //initial ram = '{default:'b0};

	// Port A
	always @ (posedge clk_a)
	begin
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= ram[addr_a];
		end
	end
	
	// Port B
	always @ (posedge clk_b)
	begin
		if (we_b)
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else
		begin
			q_b <= ram[addr_b];
		end
	end
	
endmodule
