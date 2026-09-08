module VCM_I2C ( 
  input  RESET_N, 
	input  TR_IN, 
  input  RESET_SUB_N, 	
  input  CLK_50,
	
  output I2C_SCL, 
  inout  I2C_SDA,
  input  INT_n,
	
  output reg [15:0] R_VCM_DATA,
  input      [15:0] VCM_DATA, 
	output            CLK_400K,
  output reg        I2C_LO0P,
  output reg  [7:0] ST,
  output reg  [7:0] CNT,
	output reg  [7:0] WCNT,
  output reg  [7:0] SLAVE_ADDR,	 	
  output reg  [7:0] WORD_DATA,
  output reg  [7:0] POINTER,
	
	output            W_WORD_END,
  output reg        W_WORD_GO,
	
	output      [7:0] WORD_ST,
	output      [7:0] WORD_CNT,
	output      [7:0] WORD_BYTE,
  output     [15:0] R_DATA,
	output            SDAI_W,
	output            TR,
	output            I2C_SCL_O,
	input             TEST_MODE   
);

reg rTR_IN; 
	
//-- I2C clock 400k generater 
CLK_DIV i_CLK_DIV_I2C (  
  .CLK_IN   ( CLK_50 ), // 50 MHz
  .CLK_DIV  ( 125 ),
  .CLK_OUT  ( CLK_400K ) // 400 KHz
);
  
//======== Main-ST =======
//==Pointer NUM==
parameter SLAVE_ADDR1 = 8'h18;  // 2.5V_CORE_SENSE_P  2.5V_VCCIO_SENSE_P 
parameter P_STATUS = 8'h00; 
parameter TIME = 32'd400000/400;  
parameter TIME_LONG = 250000000;  

reg [31:0] DELAY;

wire  const_zero_sig/* synthesis keep */; 
wire  SDAO; 
wire  W_WORD_SCL; 
wire  W_WORD_SDAO;  
wire  W_POINTER_SCL; 
wire  W_POINTER_END; 
reg   W_POINTER_GO; 
wire  W_POINTER_SDAO; 
wire  R_SCL; 
wire  R_END; 
reg   R_GO; 
wire  R_SDAO;  
wire  RESET_N_1; 

always @(negedge RESET_N or posedge CLK_400K) begin 
  if (!RESET_N) begin 
    ST <= 0;
    W_POINTER_GO <= 1;
    R_GO <= 1;		 
    W_WORD_GO <= 1;
    WCNT <= 0;  
    CNT <= 0;
    DELAY <= 0;	
    I2C_LO0P <= 0;
    rTR_IN <= TR_IN; 
  end else begin 
    rTR_IN <= TR_IN; 
    case (ST)
      0 : begin 
        ST<=30; //Config Reg
        W_POINTER_GO <= 1;
        R_GO <= 1;		 
        W_WORD_GO <= 1;
        WCNT <= 0;  
        CNT <= 0;
        DELAY <= 0;	
      end
  //<----------------READ -------	
      1 : begin 
        ST <= 6; 
      end	
      2 : begin 
        if (CNT == 0)
          {SLAVE_ADDR[7:0], POINTER [7:0], WORD_DATA [7:0]} <= {SLAVE_ADDR1[7:0], VCM_DATA[15:0]};
        if (W_POINTER_END) begin  
          W_POINTER_GO <= 0; 
          ST <= 3; 
          DELAY <= 0; 
        end
      end
   // Write pointer
      3 : begin 
        DELAY <=DELAY + 1;
        if (DELAY == 2) begin 
          W_POINTER_GO <= 1;
          ST <= 4; 
        end
      end       
      4 : begin 
        if (W_POINTER_END) 
          ST <= 5; 	
      end              
      5 : begin 
        ST <= 6; 
      end 
      //delay
      //read DATA 		 
      6 : begin 
        if (R_END) begin  
          R_GO <= 0; 
          ST <= 7; 
          DELAY <= 0; 
        end
      end                
      7 : begin 
        DELAY <= DELAY + 1;
        if (DELAY == 2) begin 	 
          R_GO <= 1;
          ST <= 8; 
        end
      end       
      8 : begin 
        ST <= 9; 
      end       
      9 : begin 
        if (R_END) begin 
          if (CNT == 0)  
            R_VCM_DATA <= R_DATA; 
          CNT <= CNT + 1;
          ST <= 10;	
        end 
      end	
      10 : begin   
        if (CNT == 1) begin 
          if ((TEST_MODE) || (VCM_DATA[13:4] == R_VCM_DATA[13:4])) begin
            ST <= 28;
            I2C_LO0P <= 1; 
          end else begin  
            CNT <= 0; 
            ST <= 1;
          end 
        end else  
          ST <= 1;	
        DELAY <= 0;
        W_POINTER_GO <= 1;
        R_GO         <= 1;		 
        W_WORD_GO    <= 1; 	 	  
      end
//<----------------------------------READ-----------------------
      28 : begin
        if (DELAY < 5)
          DELAY <= DELAY + 1; 
        else begin 
          ST <= 29; 
          DELAY <= 0; 
        end  
      end 
//<----------------------------------WRITE WORD-----------------
      29 : begin
        if (DELAY < TIME) 
          DELAY <= DELAY + 1; 
        else  
          ST <= 30; 
      end	
      30 : begin 
        ST <= 31; 
        WCNT <= 0; 
      end	
      31 : begin 
        if (WCNT == 0) 
          {SLAVE_ADDR[7:0], POINTER[7:0], WORD_DATA[7:0]} <= {SLAVE_ADDR1[7:0], VCM_DATA[15:0]};
        if (W_WORD_END) begin  
          W_WORD_GO <= 0; 
          ST <= 32; 
          DELAY <= 0;  
        end
      end
// Write ID pointer 
      32: begin 
        if (DELAY == 3) begin 
          W_WORD_GO <= 1;
          ST <= 33; 
        end else  
          DELAY <= DELAY + 1;
      end       
      33 : begin 
        ST <= 34; 
      end       	
      34 : begin 
        if (W_WORD_END) begin 	
          WCNT <= WCNT + 1;			 
          ST <= 35; 
        end
      end              
      35 : begin 
        if (!rTR_IN & TR_IN) begin 
          if (WCNT == 1) begin   
            if (TEST_MODE) 
              ST <= 1;
            else 
              ST <= 29;
          WCNT <= 0;  
          CNT <= 0; 
          DELAY <= 0; 
          I2C_LO0P <= 0;  
        end 
        else 
          ST <= 31; 	 
        end	
      end 
    endcase 
  end 
end
//<-----------------------------MAIN-ST END ------------------------------------------


//============inout  i2c  q15(a10) example ===============  
// wire const_zero_sig /* synthesis keep */;
// assign const_zero_sig = 1\'b0;
// assign TRI_PIN = enable? const_zero_sig : \'bz;
//========================================================

assign const_zero_sig = 0 ; 

//I2C-BUS
assign I2C_SCL_O = W_WORD_SCL & W_POINTER_SCL & R_SCL;
assign SDAO = W_POINTER_SDAO & R_SDAO & W_WORD_SDAO;
assign I2C_SDA = ((SDAO)      || (RESET_N == 0)) ? 1'bz : const_zero_sig;
assign I2C_SCL = ((I2C_SCL_O) || (RESET_N == 0)) ? 1'b1 : 0;

//==== I2C WRITE WORD ===
I2C_WRITE_WDATA i_I2C_WRITE_WDATA (
  .RESET_N        ( RESET_N_1 ),
	.PT_CK          ( CLK_400K ),
	.GO             ( W_WORD_GO ),
	
	.POINTER        ( {POINTER[7:0], 8'h0} ),
  .WDATA	        ( {WORD_DATA[7:0], 8'h0} ),
	
	.SLAVE_ADDRESS  ( SLAVE_ADDR ),
	.SDAI           ( I2C_SDA ),
	.SDAO           ( W_WORD_SDAO ),
	.SCLO           ( W_WORD_SCL ),
	.END_OK         ( W_WORD_END ),
	//--for test      
	.ST             ( WORD_ST ),
	.CNT            ( WORD_CNT ),
	.BYTE           ( WORD_BYTE ),
	.ACK_OK         ( ),
	.SDAI_W         ( SDAI_W ),
	.BYTE_NUM       ( 2 )
);

//==== I2C WRITE POINTER ===
I2C_WRITE_PTR i_I2C_WRITE_PTR (
  .RESET_N        ( RESET_N_1 ),
	.PT_CK          ( CLK_400K ),
	.GO             (  W_POINTER_GO ),
	.POINTER        ( {POINTER[7:0], 8'h0 } ),
	.SLAVE_ADDRESS  ( SLAVE_ADDR ),
	.SDAI           ( I2C_SDA ),
	.SDAO           ( W_POINTER_SDAO ),
	.SCLO           ( W_POINTER_SCL ),
	.END_OK         ( W_POINTER_END ),
	//--for test      
	.ST             ( ),
	.ACK_OK         ( ),
	.CNT            ( ),
	.BYTE           ( ),
  .BYTE_END       ( 1 )
);

//==== I2C READ ===
I2C_READ_DATA i_I2C_READ_DATA ( 
  .RESET_N        ( RESET_N_1 ),
	.PT_CK          ( CLK_400K ),
	.GO             ( R_GO ),
	.SLAVE_ADDRESS  ( SLAVE_ADDR ),
	.SDAI           ( I2C_SDA ),
	.SDAO           ( R_SDAO ),
	.SCLO           ( R_SCL ),
	.END_OK         ( R_END ),
	.DATA16         ( R_DATA ),
	
	//--for test 
	.ST             ( ),
	.ACK_OK         ( ),
	.CNT            ( ),
	.BYTE           ( )  	,
	.END_BYTE       ( 1 )	
);

I2C_RESET_DELAY  i_I2C_RESET_DELAY (
  .CLK    ( CLK_50 ), 
  .READY  ( RESET_N_1 )
);	
	
endmodule
	
