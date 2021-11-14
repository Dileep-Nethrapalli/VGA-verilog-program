`timescale 1ns/1ns

// VGA 800x600@72Hz

module VGA_VIBGYOR_top(output HSYNC, VSYNC,
                       output [3:0] RED, GRN, BLU,
                       input clock, reset_n);       	

         reg  [3:0] red_in, green_in, blue_in;        
         wire Pixel_Clock; 
         wire [31:0] Pixel_Count;
         wire [31:0] Line_Count; 
         wire [31:0] horizontal_back_porch;
         wire [31:0] horizontal_visible_area;
         wire [31:0] vertical_back_porch;
         wire [31:0] vertical_visible_area; 
         reg  [6:0] lines; 
  
                               
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
                              			   	                      
 
  //VIBGYOR Colors Generation
   // 800 pixels per line/7 colors = 114 pixels per color
    
   always@(horizontal_visible_area, reset_n)
     if(!reset_n)
       lines = 0;
     else
       lines = horizontal_visible_area/7; 
    

   always@(negedge Pixel_Clock, negedge reset_n)
     if(~reset_n)	
       {red_in, green_in, blue_in} = 12'h000;
     	         	  
     else if(Line_Count >= vertical_back_porch &&
             Line_Count < (vertical_back_porch + vertical_visible_area))

         if((Pixel_Count >= horizontal_back_porch) &&
            (Pixel_Count <= (horizontal_back_porch + lines))) 
            {red_in, green_in, blue_in} = 12'h90D;  //Violet color
        	  	  
         else if((Pixel_Count >= (horizontal_back_porch + lines + 1)) && 
                 (Pixel_Count <= (horizontal_back_porch + 2*lines)))              
            {red_in, green_in, blue_in} = 12'h408;  //Indigo color	
             
         else if((Pixel_Count >= horizontal_back_porch + 2*lines + 1) && 
                 (Pixel_Count <= horizontal_back_porch + 3*lines))              
            {red_in, green_in, blue_in} = 12'h00F;  //Blue color
        				  
         else if((Pixel_Count >= (horizontal_back_porch + 3*lines + 1)) &&
                 (Pixel_Count <= (horizontal_back_porch + 4*lines)))              
           {red_in, green_in, blue_in} = 12'h0F0;   //Green color
     
         else if((Pixel_Count >= (horizontal_back_porch + 4*lines + 1)) &&
                 (Pixel_Count <= (horizontal_back_porch + 5*lines)))              
           {red_in, green_in, blue_in} = 12'hFF0;   //Yellow color
      
         else if((Pixel_Count >= (horizontal_back_porch + 5*lines + 1)) && 
                 (Pixel_Count <= (horizontal_back_porch + 6*lines)))              
           {red_in, green_in, blue_in} = 12'hF70;   //Orange color
      
         else if((Pixel_Count >= (horizontal_back_porch + 6*lines + 1)) &&
                 (Pixel_Count <=  horizontal_back_porch + horizontal_visible_area))              
            {red_in, green_in, blue_in} = 12'hF00;  //Red color
      
         else // Pixel           
           {red_in, green_in, blue_in} = 12'h000;   //Black color
           
     else // Line	
       {red_in, green_in, blue_in} = 12'h000;  //Black color
        
        
endmodule
