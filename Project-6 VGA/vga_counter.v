// Manages Col_Count and Row_Count

module VGA_Counter
  (input            i_Clk, 
   output reg [9:0] o_Col_Count = 0, 
   output reg [9:0] o_Row_Count = 0
  );  

  parameter TOTAL_COLS  = 800;
  parameter TOTAL_ROWS  = 525;
   
  always @(posedge i_Clk)
  begin
    if (o_Col_Count == TOTAL_COLS-1)
    begin
      o_Col_Count <= 0;
      if (o_Row_Count == TOTAL_ROWS-1)
        o_Row_Count <= 0;
      else
        o_Row_Count <= o_Row_Count + 1;
    end
    else
      o_Col_Count <= o_Col_Count + 1;
  end
endmodule