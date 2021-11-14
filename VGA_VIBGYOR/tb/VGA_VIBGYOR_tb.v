`timescale 1ns / 1ns

module VGA_VIBGYOR_tb();
    
     wire HSync_tb, VSync_tb;
     reg  clock_tb, reset_n_tb;
     wire [31:0] Whole_line, Whole_frame; 
     wire [31:0] pixel_count, line_count;      
     wire [3:0]  Red_out, Green_out, Blue_out;    
     wire [11:0] RGB_to_VGA;
  
   
  VGA_VIBGYOR_top vga_vibgyor_DUT (
     .HSYNC(HSync_tb), .VSYNC(VSync_tb),
     .RED(Red_out), .GRN(Green_out), .BLU(Blue_out),
     .clock(clock_tb), .reset_n(reset_n_tb));
                                   
        
    assign Pixel_Clock_tb = vga_vibgyor_DUT.Pixel_Clock;
    assign Whole_line = vga_vibgyor_DUT.vga_controller.WHOLE_LINE;  
    assign Whole_frame = vga_vibgyor_DUT.vga_controller.WHOLE_FRAME; 
    assign pixel_count = vga_vibgyor_DUT.vga_controller.pixel_count;  
    assign line_count = vga_vibgyor_DUT.vga_controller.line_count;        
    assign RGB_to_VGA = {Red_out, Green_out, Blue_out};
     
     
  initial clock_tb = 1'b1;
  always #5 clock_tb = ~clock_tb;
           
  initial
   begin
        reset_n_tb=0;
    #50 reset_n_tb=1; 
   end
   
   always@(pixel_count, line_count, Whole_line, Whole_frame) 
     if(pixel_count * line_count == ((Whole_line - 1) * (Whole_frame - 1)))
        $finish;
 
endmodule