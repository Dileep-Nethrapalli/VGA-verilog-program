`timescale 1ns / 1ns

module VGA_from_COE_top(
          output HSYNC, VSYNC,
          output [3:0] RED, GRN, BLU,
          input clock, reset_n); 
    
       wire Pixel_Clock; 
       wire [31:0] Pixel_Count, Line_Count;
       wire [31:0] horizontal_back_porch;
       wire [31:0] horizontal_visible_area;
       wire [31:0] vertical_back_porch;
       wire [31:0] vertical_visible_area;  

       reg  [3:0]  red_in, green_in, blue_in;        
       wire [11:0] rgb_from_rom;    
      
              
  // Instantiate VGA 
   VGA_Controller vga_controller(
      .Hsync(HSYNC), .Vsync(VSYNC),
      .Red_out(RED), .Green_out(GRN), .Blue_out(BLU), 
      .pixel_clock(Pixel_Clock), 
      .pixel_count(Pixel_Count), .line_count (Line_Count),
      .Horizontal_back_porch(horizontal_back_porch),                                
      .Horizontal_visible_area(horizontal_visible_area),                                
      .Vertical_back_porch(vertical_back_porch), 
      .Vertical_visible_area(vertical_visible_area),                               
      .Red_in(red_in), .Green_in(green_in), .Blue_in(blue_in),                                
      .clock(clock), .reset_n(reset_n)); 
   
  		   	                      
 // Below code is for VGA 600 columns and 500 rows
   // If you want to use VGA full columns and rows COMMENT below code             			   	                      
  // Declare memory of size 12bit wide and 300000 Deep(600x500 = 300000).
  // initialize its memory locations with data from .coe file
  // DEPTH = HORIZONTAL_VISIBLE_AREA * VERTICAL_VISIBLE_AREA
  // DEPTH = 600*500 = 300000 = 100 1001 0011 1110 0000b
  // Set ROM_Address width as DEPTH in binary 
  
      reg [18:0] ROM_Address; 
   
  //INSTANTIATION Template of ROM IP    
      Block_ROM_300000x12 rom_ip (
       .clka(Pixel_Clock), // input clka
       .rsta(~reset_n), // input rsta
       .addra(ROM_Address), // input [18 : 0] addra
       .douta(rgb_from_rom) // output [11 : 0] douta
     );   
  
  // Address Generation for ROM  
     always@(negedge Pixel_Clock, negedge reset_n)  
       if(!reset_n)
         begin
           {red_in,green_in,blue_in} <= 0;
            ROM_Address <= 0;
         end
       else if(ROM_Address == 600 * 500)
         begin
           {red_in, green_in, blue_in} <= 0;
            ROM_Address <= 0;
         end  
       else if(Line_Count  >= vertical_back_porch && 
              (Line_Count < (vertical_back_porch + 500)))
            if(Pixel_Count  >= horizontal_back_porch && 
              (Pixel_Count < (horizontal_back_porch + 600)))
                begin
                  {red_in, green_in, blue_in} <= rgb_from_rom;
                   ROM_Address <= ROM_Address + 1; 
                end
            else //Pixel_Count
              begin
                {red_in,green_in,blue_in} <= 0;
                 ROM_Address <= ROM_Address;
              end                                                              
       else // Line_Count
         begin
           {red_in, green_in, blue_in} <= 0;                                         
            ROM_Address <= ROM_Address; 
         end

 
  // If you want to use VGA full columns and rows UNCOMMENT below code
  /* // Declare memory of size 12bit wide and 480000 Deep(800x600 = 480000).
    // initialize its memory locations with data from .coe file
    // DEPTH = HORIZONTAL_VISIBLE_AREA * VERTICAL_VISIBLE_AREA
    // DEPTH = 800*600 = 480000 = 111 0101 0011 0000 0000b
    // Set ROM_Address width as DEPTH in binary
      
       reg [18:0] ROM_Address;
 
    //INSTANTIATION Template of ROM IP    
       Block_ROM_480000x12 rom_ip (
         .clka(Pixel_Clock), // input clka
         .rsta(~reset_n), // input rsta
         .addra(ROM_Address), // input [18 : 0] addra
         .douta(rgb_from_rom) // output [11 : 0] douta
       );  
        
       
  // Address Generation for ROM  
  always@(negedge Pixel_Clock, negedge reset_n)  
    if(!reset_n)
       begin
         ROM_Address <= 0;
         {red_in, green_in, blue_in} <= 0;
       end
    else if(ROM_Address == horizontal_visible_area * vertical_visible_area)
       begin
         {red_in, green_in, blue_in} <= 0;
         ROM_Address <= 0;
       end  
    else if(Line_Count >= vertical_back_porch && 
            Line_Count < (vertical_back_porch + vertical_visible_area))
         if(Pixel_Count >= horizontal_back_porch && 
            Pixel_Count < (horizontal_back_porch + horizontal_visible_area))
            begin
              {red_in, green_in, blue_in} <= rgb_from_rom;
               ROM_Address <= ROM_Address + 1; 
            end
         else //Pixel_Count
           begin
             {red_in, green_in, blue_in} <= 0;
              ROM_Address <= ROM_Address;
           end                                                              
    else // Line_Count
      begin
        {red_in, green_in, blue_in} <= 0;                                         
         ROM_Address <= ROM_Address; 
      end
   */      
           	
 endmodule
