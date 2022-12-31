module GoBoard
  (input  i_Clk,       // Main Clock
   input i_Switch_1,

   output o_LED_1,
   output o_LED_2,
   output o_LED_3,
   output o_LED_4,

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
  reg [COLOR_BITS-1:0] w_Red_Video_Buf;
  wire [COLOR_BITS-1:0] w_Red_Video_Out;
  reg [COLOR_BITS-1:0] w_Grn_Video_Buf;
  wire [COLOR_BITS-1:0] w_Grn_Video_Out;
  reg [COLOR_BITS-1:0] w_Blu_Video_Buf;
  wire [COLOR_BITS-1:0] w_Blu_Video_Out;
  wire [9:0] w_Col_Count;
  wire [9:0] w_Row_Count;
  
  // Generates Sync Pulses to run VGA
  VGA_Counter VGA_Counter_Inst 
  (.i_Clk(i_Clk),
   .o_Col_Count(w_Col_Count),
   .o_Row_Count(w_Row_Count)
  );

  parameter X = 50;
  parameter Y = 50;
  parameter W = 20;
  parameter H = 100;

  always @(posedge i_Clk)
  begin
    //PATTERN CREATION
    if (X < w_Col_Count && w_Col_Count < X + W && Y < w_Row_Count && w_Row_Count < Y + H) begin
      w_Red_Video_Buf = {COLOR_BITS{1'b1}};
      if (i_Switch_1) begin
        w_Grn_Video_Buf = 0;
        w_Blu_Video_Buf = 0;
      end else begin
        w_Grn_Video_Buf = w_Red_Video_Buf;
        w_Blu_Video_Buf = w_Red_Video_Buf;
      end
    end else begin
      w_Red_Video_Buf = 0;
      w_Grn_Video_Buf = w_Red_Video_Buf;
      w_Blu_Video_Buf = w_Red_Video_Buf;
    end
  end
  
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

  assign o_LED_1 = 0;
  assign o_LED_2 = 0;
  assign o_LED_3 = 0;
  assign o_LED_4 = 0;
   
endmodule