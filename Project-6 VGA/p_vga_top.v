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
  parameter c_VIDEO_WIDTH = 3;
  parameter c_TOTAL_COLS  = 800;
  parameter c_TOTAL_ROWS  = 525;
  parameter c_ACTIVE_COLS = 640;
  parameter c_ACTIVE_ROWS = 480;
 
  // Common VGA Signals
  wire [c_VIDEO_WIDTH-1:0] w_Red_Video_TP, w_Red_Video_Porch;
  wire [c_VIDEO_WIDTH-1:0] w_Grn_Video_TP, w_Grn_Video_Porch;
  wire [c_VIDEO_WIDTH-1:0] w_Blu_Video_TP, w_Blu_Video_Porch;
  wire [9:0] w_Col_Count;
  wire [9:0] w_Row_Count;
  
  // Generates Sync Pulses to run VGA
  VGA_Sync_Pulses #(.TOTAL_COLS(c_TOTAL_COLS),
                    .TOTAL_ROWS(c_TOTAL_ROWS),
                    .ACTIVE_COLS(c_ACTIVE_COLS),
                    .ACTIVE_ROWS(c_ACTIVE_ROWS)) VGA_Sync_Pulses_Inst 
  (.i_Clk(i_Clk),
   .o_HSync(w_HSync_Start),
   .o_VSync(w_VSync_Start),
   .o_Col_Count(w_Col_Count),
   .o_Row_Count(w_Row_Count)
  );
   
  assign w_Red_Video_TP = (w_Col_Count < c_ACTIVE_COLS && w_Row_Count < c_ACTIVE_ROWS) ? {c_VIDEO_WIDTH{1'b1}} : 0;
  assign w_Grn_Video_TP = (w_Col_Count < c_ACTIVE_COLS/2 && w_Row_Count < c_ACTIVE_ROWS) ? {c_VIDEO_WIDTH{1'b1}} : 0;;
  assign w_Blu_Video_TP = 0;
     
  VGA_Sync_Porch  #(.VIDEO_WIDTH(c_VIDEO_WIDTH),
                    .TOTAL_COLS(c_TOTAL_COLS),
                    .TOTAL_ROWS(c_TOTAL_ROWS),
                    .ACTIVE_COLS(c_ACTIVE_COLS),
                    .ACTIVE_ROWS(c_ACTIVE_ROWS))
  VGA_Sync_Porch_Inst
   (.i_Clk(i_Clk),
    .i_Red_Video(w_Red_Video_TP),
    .i_Grn_Video(w_Grn_Video_TP),
    .i_Blu_Video(w_Blu_Video_TP),
    .o_HSync(w_HSync_Porch),
    .o_VSync(w_VSync_Porch),
    .o_Red_Video(w_Red_Video_Porch),
    .o_Grn_Video(w_Grn_Video_Porch),
    .o_Blu_Video(w_Blu_Video_Porch));
       
  assign o_VGA_HSync = w_HSync_Porch;
  assign o_VGA_VSync = w_VSync_Porch;
       
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