// A             : 0F -> 
// B             : 13 -> 
// C             : 10 -> 
// POWER         : 12 -> 
// 1             : 01 -> 
// 2             : 02 -> 
// 3             : 03 -> 
// CHANNEL UP    : 1A -> EXPO+
// 4             : 04 -> 
// 5             : 05 -> 
// 6             : 06 -> 
// CHANNEL DOWN  : 1E -> EXPO-
// 7             : 07 -> 
// 8             : 08 -> 
// 9             : 09 -> 
// VOLUME UP     : 1B -> GAIN+
// MENU          : 11 -> FINE ADJUST
// 0             : 00 -> 
// RETURN        : 17 -> SET CONFIG
// VOLUME DOWN   : 1F -> GAIN-
// PLAY          : 16 -> 
// ADJUST LEFT   : 14 -> 
// ADJUST RIGHT  : 18 -> 
// MUTE          : 0C -> SWITCH TEST PATTERN

// A             : 0F -> 
// B             : 13 -> 
// C             : 10 -> 
// POWER         : 12 -> 
// 1             : 01 -> 
// 2             : 02 -> 
// 3             : 03 -> 
// CHANNEL UP    : 1A -> EXPO+
// 4             : 04 -> 
// 5             : 05 -> 
// 6             : 06 -> 
// CHANNEL DOWN  : 1E -> EXPO-
// 7             : 07 -> 
// 8             : 08 -> 
// 9             : 09 -> 
// VOLUME UP     : 1B -> GAIN+
// MENU          : 11 -> FINE ADJUST
// 0             : 00 -> 
// RETURN        : 17 -> SET CONFIG
// VOLUME DOWN   : 1F -> GAIN-
// PLAY          : 16 -> 
// ADJUST LEFT   : 14 -> 
// ADJUST RIGHT  : 18 -> 
// MUTE          : 0C -> SWITCH TEST PATTERN

module IR_DECODER (
  iRST_n,
  iDATA,
  iDATA_READY,
  oEXPO,
  oGAIN,
  oEXPO_ENA,
  oGAIN_ENA,
  oSET_REG_TOG,
  oTEST_PATTERN
);
      
input         iRST_n;      
input   [7:0] iDATA;       
input         iDATA_READY; 
output [19:0] oEXPO;      
output [12:0] oGAIN;      
output        oEXPO_ENA;
output        oGAIN_ENA;
output        oSET_REG_TOG;
output  [7:0] oTEST_PATTERN;

reg    [19:0] expo;                
reg    [12:0] gain;   
reg           expo_ena;
reg           gain_ena;             
reg           fine_ena;   
reg           set_reg_tog;   
reg    [7:0]  test_pattern;

assign oEXPO = expo;
assign oGAIN = gain;
assign oEXPO_ENA = expo_ena;
assign oGAIN_ENA = gain_ena;
assign oSET_REG_TOG = set_reg_tog;
assign oTEST_PATTERN = test_pattern;

always @(negedge iDATA_READY or negedge iRST_n)	
  if (!iRST_n) begin
    expo = 20'h40000;    
    gain = 13'h02c0;   
    fine_ena <= 1'b0;
    test_pattern <= 8'b0000_0000;
    //test_pattern <= 8'b1001_0010; 

  end
  else begin
    case(iDATA)
      8'h1A:    begin 
                  expo_ena <= 1'b1;
                  gain_ena <= 1'b0;
                  if (fine_ena) begin
                    if (expo < 20'hFFEFF) 
                      expo <= expo + 20'h100; // EXPO+
                  end    
                  else begin
                    if (expo < 20'hFEFFF) 
                      expo <= expo + 20'h1000; // EXPO++
                    else begin
                      fine_ena <= 1'b1;
                      if (expo < 20'hFFEFF) 
                        expo <= expo + 20'h100; // EXPO+
                    end  
                  end
                end 
      8'h1E:    begin 
                  expo_ena <= 1'b1;
                  gain_ena <= 1'b0;
                  if (fine_ena) begin
                    if (expo > 20'h100) 
                      expo <= expo - 20'h100; // EXPO-
                  end    
                  else begin
                    if (expo > 20'h1000) 
                      expo <= expo - 20'h1000; // EXPO--
                    else begin
                      fine_ena <= 1'b1;
                      if (expo > 20'h100) 
                        expo <= expo - 20'h100; // EXPO-
                    end  
                  end
                end 
      8'h1B:    begin 
                  expo_ena <= 1'b0;
                  gain_ena <= 1'b1; 
                  if (fine_ena) begin
                    if (gain < 13'h1FEF) 
                      gain <= gain + 13'h10; // GAIN+
                  end    
                  else begin
                    if (gain < 13'h1EFF) 
                      gain <= gain + 13'h100; // GAIN++
                    else begin
                      fine_ena <= 1'b1;
                      if (gain < 13'h1FEF) 
                        gain <= gain + 13'h10; // GAIN+
                    end  
                  end
                end 
      8'h1F:    begin 
                  expo_ena <= 1'b0;
                  gain_ena <= 1'b1; 
                  if (fine_ena) begin
                    if (gain > 13'h10) 
                      gain <= gain - 13'h10; // GAIN-
                  end    
                  else begin
                    if (gain > 13'h100) 
                      gain <= gain - 13'h100; // GAIN--
                    else begin
                      fine_ena <= 1'b1;
                      if (gain > 13'h10) 
                        gain <= gain - 13'h10; // GAIN-
                    end  
                  end
                end 
      8'h11:    begin fine_ena <= ~fine_ena; end // FINE ADJUST
      8'h17:    begin set_reg_tog <= ~set_reg_tog; expo_ena <= 1'b0; gain_ena <= 1'b0; end // SET CONFIG
      8'h0C:    begin // SWITCH TEST PATTERN
                  case(test_pattern)
                    8'b0000_0000: test_pattern <= 8'b1000_0000; // standard vertical color bar
                    //8'b1000_0000: test_pattern <= 8'b1000_0100; // vertical grad top bottom black to white
                    //8'b1000_0100: test_pattern <= 8'b1000_1000; // horizontal grad right left black to white
                    8'b1000_0000: test_pattern <= 8'b1000_0010; // square color
                    8'b1000_0010: test_pattern <= 8'b1001_0010; // square black and white
                    8'b1001_0010: test_pattern <= 8'b1000_0001; // random data
                    8'b1000_0001: test_pattern <= 8'b0000_0000; // no test pattern
                    default:      test_pattern <= 8'b0000_0000; // no test pattern
                  endcase
                  set_reg_tog <= ~set_reg_tog; expo_ena <= 1'b0; gain_ena <= 1'b0; // set pattern test register value
                end
      default:  begin expo_ena <= 1'b0; gain_ena <= 1'b0; end
    endcase
  end

endmodule

