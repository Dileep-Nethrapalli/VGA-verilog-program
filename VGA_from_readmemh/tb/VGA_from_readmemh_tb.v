`timescale 1ns / 1ps

//For VGA 800x600@72Hz standard

module VGA_from_readmemh_tb();

     reg  clock_tb, reset_n_tb;

     wire HSYNC_tb, VSYNC_tb; 
     wire pixel_clk;     
     wire [31:0] Whole_line, Whole_frame; 
     wire [31:0] pixel_count, line_count;      
     wire [3:0]  Red_out, Green_out, Blue_out;    
     wire [11:0] RGB_to_VGA;
                 
   
  VGA_from_readmemh_top vga_readmemh_DUT(
     .HSYNC(HSYNC_tb), .VSYNC(VSYNC_tb),
     .RED(Red_out), .GRN(Green_out), .BLU(Blue_out),    
     .clock(clock_tb), .reset_n(reset_n_tb));
     
                                 
   assign pixel_clk = vga_readmemh_DUT.vga_controller.pixel_clock;
   assign Whole_line = vga_readmemh_DUT.vga_controller.WHOLE_LINE;  
   assign Whole_frame = vga_readmemh_DUT.vga_controller.WHOLE_FRAME; 
   assign pixel_count = vga_readmemh_DUT.vga_controller.pixel_count;  
   assign line_count = vga_readmemh_DUT.vga_controller.line_count;        
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