function embeddedImage = embedding(original)
%EMBEDDINGSAVE Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course :	Multimedia Data Security (2016)
% Project: 	Spread Spectrum
%           Watermark Embedding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I    = imread(original);
[dimx,dimy] = size(I);
Id   = double(I);

rng(6);
nValues=1024;
div=50000;




%watermark random, da sostituire!!!!!!!!!!!!!!!!
%w = round(rand(1,nValues));
w = open("pufferfish.mat");
w = w.w;
w = reshape(w, 1, nValues);



alpha = 5.5;

%DCT transform
It = dct2(Id);
It_re = reshape(It,1,dimx*dimy);

%Modulo and sign
It_sgn = sign(It_re);
It_mod = abs(It_re);

%Modulo sorting
[It_sort,Ix] = sort(It_mod,'descend');

%Embedding
Itw_mod = It_mod; 
kfin=0;
min=100;
max=0;
k = 50000;
ks=zeros(1,50);
Itw2_mod=Itw_mod;
for f=1:30
    
    Itw2_mod = It_mod; 
    h=k;
    for j = 1:nValues
        
        m = Ix(h);
        Itw2_mod(m) = It_mod(m)*(1+alpha-1);
      %  Itw2_mod(m) = It_mod(m)*(1+alpha*tmpW(j));
    %     Itw_mod(m) = It_mod(m)*exp(alpha*w(j));
        h = h+1;
     % k=round(k+(div/(k-1)));
        
    end
    % recover sign
    It_new = Itw2_mod.*It_sgn;
    
    %watermark, from vector to matrix
    It_newi=reshape(It_new,dimx,dimy);
    %inverse dct
    I_inv2 = idct2(It_newi);
    wpsnr=WPSNR(uint8(I_inv2),uint8(Id));
    ks(f)=wpsnr;
    if(wpsnr>max)
        max=wpsnr;
        maxk=k;
    end
    if(wpsnr>=58)
        if(wpsnr<min)
            min=wpsnr;
            kfin=k;
            break;
        end
    end
    %k=k+1;
    if((((58-max)*1000))<5)
        k=k+5;
    else
        k=round(k+((58-max)*1000));
    end 
end 
if(kfin==0)
    k=maxk;
else
    k=kfin;
end

xx=1:50;
%plot(xx,ks);
%k=44870;
    for j = 1:nValues
        m = Ix(k);
        Itw_mod(m) = It_mod(m)*(1+alpha*w(j));
    %     Itw_mod(m) = It_mod(m)*exp(alpha*w(j));
        k = k+1;
     % k=round(k+(div/(k-1)));
%         if(j==1)
%             k=50000;
%         end
    end
% recover sign
    It_new = Itw_mod.*It_sgn;
    
    %watermark, from vector to matrix
    It_newi=reshape(It_new,dimx,dimy);
    %inverse dct
    I_inv = idct2(It_newi);

%imshow(I_inv,[]);
%figure(); imshow(I);

%save watermarked image
embeddedImage = uint8(I_inv);
 
%PSNR(uint8(I_inv),uint8(Id)) 
%wpsnr=WPSNR(uint8(I_inv),uint8(Id));

end

