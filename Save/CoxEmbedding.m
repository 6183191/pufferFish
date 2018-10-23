%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course :  Multimedia Data Security
% Project:  Spread Spectrum
%           Watermark Embedding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all;

%% Read original image 
I    = imread('lena.tif','tif');
[dimx,dimy] = size(I);
Id   = double(I);

%% Generate random watermark
rand('state',6);
w = round(rand(1,1000));
save('watermark','w');

%% Define watermark strenght
alpha = 0.9;

%% Compute DCT
%% HERE SOME CODE IS MISSING

%% Coefficient selection
%% HERE SOME CODE IS MISSING

%% Embedding
%% HERE SOME CODE IS MISSING

%inverse dct
%% HERE SOME CODE IS MISSING

imshow(I_inv,[]);
figure(); imshow(I);
 
%save watermarked image
imwrite(uint8(I_inv),'SSwat.tif','tif'); 
 
PSNR(uint8(I_inv),uint8(Id)) 

WPSNR(uint8(I_inv),uint8(Id)) 
 
