image = imread('input.png'); %reading image

image = rgb2gray(image); %convert image to grayscale image
[height,width,~] = size(image);

% Algorithm parameters
alpha1 = 0.75;
alpha2 = 0.6;

W = randi([0 100],height,width); %random matrix W whose elements decide the operation to be done on a pixel 
W_star = zeros(height, width);   %matrix W as extracted from the encrypted from encrypted image

image_n = zeros(height, width);
output_image = zeros(height, width);

% For making Image_n  
for i = 1:height
   for j = 1:width
     
     if (i~=height && j~=width )
        image_n(i,j) = (floor((((image(i+1,j)+image(i+1,j+1))/2)+image(i,j+1))/2));
     elseif (i== height  && j~=width )
         image_n(i,j) = (floor(image(i,j+1)/2));
     elseif (i~=height  && j == width )
         image_n(i,j) = (floor((((image(i+1,j)+0)/2)+0)/2));
     end
     
   end                
end

for i = 1:height
   for j = 1:width
       
       if(W(i,j)<=90)
           W(i,j) = 0;
       elseif (W(i,j) > 90 && W(i,j)<=95)
           W(i,j) = 1;
       else
           W(i,j) = 2;
       end
       
   end
end

% For making output_image based on "W" matrix values
for i = 1:height
   for j = 1:width
       
       if(W(i,j)==0)
           output_image(i,j) = image(i,j);
       elseif (W(i,j) == 1)
            output_image(i,j) = double(alpha1*image(i,j)) + double((1-alpha1)*image_n(i,j));
       else
           output_image(i,j) = double(alpha2*image(i,j)) + double((1-alpha2)*image_n(i,j));
       end
       
   end
end


%-----------------End of encryption-------------------------

%-----------------Decryption--------------------------------


total = height*width;
match = 0;

% Making W_star matrix by analysing the watermarked image
for i = 1:height
   for j = 1:width
       
       if(output_image(i,j) - image(i,j) == 0)
           W_star(i,j) = 0;
       elseif (output_image(i,j) - image(i,j)>0)
           W_star(i,j) = 1;
       else
           W_star(i,j) = 2;
       end
       
   end
end

% Comparing W_star and W matrices
for i = 1:height
   for j = 1:width
       
       if(W_star(i,j)== W(i,j)) 
           match = match+1;
       end
       
   end
end

fprintf('Percentage matched is %f\n',(match/total)*100);
subplot(1,2,1), imshow(image)
subplot(1,2,2), imshow(mat2gray(output_image))