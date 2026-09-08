//-----AUTO SYNC_TO_NS---
module AUTO_SYNC_MODIFY (
  input   PCLK,
  input   VS,
  input   HS,
  output  M_VS,
  output  M_HS 
); 

//--v
MODIFY_SYNC i_MODIFY_SYNC_VS (
  .PCLK ( PCLK ),  
  .S    ( VS ), 
  .MS   ( M_VS )
);

//--h
MODIFY_SYNC i_MODIFY_SYNC_HS (
  .PCLK ( PCLK ),  
  .S    ( HS ), 
  .MS   ( M_HS )
);

endmodule 
