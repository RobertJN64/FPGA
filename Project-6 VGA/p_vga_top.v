module GoBoard
  (input  i_Clk,       // Main Clock
   
   // VGA
   output o_VGA_HSync,
   output o_VGA_VSync,
   output o_VGA_Red_0,
   output o_VGA_Red_1,
   output o_VGA_Red_2,
   output o_VGA_Grn_0,
   output o_VGA_Grn_1,
   output o_VGA_Grn_2,
   output o_VGA_Blu_0,
   output o_VGA_Blu_1,
   output o_VGA_Blu_2);
    
  // VGA Constants to set Frame Size
  parameter COLOR_BITS = 3;
  parameter ACTIVE_COLS = 640;
  parameter ACTIVE_ROWS = 480;
 
  // Common VGA Signals
  wire [COLOR_BITS-1:0] w_Red_Video_TP, w_Red_Video_Porch;
  wire [COLOR_BITS-1:0] w_Grn_Video_TP, w_Grn_Video_Porch;
  wire [COLOR_BITS-1:0] w_Blu_Video_TP, w_Blu_Video_Porch;
  wire [9:0] w_Col_Count;
  wire [9:0] w_Row_Count;
  
  // Generates Sync Pulses to run VGA
  VGA_Counter VGA_Counter_Inst 
  (.i_Clk(i_Clk),
   .o_Col_Count(w_Col_Count),
   .o_Row_Count(w_Row_Count)
  );
   
  assign w_Red_Video_TP = (w_Col_Count < ACTIVE_COLS && w_Row_Count < ACTIVE_ROWS) ? {COLOR_BITS{1'b1}} : 0;
  assign w_Grn_Video_TP = (w_Col_Count < ACTIVE_COLS/2 && w_Row_Count < ACTIVE_ROWS) ? {COLOR_BITS{1'b1}} : 0;
  assign w_Blu_Video_TP = (w_Col_Count < ACTIVE_COLS && w_Row_Count < ACTIVE_ROWS/2) ? {COLOR_BITS{1'b1}} : 0;
     
  VGA_Sync VGA_Sync_Porch
   (.i_Clk(i_Clk),
    .i_Col_Count(w_Col_Count),
    .i_Row_Count(w_Row_Count),
    .i_Red_Video(w_Red_Video_TP),
    .i_Grn_Video(w_Grn_Video_TP),
    .i_Blu_Video(w_Blu_Video_TP),
    .o_HSync(o_VGA_HSync),
    .o_VSync(o_VGA_VSync),
    .o_Red_Video(w_Red_Video_Porch),
    .o_Grn_Video(w_Grn_Video_Porch),
    .o_Blu_Video(w_Blu_Video_Porch));
       
  assign o_VGA_Red_0 = w_Red_Video_Porch[0];
  assign o_VGA_Red_1 = w_Red_Video_Porch[1];
  assign o_VGA_Red_2 = w_Red_Video_Porch[2];
   
  assign o_VGA_Grn_0 = w_Grn_Video_Porch[0];
  assign o_VGA_Grn_1 = w_Grn_Video_Porch[1];
  assign o_VGA_Grn_2 = w_Grn_Video_Porch[2];
 
  assign o_VGA_Blu_0 = w_Blu_Video_Porch[0];
  assign o_VGA_Blu_1 = w_Blu_Video_Porch[1];
  assign o_VGA_Blu_2 = w_Blu_Video_Porch[2];
   
endmodule