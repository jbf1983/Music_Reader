`timescale 1ns/1ns

module LINE
#(parameter x_input_size = 500,
  parameter y_input_size = 418)
( input clk,
	input reset_n,
	input chipSelect,
	input readMem,
	input sof,
	output reg printMem,
	output reg busy,
  output reg [6:0] m_0,
  output reg [9:0] c_0,
  output reg [6:0] m_1,
  output reg [9:0] c_1,
  output reg [6:0] m_2,
  output reg [9:0] c_2,
  output reg [6:0] m_3,
  output reg [9:0] c_3,
  output reg [6:0] m_4,
  output reg [9:0] c_4,
  output reg [6:0] m_5,
  output reg [9:0] c_5,
  output reg [6:0] m_6,
  output reg [9:0] c_6,
  output reg [6:0] m_7,
  output reg [9:0] c_7,
  output reg [6:0] m_8,
  output reg [9:0] c_8,
  output reg [6:0] m_9,
  output reg [9:0] c_9,
  output reg [6:0] m_10,
  output reg [9:0] c_10,
  output reg [6:0] m_11,
  output reg [9:0] c_11,
  output reg [4:0] line_count);

	logic [25:0] houghCounter; // 0-42218000
	logic [8:0]  x_pointer; // 0-499
	logic [8:0]  y_pointer; // 0-417

	logic [15:0] houghBlankCounter; // 0-52318
	logic [15:0] thresholdCounter; // 0-52318
	logic [15:0] nmsCounter; // 0-52318
	logic [15:0] peakCounter; // 0-52318
	logic [6:0]  m_pointer; // 0-100
	logic [6:0]  m_pointer_old; // 0-100
	logic [9:0]  c_pointer; // 0-517
	logic [9:0]  c_pointer_old; // 0-517

	logic [17:0] writeCounter; // 0-209000
	logic [17:0] printCounter; // 0-209000
	logic [6:0]  step; // 0-100

  logic [6:0]  m_int;	
  logic [5:0]  m_abs;
	logic [18:0] c_int;
	logic [17:0] c_abs;
	logic [8:0]  c_mod;
	logic [8:0]  c_arr;
	logic [9:0]  c_sig;
  logic [9:0]  c_i;

  logic [18:0] i_int;
  logic [17:0] i_abs;
  logic [8:0]  i_mod;
  logic [9:0]  i_arr;
  logic [10:0] i_sig;
  
  logic        houghInput;
  logic [9:0]  thresholdInput;
  logic [9:0]  nmsInput;
  logic        writeInput;
  logic [9:0]  houghRead;
  logic [11:0] houghWrite;
  logic        houghNMS;
  logic [15:0] houghAddressRead;
  logic [15:0] houghAddressWrite;
  logic [15:0] houghAddressWrite_r;

  logic        readWE;
  logic        writeWE;
  logic [6:0]  numPeak; // 0-99
  logic [6:0]  numPeak_old; // 0-99
	
	logic [9:0]  houghBuffer [0:204];

	logic [10:0] m_sum;
	logic [12:0] c_sum;
	logic [6:0]  m_final; // 0-100
	logic [9:0]  c_final; // 0-517

  logic [6:0]  m_final_out; // 0-100
  logic [9:0]  c_final_out; // 0-517

	enum logic [3:0]{
		S_RESET,
		S_MEMREAD,
    S_HOUGH_BLANK,
    S_HOUGH,
    S_THRESHOLD,
    S_NMS,
    S_WRITE_BLANK,
    S_PEAK_FIND,
    S_WRITE_IMAGE,
    S_AVERAGE,
    S_AVERAGE_FINAL,
    S_SAVE_IMAGE
	} CS, NS;

	//Next State Logic
	always_ff @ (posedge clk, negedge reset_n) begin
		if(!reset_n) 
			CS <= S_RESET;
		else 
			CS <= NS;
	end	

	always_ff @ (posedge clk, negedge reset_n) begin
		if(!reset_n) 
			line_count <= 0;
		else begin
      case(line_count-1)
        0 : 
        begin
          m_0 <= m_final_out;
          c_0 <= c_final_out;
        end
        1 : 
        begin
          m_1 <= m_final_out;
          c_1 <= c_final_out;
        end
        2 : 
        begin
          m_2 <= m_final_out;
          c_2 <= c_final_out;
        end
        3 : 
        begin
          m_3 <= m_final_out;
          c_3 <= c_final_out;
        end
        4 : 
        begin
          m_4 <= m_final_out;
          c_4 <= c_final_out;
        end
        5 : 
        begin
          m_5 <= m_final_out;
          c_5 <= c_final_out;
        end
        6 : 
        begin
          m_6 <= m_final_out;
          c_6 <= c_final_out;
        end
        7 : 
        begin
          m_7 <= m_final_out;
          c_7 <= c_final_out;
        end
        8 : 
        begin
          m_8 <= m_final_out;
          c_8 <= c_final_out;
        end
        9 : 
        begin
          m_9 <= m_final_out;
          c_9 <= c_final_out;
        end
        10 : 
        begin
          m_10 <= m_final_out;
          c_10 <= c_final_out;
        end
        11 : 
        begin
          m_11 <= m_final_out;
          c_11 <= c_final_out;
        end
        default : 
        begin
          m_11 <= m_final_out;
          c_11 <= c_final_out;
        end
      endcase
    
      if (CS == S_RESET)
			  line_count <= 0;
      else if (CS != S_WRITE_IMAGE && NS == S_WRITE_IMAGE)
        line_count++;
    end
  end

	//Combinational Logic
	always_latch begin
		case(CS)
			S_RESET	:	
      begin
        step = 0;
        x_pointer = 0;		
        y_pointer = 0;	
        m_pointer = 0;
        c_pointer = 0;
        m_int = 0;
        m_abs = 0;
        c_int = 0;
        c_abs = 0;
        c_mod = 0;
        c_sig = 0;
        c_arr = 0;
        c_i = 0;
        i_int = 0;
        i_abs = 0;
        i_mod = 0;
        i_arr = 0;
        i_sig = 0;
        houghNMS = 0;
        writeWE = 0;
        houghAddressRead = 0;
        if (sof)			
          NS = S_MEMREAD;
        else 
          NS = S_RESET;
      end
			S_MEMREAD :	
      begin			
        c_i = 0;
        step = 0;
        x_pointer = 0;		
        y_pointer = 0;	
        m_pointer = 0;
        c_pointer = 0;
        houghAddressRead = 0;
        writeWE = 0;	
        houghNMS = 0;		
        if (printCounter < x_input_size * y_input_size)
          NS = S_MEMREAD;
        else 
          NS = S_HOUGH_BLANK;
      end
      S_HOUGH_BLANK	:	
      begin		
        c_i = 0;
        step = 0;
        x_pointer = 0;		
        y_pointer = 0;	
        m_pointer = 0;
        c_pointer = 0;
        houghAddressRead = 0;
        writeWE = 0;	
        houghNMS = 0;	
        if (houghBlankCounter <= 52318) begin
          houghAddressRead = 5050;
          NS = S_HOUGH_BLANK;
        end
        else       
          NS = S_HOUGH;
      end
      S_HOUGH	:	
      begin	
        writeWE = 0;	
        houghNMS = 0;		
        step = (houghCounter % 202) >> 1;
        x_pointer = (houghCounter / 202) % x_input_size;
        y_pointer = (houghCounter / (202 * x_input_size)) % y_input_size;
        m_pointer = 0;
        c_pointer = 0;
        m_int = step - 50;
        m_abs = m_int[6] ? -m_int : m_int;
        c_int = m_int[6] ? m_abs * x_pointer + y_pointer * 500 : -m_abs * x_pointer + y_pointer * 500;
        c_abs = c_int[18] ? -c_int : c_int;
        c_mod = c_abs % 500;
        c_arr = c_mod >= 250 ? c_abs / 500 + 1 : c_abs / 500;
        c_sig = c_int[18] ? -c_arr : c_arr;
        c_i = c_sig + 50;
        houghAddressRead = c_i * 101 + step;
        houghWrite = (houghInput) ? houghRead + 1 : houghRead;
        if (houghCounter < x_input_size * y_input_size * 101 * 2 + 1)
        //if (houghCounter < x_input_size * 5 * 101 * 2 + 1)
          NS = S_HOUGH;
        else       
          NS = S_THRESHOLD;
      end
      S_THRESHOLD :	
      begin	
        c_i = 0;
        step = 0;
        x_pointer = 0;		
        y_pointer = 0;	
        m_pointer = 0;
        c_pointer = 0;
        houghAddressRead = 0;
        writeWE = 0;	
        houghNMS = 0;	
        if (thresholdCounter <= 52318) 
          NS = S_THRESHOLD;
        else       
          NS = S_NMS;
      end
      S_NMS :	
      begin	
        c_i = 0;
        step = 0;
        x_pointer = 0;		
        y_pointer = 0;	
        m_pointer = 0;
        c_pointer = 0;
        houghAddressRead = 0;
        writeWE = 0;	
        houghNMS = 0;	
        if ((houghBuffer[102] > houghBuffer[000]) &&
            (houghBuffer[102] > houghBuffer[001]) &&
            (houghBuffer[102] > houghBuffer[002]) &&
            (houghBuffer[102] > houghBuffer[101]) &&
            (houghBuffer[102] > houghBuffer[103]) &&
            (houghBuffer[102] > houghBuffer[202]) &&
            (houghBuffer[102] > houghBuffer[203]) &&
            (houghBuffer[102] > houghBuffer[204]))
          houghNMS = 1;
        else
          houghNMS = 0;
        if (nmsCounter <= 52318+102) 
          NS = S_NMS;
        else       
          NS = S_WRITE_BLANK;
      end
      S_WRITE_BLANK :	
      begin	
        c_i = 0;
        step = 0;
        houghAddressRead = 0;
        houghNMS = 0;	
        x_pointer = writeCounter % x_input_size;
        y_pointer = (writeCounter / x_input_size) % y_input_size;
        writeWE = 1;
        if (writeCounter < x_input_size * y_input_size) 
          NS = S_WRITE_BLANK;
        else begin
          writeWE = 0;
          NS = S_PEAK_FIND;
        end
      end
      S_PEAK_FIND :	
      begin	
        c_i = 0;
        step = 0;
        x_pointer = 0;		
        y_pointer = 0;	
        houghAddressRead = 0;
        writeWE = 0;	
        houghNMS = 0;	
        if (writeInput)
          NS = S_AVERAGE;
        else if (peakCounter == 52318) 
          if (numPeak)
            NS = S_AVERAGE_FINAL;
          else 
            NS = S_SAVE_IMAGE;
        else 
          if (peakCounter <= 52318) 
            NS = S_PEAK_FIND;
          else       
            NS = S_SAVE_IMAGE;
      end
      S_AVERAGE :	
      begin	
        c_i = 0;
        step = 0;
        x_pointer = 0;		
        y_pointer = 0;	
        houghAddressRead = 0;
        writeWE = 0;	
        houghNMS = 0;	
        m_pointer = (peakCounter - 1) % 101;
        c_pointer = ((peakCounter - 1) / 101) % 518;
        if (numPeak_old > numPeak)
          NS = S_WRITE_IMAGE;
        else if (peakCounter == 52318)
          NS = S_WRITE_IMAGE;
        else 
          NS = S_PEAK_FIND;
      end
      S_AVERAGE_FINAL :	
      begin	
        c_i = 0;
        step = 0;
        x_pointer = 0;		
        y_pointer = 0;	
        houghAddressRead = 0;
        writeWE = 0;	
        houghNMS = 0;	
        NS = S_WRITE_IMAGE;
      end
      S_WRITE_IMAGE :	
      begin	
        c_i = 0;
        step = 0;
        houghAddressRead = 0;
        writeWE = 0;	
        houghNMS = 0;		
        x_pointer = writeCounter % x_input_size;
        y_pointer = (writeCounter / x_input_size) % y_input_size;
        i_int = ((m_final - 50) * x_pointer) + (c_final - 50) * 500;
        i_abs = i_int[18] ? -i_int : i_int;
        i_mod = i_abs % 500;
        i_arr = i_mod >= 250 ? i_abs / 500 + 1 : i_abs / 500;
        i_sig = i_int[18] ? -i_arr : i_arr;
        if (y_pointer == i_sig[8:0]) 
          writeWE = 1;
        else
          writeWE = 0;
        if (writeCounter < x_input_size * y_input_size) 
          NS = S_WRITE_IMAGE;
        else 
          NS = S_PEAK_FIND;
      end
      S_SAVE_IMAGE :	
      begin	
        c_i = 0;
        step = 0;
        x_pointer = 0;		
        y_pointer = 0;	
        m_pointer = 0;
        c_pointer = 0;
        houghAddressRead = 0;
        writeWE = 1;	
        houghNMS = 0;
        x_pointer = writeCounter % x_input_size;
        y_pointer = (writeCounter / x_input_size) % y_input_size;
        if (writeCounter <= x_input_size * y_input_size) 
          NS = S_SAVE_IMAGE;
        else begin
          writeWE = 0;	
          NS = S_RESET;
        end
      end
      default :
      begin
        c_i = 0;
        step = 0;
        x_pointer = 0;		
        y_pointer = 0;	
        m_pointer = 0;		
        c_pointer = 0;	
        houghAddressRead = 0;
        writeWE = 0;	
        houghNMS = 0;		
        NS = S_RESET;
      end
		endcase
	end
	
	//Registered operations
	always_ff @ (posedge clk, negedge reset_n) begin
    if (!reset_n) begin
      readWE <= 0;
      busy <= 0;
      houghBlankCounter <= -1;
      houghCounter <= -1;	
      thresholdCounter <= -1;
      nmsCounter <= -1;	
      peakCounter <= -1;	
      writeCounter <= -1;
      houghAddressWrite <= 0;
      houghAddressWrite_r <= 0;
      houghBuffer <= '{default:'b0};
      numPeak <= 0;
      numPeak_old <= 1;
      m_sum <= 0;
      c_sum <= 0;
      m_final <= 0;
      c_final <= 0;
      m_pointer_old <= 0;
      c_pointer_old <= 0;
      m_final_out <= 0;
      c_final_out <= 0;
		end
		else begin
      houghAddressWrite <= houghAddressRead;
      houghAddressWrite_r <= houghAddressWrite;
			case(NS)
				S_RESET	:	
        begin
          readWE <= 0;  
          busy <= 0;
          houghBlankCounter <= -1;
          houghCounter <= -1;	
          thresholdCounter <= -1;
          nmsCounter <= -1;	
          peakCounter <= -1;	
          writeCounter <= -1;
          houghAddressWrite <= 0;
          houghAddressWrite_r <= 0;
          houghBuffer <= '{default:'b0};
          numPeak <= 0;
          numPeak_old <= 1;
          m_sum <= 0;
          c_sum <= 0;
          m_final <= 0;
          c_final <= 0;
          m_pointer_old <= 0;
          c_pointer_old <= 0;
          m_final_out <= 0;
          c_final_out <= 0;
        end
				S_MEMREAD	:	
        begin					
          readWE <= 1;
          busy <= 1;	
        end
				S_HOUGH_BLANK	:	
        begin	
          houghBlankCounter++;
        end
				S_HOUGH	:	
        begin	
          readWE <= 0;
          houghCounter++;
        end
				S_THRESHOLD	:	
        begin																	
          thresholdCounter++;
        end
				S_NMS	:	
        begin			
          nmsCounter++;
          houghBuffer[0] <= nmsInput;         
          writeCounter <= -1;
          houghBuffer[001] <= houghBuffer[000];
          houghBuffer[002] <= houghBuffer[001];
          houghBuffer[003] <= houghBuffer[002];
          houghBuffer[004] <= houghBuffer[003];
          houghBuffer[005] <= houghBuffer[004];
          houghBuffer[006] <= houghBuffer[005];
          houghBuffer[007] <= houghBuffer[006];
          houghBuffer[008] <= houghBuffer[007];
          houghBuffer[009] <= houghBuffer[008];
          houghBuffer[010] <= houghBuffer[009];
          houghBuffer[011] <= houghBuffer[010];
          houghBuffer[012] <= houghBuffer[011];
          houghBuffer[013] <= houghBuffer[012];
          houghBuffer[014] <= houghBuffer[013];
          houghBuffer[015] <= houghBuffer[014];
          houghBuffer[016] <= houghBuffer[015];
          houghBuffer[017] <= houghBuffer[016];
          houghBuffer[018] <= houghBuffer[017];
          houghBuffer[019] <= houghBuffer[018];
          houghBuffer[020] <= houghBuffer[019];
          houghBuffer[021] <= houghBuffer[020];
          houghBuffer[022] <= houghBuffer[021];
          houghBuffer[023] <= houghBuffer[022];
          houghBuffer[024] <= houghBuffer[023];
          houghBuffer[025] <= houghBuffer[024];
          houghBuffer[026] <= houghBuffer[025];
          houghBuffer[027] <= houghBuffer[026];
          houghBuffer[028] <= houghBuffer[027];
          houghBuffer[029] <= houghBuffer[028];
          houghBuffer[030] <= houghBuffer[029];
          houghBuffer[031] <= houghBuffer[030];
          houghBuffer[032] <= houghBuffer[031];
          houghBuffer[033] <= houghBuffer[032];
          houghBuffer[034] <= houghBuffer[033];
          houghBuffer[035] <= houghBuffer[034];
          houghBuffer[036] <= houghBuffer[035];
          houghBuffer[037] <= houghBuffer[036];
          houghBuffer[038] <= houghBuffer[037];
          houghBuffer[039] <= houghBuffer[038];
          houghBuffer[040] <= houghBuffer[039];
          houghBuffer[041] <= houghBuffer[040];
          houghBuffer[042] <= houghBuffer[041];
          houghBuffer[043] <= houghBuffer[042];
          houghBuffer[044] <= houghBuffer[043];
          houghBuffer[045] <= houghBuffer[044];
          houghBuffer[046] <= houghBuffer[045];
          houghBuffer[047] <= houghBuffer[046];
          houghBuffer[048] <= houghBuffer[047];
          houghBuffer[049] <= houghBuffer[048];
          houghBuffer[050] <= houghBuffer[049];
          houghBuffer[051] <= houghBuffer[050];
          houghBuffer[052] <= houghBuffer[051];
          houghBuffer[053] <= houghBuffer[052];
          houghBuffer[054] <= houghBuffer[053];
          houghBuffer[055] <= houghBuffer[054];
          houghBuffer[056] <= houghBuffer[055];
          houghBuffer[057] <= houghBuffer[056];
          houghBuffer[058] <= houghBuffer[057];
          houghBuffer[059] <= houghBuffer[058];
          houghBuffer[060] <= houghBuffer[059];
          houghBuffer[061] <= houghBuffer[060];
          houghBuffer[062] <= houghBuffer[061];
          houghBuffer[063] <= houghBuffer[062];
          houghBuffer[064] <= houghBuffer[063];
          houghBuffer[065] <= houghBuffer[064];
          houghBuffer[066] <= houghBuffer[065];
          houghBuffer[067] <= houghBuffer[066];
          houghBuffer[068] <= houghBuffer[067];
          houghBuffer[069] <= houghBuffer[068];
          houghBuffer[070] <= houghBuffer[069];
          houghBuffer[071] <= houghBuffer[070];
          houghBuffer[072] <= houghBuffer[071];
          houghBuffer[073] <= houghBuffer[072];
          houghBuffer[074] <= houghBuffer[073];
          houghBuffer[075] <= houghBuffer[074];
          houghBuffer[076] <= houghBuffer[075];
          houghBuffer[077] <= houghBuffer[076];
          houghBuffer[078] <= houghBuffer[077];
          houghBuffer[079] <= houghBuffer[078];
          houghBuffer[080] <= houghBuffer[079];
          houghBuffer[081] <= houghBuffer[080];
          houghBuffer[082] <= houghBuffer[081];
          houghBuffer[083] <= houghBuffer[082];
          houghBuffer[084] <= houghBuffer[083];
          houghBuffer[085] <= houghBuffer[084];
          houghBuffer[086] <= houghBuffer[085];
          houghBuffer[087] <= houghBuffer[086];
          houghBuffer[088] <= houghBuffer[087];
          houghBuffer[089] <= houghBuffer[088];
          houghBuffer[090] <= houghBuffer[089];
          houghBuffer[091] <= houghBuffer[090];
          houghBuffer[092] <= houghBuffer[091];
          houghBuffer[093] <= houghBuffer[092];
          houghBuffer[094] <= houghBuffer[093];
          houghBuffer[095] <= houghBuffer[094];
          houghBuffer[096] <= houghBuffer[095];
          houghBuffer[097] <= houghBuffer[096];
          houghBuffer[098] <= houghBuffer[097];
          houghBuffer[099] <= houghBuffer[098];
          houghBuffer[100] <= houghBuffer[099];
          houghBuffer[101] <= houghBuffer[100];
          houghBuffer[102] <= houghBuffer[101];
          houghBuffer[103] <= houghBuffer[102];
          houghBuffer[104] <= houghBuffer[103];
          houghBuffer[105] <= houghBuffer[104];
          houghBuffer[106] <= houghBuffer[105];
          houghBuffer[107] <= houghBuffer[106];
          houghBuffer[108] <= houghBuffer[107];
          houghBuffer[109] <= houghBuffer[108];
          houghBuffer[110] <= houghBuffer[109];
          houghBuffer[111] <= houghBuffer[110];
          houghBuffer[112] <= houghBuffer[111];
          houghBuffer[113] <= houghBuffer[112];
          houghBuffer[114] <= houghBuffer[113];
          houghBuffer[115] <= houghBuffer[114];
          houghBuffer[116] <= houghBuffer[115];
          houghBuffer[117] <= houghBuffer[116];
          houghBuffer[118] <= houghBuffer[117];
          houghBuffer[119] <= houghBuffer[118];
          houghBuffer[120] <= houghBuffer[119];
          houghBuffer[121] <= houghBuffer[120];
          houghBuffer[122] <= houghBuffer[121];
          houghBuffer[123] <= houghBuffer[122];
          houghBuffer[124] <= houghBuffer[123];
          houghBuffer[125] <= houghBuffer[124];
          houghBuffer[126] <= houghBuffer[125];
          houghBuffer[127] <= houghBuffer[126];
          houghBuffer[128] <= houghBuffer[127];
          houghBuffer[129] <= houghBuffer[128];
          houghBuffer[130] <= houghBuffer[129];
          houghBuffer[131] <= houghBuffer[130];
          houghBuffer[132] <= houghBuffer[131];
          houghBuffer[133] <= houghBuffer[132];
          houghBuffer[134] <= houghBuffer[133];
          houghBuffer[135] <= houghBuffer[134];
          houghBuffer[136] <= houghBuffer[135];
          houghBuffer[137] <= houghBuffer[136];
          houghBuffer[138] <= houghBuffer[137];
          houghBuffer[139] <= houghBuffer[138];
          houghBuffer[140] <= houghBuffer[139];
          houghBuffer[141] <= houghBuffer[140];
          houghBuffer[142] <= houghBuffer[141];
          houghBuffer[143] <= houghBuffer[142];
          houghBuffer[144] <= houghBuffer[143];
          houghBuffer[145] <= houghBuffer[144];
          houghBuffer[146] <= houghBuffer[145];
          houghBuffer[147] <= houghBuffer[146];
          houghBuffer[148] <= houghBuffer[147];
          houghBuffer[149] <= houghBuffer[148];
          houghBuffer[150] <= houghBuffer[149];
          houghBuffer[151] <= houghBuffer[150];
          houghBuffer[152] <= houghBuffer[151];
          houghBuffer[153] <= houghBuffer[152];
          houghBuffer[154] <= houghBuffer[153];
          houghBuffer[155] <= houghBuffer[154];
          houghBuffer[156] <= houghBuffer[155];
          houghBuffer[157] <= houghBuffer[156];
          houghBuffer[158] <= houghBuffer[157];
          houghBuffer[159] <= houghBuffer[158];
          houghBuffer[160] <= houghBuffer[159];
          houghBuffer[161] <= houghBuffer[160];
          houghBuffer[162] <= houghBuffer[161];
          houghBuffer[163] <= houghBuffer[162];
          houghBuffer[164] <= houghBuffer[163];
          houghBuffer[165] <= houghBuffer[164];
          houghBuffer[166] <= houghBuffer[165];
          houghBuffer[167] <= houghBuffer[166];
          houghBuffer[168] <= houghBuffer[167];
          houghBuffer[169] <= houghBuffer[168];
          houghBuffer[170] <= houghBuffer[169];
          houghBuffer[171] <= houghBuffer[170];
          houghBuffer[172] <= houghBuffer[171];
          houghBuffer[173] <= houghBuffer[172];
          houghBuffer[174] <= houghBuffer[173];
          houghBuffer[175] <= houghBuffer[174];
          houghBuffer[176] <= houghBuffer[175];
          houghBuffer[177] <= houghBuffer[176];
          houghBuffer[178] <= houghBuffer[177];
          houghBuffer[179] <= houghBuffer[178];
          houghBuffer[180] <= houghBuffer[179];
          houghBuffer[181] <= houghBuffer[180];
          houghBuffer[182] <= houghBuffer[181];
          houghBuffer[183] <= houghBuffer[182];
          houghBuffer[184] <= houghBuffer[183];
          houghBuffer[185] <= houghBuffer[184];
          houghBuffer[186] <= houghBuffer[185];
          houghBuffer[187] <= houghBuffer[186];
          houghBuffer[188] <= houghBuffer[187];
          houghBuffer[189] <= houghBuffer[188];
          houghBuffer[190] <= houghBuffer[189];
          houghBuffer[191] <= houghBuffer[190];
          houghBuffer[192] <= houghBuffer[191];
          houghBuffer[193] <= houghBuffer[192];
          houghBuffer[194] <= houghBuffer[193];
          houghBuffer[195] <= houghBuffer[194];
          houghBuffer[196] <= houghBuffer[195];
          houghBuffer[197] <= houghBuffer[196];
          houghBuffer[198] <= houghBuffer[197];
          houghBuffer[199] <= houghBuffer[198];
          houghBuffer[200] <= houghBuffer[199];
          houghBuffer[201] <= houghBuffer[200];
          houghBuffer[202] <= houghBuffer[201];
          houghBuffer[203] <= houghBuffer[202];
          houghBuffer[204] <= houghBuffer[203];
        end
        S_WRITE_BLANK	:	
        begin																	
          writeCounter++;
        end
				S_PEAK_FIND	:	
        begin							
          writeCounter <= -1;
          peakCounter++;
        end
        S_AVERAGE :	
        begin	
          m_pointer_old <= m_pointer;
          c_pointer_old <= c_pointer;
          numPeak_old <= numPeak;
          if (c_pointer_old + 10 > c_pointer) begin
            numPeak++;
            m_sum <= m_sum + m_pointer;
            c_sum <= c_sum + c_pointer;
          end
          else begin
            numPeak <= 1;
            m_sum <= m_pointer;
            c_sum <= c_pointer;
            if (((m_sum % numPeak) * 2) > numPeak) begin
              m_final <= m_sum / numPeak + 1;
              m_final_out <= m_sum / numPeak + 1;
            end else begin
              m_final <= m_sum / numPeak;
              m_final_out <= m_sum / numPeak;
            end
            if (((c_sum % numPeak) * 2) > numPeak) begin
              c_final <= c_sum / numPeak + 1;
              c_final_out <= c_sum / numPeak + 1;
            end else begin
              c_final <= c_sum / numPeak;
              c_final_out <= c_sum / numPeak;
            end
          end
        end
        S_AVERAGE_FINAL :	
        begin	
          if ((((m_sum + m_pointer) % (numPeak + 1)) * 2) > (numPeak + 1)) begin
            m_final <= (m_sum + m_pointer) / (numPeak + 1) + 1;
            m_final_out <= (m_sum + m_pointer) / (numPeak + 1) + 1;
          end else begin
            m_final <= (m_sum + m_pointer) / (numPeak + 1);
            m_final_out <= (m_sum + m_pointer) / (numPeak + 1);
          end
          if ((((c_sum + c_pointer) % (numPeak + 1)) * 2) > (numPeak + 1)) begin
            c_final <= (c_sum + c_pointer) / (numPeak + 1) + 1;
            c_final_out <= (c_sum + c_pointer) / (numPeak + 1) + 1;
          end else begin
            c_final <= (c_sum + c_pointer) / (numPeak + 1);
            c_final_out <= (c_sum + c_pointer) / (numPeak + 1);
          end
        end
				S_WRITE_IMAGE	:	
        begin																	
          writeCounter++;
        end
        S_SAVE_IMAGE	:	
        begin																	
          writeCounter++;
        end
			endcase
		end
	end

	always_ff @ (posedge clk) begin
    if (sof)
      printCounter <= 0;
		else if (chipSelect) 
      printCounter++;
  end

  LINE_READ_DPRAM 
  #(.DATA_WIDTH(1),
    .ADDRESS_WIDTH(18)) 
  i_LINE_READ_DPRAM(
  .we_a(readWE),
  //.we_a(1'b0),
  .clk_a(clk),
  .addr_a(printCounter),
  .data_a(readMem),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(houghCounter/202),
  .data_b(),
  .q_b(houghInput));

  LINE_HOUGH_DPRAM 
  #(.DATA_WIDTH(12),
    .ADDRESS_WIDTH(16)) 
  i_LINE_HOUGH_DPRAM(
  .we_a(1'b0),
  .clk_a(clk),
  .addr_a(houghAddressRead),
  .data_a(),
  .q_a(houghRead),
  .we_b(NS == S_HOUGH_BLANK ? 1'b1 : NS == S_HOUGH ? ~houghCounter[0] && houghCounter > 0 : 1'b0),
  //.we_b(1'b0),
  .clk_b(clk),
  .addr_b(NS == S_HOUGH_BLANK ? houghBlankCounter : NS == S_HOUGH ? houghAddressWrite_r : thresholdCounter),
  .data_b(NS == S_HOUGH_BLANK ? 1'b0 : houghWrite),
  .q_b(thresholdInput));

  LINE_THRESHOLD_DPRAM 
  #(.DATA_WIDTH(12),
    .ADDRESS_WIDTH(16)) 
  i_LINE_THRESHOLD_DPRAM(
  .we_a(1'b1),
  .clk_a(clk),
  .addr_a(thresholdCounter-1),
  .data_a(thresholdInput > 230 ? thresholdInput : 0),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(nmsCounter),
  .data_b(),
  .q_b(nmsInput));

  LINE_NMS_DPRAM 
  #(.DATA_WIDTH(1),
    .ADDRESS_WIDTH(16)) 
  i_LINE_NMS_DPRAM(
  .we_a(1'b1),
  //.we_a(1'b0),
  .clk_a(clk),
  .addr_a(nmsCounter-104),
  .data_a((nmsCounter-104 <= 101 || nmsCounter-104 >= 52216 ||
           nmsCounter-104 % 101 == 0 || nmsCounter-104 % 101 == 100) ? 0 : houghNMS),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(peakCounter),
  .data_b(),
  .q_b(writeInput));

  LINE_WRITE_DPRAM 
  #(.DATA_WIDTH(1),
    .ADDRESS_WIDTH(18)) 
  i_LINE_WRITE_DPRAM(
  .we_a(NS == S_SAVE_IMAGE ? 1'b0 : writeWE),
  .clk_a(clk),
  .addr_a(writeCounter),
  .data_a(NS == S_WRITE_BLANK ? 1'b0 : 1'b1),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(writeCounter),
  .data_b(),
  .q_b(writeMem));

  LINE_PRINT_DPRAM 
  #(.DATA_WIDTH(1),
    .ADDRESS_WIDTH(18)) 
  i_LINE_PRINT_DPRAM(
  .we_a(NS == S_SAVE_IMAGE ? 1'b1 : 1'b0),
  .clk_a(clk),
  .addr_a(writeCounter - 1),
  .data_a(writeMem),
  .q_a(),
  .we_b(1'b0),
  .clk_b(clk),
  .addr_b(printCounter),
  .data_b(),
  .q_b(printMem));

endmodule
