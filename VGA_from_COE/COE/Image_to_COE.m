% Image to coe conversion

% Change Directory
    cd D:/Dileep/VGA/VGA_from_ROM_COE/COE
    
% Read the original image from a file.
   Image_origianl = imread('./Rainbow_Lorikeet.jpg');
 
% If you want to extract all columns and rows of image
 %  Image = Image_origianl;

% Crop the image to 600 colomns and 500 Rows.
   Image = Image_origianl(51:550, 61:660, :);
   imshow(Image);   
   
   [ROWS, COLUMNS, DEPTH] = size(Image);

   Red_Frame = floor(double(Image(:, :, 1)) ./ 16);   
   Green_Frame = floor(double(Image(:, :, 2)) ./ 16);  
   Blue_Frame = floor(double(Image(:, :, 3)) ./ 16); 
        
% To Convert 24-bit RGB to 12-bit RGB 
 % First divide the 8-bit Red or Green or Blue pixel number by 16
 % Convert the 4 bit Decimal number to Haxadecimal
 % write 12-bit RGB Frame as COE file 

  fid = fopen('./Rainbow_Lorikeet_600x500_12bit_COE.coe', 'wt');  
    
  fprintf(fid,'memory_initialization_radix = 16; \n');    
  fprintf(fid,'memory_initialization_vector = \n');

  row_count = 1; 
    
for Line = 1:1:ROWS
 for Pixel = 1:1:COLUMNS     
  
 fprintf(fid, '%c', dec2hex(Red_Frame(Line, Pixel))); 
 fprintf(fid, '%c', dec2hex(Green_Frame(Line, Pixel)));    
 fprintf(fid, '%c', dec2hex(Blue_Frame(Line, Pixel)));   
 
 if row_count == (ROWS * COLUMNS)
     fprintf(fid, ';');
     break;
 else
     fprintf(fid, ',\n'); 
     row_count = row_count + 1; 
 end  
       
 end
end
 
fclose(fid);
