function [detected,wpsnr] = detection(Iorig,I_inv,Iatt)
Iorig = imread(Iorig);
I_inv = imread(I_inv);
Iatt = imread(Iatt);
%DETECTIONSAVE Summary of this function goes here
%   Detailed explanation goes here
extracted_w = zeros(1,1024);
original_w=zeros(1,1024);
%Iatt = imsharpen(Iatt, 'Radius', 100, 'Amount', 100);
%Iatt=test_resize(Iatt, 0.23);
%rng(7); % Seed random generator
%Iatt = imnoise(uint8(Iatt),'gaussian',0, 0.04);
%Iatt = imgaussfilt(Iatt,2.2);
%imwrite(uint8(Iatt), 'SSatt.jpg', 'Quality', 8);
%Iatt = imread('SSatt.jpg');
%delete('SSatt.jpg');
%Iatt=test_blur(Iatt,8);
%Iatt=test_median(Iatt,6,6);
%Iatt=test_equalization(uint8(Iatt),2);
nValues=1024;
Itw_mod=abs(reshape(dct2(double(I_inv)),1,512*512));


It = dct2(double(Iorig));
It_re = reshape(It,1,512*512);


Itw2_mod=Itw_mod;

%Modulo and sign
It_sgn = sign(It_re);
It_mod = abs(It_re);

Iatt_re = dct2(double(Iatt));
Iatt_re = abs(reshape(Iatt_re,1,512*512));
[It_sort, Ix]=sort(It_mod,'descend');



alpha=5.5;
kfin=0;
min=100;
max=0;
k = 50000;

for f=1:30
    %k=49000+(5*f);
    Itw2_mod = It_mod; 
    h=k;
    for j = 1:nValues
        m = Ix(h);
        Itw2_mod(m) = It_mod(m)*(1+alpha-1);
    %     Itw_mod(m) = It_mod(m)*exp(alpha*w(j));
        h = h+1;
     % k=round(k+(div/(k-1)));
       
    end
    % recover sign
    It_new = Itw2_mod.*It_sgn;
    
    %watermark, from vector to matrix
    It_newi=reshape(It_new,512,512);
    %inverse dct
    I_inv2 = idct2(It_newi);
    wpsnr=WPSNR(uint8(I_inv2),uint8(Iorig));
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
%k=44870;
for j = 1:1024
    m = Ix(k);
    extracted_w(j) = (Iatt_re(m)/It_mod(m) - 1)/alpha;
    original_w(j) = (Itw_mod(m)/It_mod(m) - 1)/alpha;
%    Itw_mod(m) = It_mod(m)*(1+alpha*w(j));
   % k =round(k+(div/k));
   k=k+1;
%    if(j==1)
%         k=50000;
%     end
end

rng(7);
w_new=zeros(1000,1024);
for n = 1:49
    w_new(n,:) = round(rand(1,1024));
end
w_new(50,:) = original_w;
for n =51:1000
    w_new(n,:) = round(rand(1,1024));
end

sim=zeros(1,1000);
for n = 1:1000
    sim(n) = extracted_w.*w_new(n,:)/sqrt(extracted_w.*extracted_w);
end

%x = 1:1000;
%plot(x,sim); xlabel('Random watermarks'); ylabel('Watermark Detector Response');
wpsnr=WPSNR(uint8(I_inv),uint8(Iatt));

sorted=sort(sim,'descend');
%figure(); imshow(uint8(Iatt));
ss=sorted(2)*(1.1);
if(sorted(2)<0)
     ss=sorted(2)*(0.9);
end
if(sim(50)>ss)
    	%fprintf('true\n');
        detected=1;
else
    %fprintf('false\n');
    detected=0;
end


end

