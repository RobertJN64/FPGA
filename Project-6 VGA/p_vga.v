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
  wire [COLOR_BITS-1:0] w_Red_Video_Buf, w_Red_Video_Out;
  wire [COLOR_BITS-1:0] w_Grn_Video_Buf, w_Grn_Video_Out;
  wire [COLOR_BITS-1:0] w_Blu_Video_Buf, w_Blu_Video_Out;
  wire [9:0] w_Col_Count;
  wire [9:0] w_Row_Count;
  
  // Generates Sync Pulses to run VGA
  VGA_Counter VGA_Counter_Inst 
  (.i_Clk(i_Clk),
   .o_Col_Count(w_Col_Count),
   .o_Row_Count(w_Row_Count)
  );


  //PATTERN CREATION 
  assign w_Red_Video_Buf = (w_Col_Count < 2 || w_Row_Count < 2 || w_Col_Count >= ACTIVE_COLS - 2 || w_Row_Count > ACTIVE_ROWS - 2) ? {COLOR_BITS{1'b1}} : 0;
  assign w_Grn_Video_Buf = w_Red_Video_Buf;
  assign w_Blu_Video_Buf = w_Grn_Video_Buf;
     
  VGA_Sync VGA_Sync_Porch
   (.i_Clk(i_Clk),
    .i_Col_Count(w_Col_Count),
    .i_Row_Count(w_Row_Count),
    .i_Red_Video(w_Red_Video_Buf),
    .i_Grn_Video(w_Grn_Video_Buf),
    .i_Blu_Video(w_Blu_Video_Buf),
    .o_HSync(o_VGA_HSync),
    .o_VSync(o_VGA_VSync),
    .o_Red_Video(w_Red_Video_Out),
    .o_Grn_Video(w_Grn_Video_Out),
    .o_Blu_Video(w_Blu_Video_Out));
       
  assign o_VGA_Red_0 = w_Red_Video_Out[0];
  assign o_VGA_Red_1 = w_Red_Video_Out[1];
  assign o_VGA_Red_2 = w_Red_Video_Out[2];
   
  assign o_VGA_Grn_0 = w_Grn_Video_Out[0];
  assign o_VGA_Grn_1 = w_Grn_Video_Out[1];
  assign o_VGA_Grn_2 = w_Grn_Video_Out[2];
 
  assign o_VGA_Blu_0 = w_Blu_Video_Out[0];
  assign o_VGA_Blu_1 = w_Blu_Video_Out[1];
  assign o_VGA_Blu_2 = w_Blu_Video_Out[2];
   
endmodule