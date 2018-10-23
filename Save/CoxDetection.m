%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course :  Multimedia Data Security
% Project:  Spread Spectrum
%           Watermark Detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;clc;

%original image
I    = imread('lena.tif','tif');
%watermarked image
Iw   = imread('SSwat.tif','tif');

[dimx,dimy] = size(Iw);
Iw = double(Iw);
I  = double(I);

% load original watermark
load('watermark.mat');

%define watermark strength
alpha = 0.9;

%DCT transform
%% HERE SOME CODE IS MISSING

%Coefficient selection for watermarked image
%% HERE SOME CODE IS MISSING

%Coefficient selection for original image
%% HERE SOME CODE IS MISSING

%watermark extraction
%% HERE SOME CODE IS MISSING

%detection
%% HERE SOME CODE IS MISSING

%Compute threshold
%% HERE SOME CODE IS MISSING

%Decision
if SIM > T
    fprintf('Mark have been found. \nSIM = %f\n', SIM);
else
    fprintf('Mark have been lost. \nSIM = %f\n', SIM);
end
