module GoBoard
  (input  i_Clk,       // Main Clock
   input  i_Switch_1,
  
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
  
  wire w_Switch_1;
  reg  r_Switch_1 = 1'b0;
  reg [3:0] r_TP_Index = 0;

  Debounce_Switch Debounce_Switch_Inst
    (.i_Clk(i_Clk),
     .i_Switch(i_Switch_1),
     .o_Switch(w_Switch_1));
       
  // Purpose: When Switch is pressed, increment counter.
  // When counter gets to 9, start it back at 0 again.
  always @(posedge i_Clk)
  begin
    r_Switch_1 <= w_Switch_1;
       
      // Increment Count when switch is pushed down
      if (w_Switch_1 == 1'b1 && r_Switch_1 == 1'b0)
      begin
        if (r_TP_Index == 6)
          r_TP_Index <= 0;
        else
          r_TP_Index <= r_TP_Index + 1;
      end
  end
 
  // Common VGA Signals
  wire [c_VIDEO_WIDTH-1:0] w_Red_Video_TP, w_Red_Video_Porch;
  wire [c_VIDEO_WIDTH-1:0] w_Grn_Video_TP, w_Grn_Video_Porch;
  wire [c_VIDEO_WIDTH-1:0] w_Blu_Video_TP, w_Blu_Video_Porch;
  
  // Generates Sync Pulses to run VGA
  VGA_Sync_Pulses #(.TOTAL_COLS(c_TOTAL_COLS),
                    .TOTAL_ROWS(c_TOTAL_ROWS),
                    .ACTIVE_COLS(c_ACTIVE_COLS),
                    .ACTIVE_ROWS(c_ACTIVE_ROWS)) VGA_Sync_Pulses_Inst 
  (.i_Clk(i_Clk),
   .o_HSync(w_HSync_Start),
   .o_VSync(w_VSync_Start),
   .o_Col_Count(),
   .o_Row_Count()
  );
   
   
  // Drives Red/Grn/Blue video - Test Pattern 5 (Color Bars)
  Test_Pattern_Gen  #(.VIDEO_WIDTH(c_VIDEO_WIDTH),
                      .TOTAL_COLS(c_TOTAL_COLS),
                      .TOTAL_ROWS(c_TOTAL_ROWS),
                      .ACTIVE_COLS(c_ACTIVE_COLS),
                      .ACTIVE_ROWS(c_ACTIVE_ROWS))
  Test_Pattern_Gen_Inst
   (.i_Clk(i_Clk),
    .i_Pattern(r_TP_Index),
    .i_HSync(w_HSync_Start),
    .i_VSync(w_VSync_Start),
    .o_HSync(w_HSync_TP),
    .o_VSync(w_VSync_TP),
    .o_Red_Video(w_Red_Video_TP),
    .o_Grn_Video(w_Grn_Video_TP),
    .o_Blu_Video(w_Blu_Video_TP));
     
  VGA_Sync_Porch  #(.VIDEO_WIDTH(c_VIDEO_WIDTH),
                    .TOTAL_COLS(c_TOTAL_COLS),
                    .TOTAL_ROWS(c_TOTAL_ROWS),
                    .ACTIVE_COLS(c_ACTIVE_COLS),
                    .ACTIVE_ROWS(c_ACTIVE_ROWS))
  VGA_Sync_Porch_Inst
   (.i_Clk(i_Clk),
    .i_HSync(w_HSync_TP),
    .i_VSync(w_VSync_TP),
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