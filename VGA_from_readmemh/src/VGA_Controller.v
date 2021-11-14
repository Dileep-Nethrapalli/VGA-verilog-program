`timescale 1ns / 1ns

module VGA_Controller(
          output reg Hsync, Vsync, pixel_clock,
          output reg [3:0]  Red_out, Green_out, Blue_out,
          output reg [31:0] pixel_count, line_count, 
          output [31:0] Horizontal_back_porch,
          output [31:0] Horizontal_visible_area,
          output [31:0] Vertical_back_porch, 
          output [31:0] Vertical_visible_area,
          input  [3:0] Red_in, Green_in, Blue_in,
          input  clock, reset_n); 
          

// Enter VGA related values                         
 // Below values are for 800x600@72Hz VGA standard,
 //For different VGA standards visit www.vesa.org 

  parameter HORIZONTAL_VISIBLE_AREA = 800; 
  parameter HORIZONTAL_FRONT_PORCH = 56;   
  parameter HORIZONTAL_SYNC_PULSE = 120; 
  parameter HORIZONTAL_BACK_PORCH = 64;      
  parameter WHOLE_LINE = 1040; 
                   
  parameter VERTICAL_VISIBLE_AREA = 600;
  parameter VERTICAL_FRONT_PORCH = 37;
  parameter VERTICAL_SYNC_PULSE = 6;     
  parameter VERTICAL_BACK_PORCH = 23; 
  parameter WHOLE_FRAME = 666;
     
  assign Horizontal_back_porch = HORIZONTAL_BACK_PORCH; 
  assign Horizontal_visible_area = HORIZONTAL_VISIBLE_AREA;     
  assign Vertical_back_porch = VERTICAL_BACK_PORCH;
  assign Vertical_visible_area = VERTICAL_VISIBLE_AREA;

       
 // convert 100MHz Crystal Oscilater clock to 50MHz pixel clock 
    always@(posedge clock, negedge reset_n)
      if(!reset_n)
	     pixel_clock <= 0;
      else 
         pixel_clock <= ~pixel_clock;  
    
          
// Pixel counter
   always@(posedge pixel_clock, negedge reset_n)
     if(!reset_n)
        pixel_count <= 0;                  
     else if(pixel_count == (WHOLE_LINE - 1))
        pixel_count <= 0;	         
     else 
        pixel_count <= pixel_count + 1;  
             
    
// Horizontal Sync pulse Generation             
 always@(negedge pixel_clock, negedge reset_n)
  if(!reset_n)
     Hsync <= 1'b0;         
          //Back Porch + Visible area + Front Porch       
  else if((pixel_count >= 0) &&
          (pixel_count < (WHOLE_LINE - HORIZONTAL_SYNC_PULSE))) 
     Hsync <= 1'b1;  
  else  //Horizontal sync pulse   
     Hsync <= 1'b0;


 // Line counter   
    always@(posedge pixel_clock, negedge reset_n)
     if(!reset_n)
       line_count <= 0;      
     else if((line_count == WHOLE_FRAME - 1) &&
             (pixel_count == WHOLE_LINE - 1))
       line_count <= 0;           
     else if(pixel_count == WHOLE_LINE - 1)
       line_count <= line_count + 1;    
     else
       line_count <= line_count;  
     
                      
 // Vertical Sync Pulse Generation 
 always@(negedge pixel_clock, negedge reset_n)
  if(!reset_n)
     Vsync <= 1'b0;  
         //Back porch + Visible area + Front Porch      
  else if((line_count >= 0) && 
          (line_count < (WHOLE_FRAME - VERTICAL_SYNC_PULSE)))        
     Vsync <= 1'b1;                           
  else //vertical Sync Pulse  
     Vsync <= 1'b0;
     

// Assign inputs to VGA   
 always@(posedge pixel_clock, negedge reset_n) 
  if(!reset_n)  
    {Red_out, Green_out, Blue_out} <= 0;
           // Line visible area
  else if(line_count >= VERTICAL_BACK_PORCH && 
          line_count < (VERTICAL_BACK_PORCH + VERTICAL_VISIBLE_AREA)) 
        // Pixel visible area
    if(pixel_count >= HORIZONTAL_BACK_PORCH && 
       pixel_count < (HORIZONTAL_BACK_PORCH + HORIZONTAL_VISIBLE_AREA)) 
        {Red_out, Green_out, Blue_out} <= {Red_in, Green_in, Blue_in};
    else
        {Red_out, Green_out, Blue_out} <= 0;
  else
        {Red_out, Green_out, Blue_out} <= 0;
 

endmodule
