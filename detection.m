function [detected,wpsnr] = detection(Iorig,I_wat,Iatt)

Iorig=imread(Iorig);
I_wat=imread(I_wat);
Iatt=imread(Iatt);

%preallocazione watermark estratti
nValues=1024;   %lunghezza watermark
extracted_w = zeros(1,nValues);
original_w=zeros(1,nValues);

%faccio DCT delle tre immagini
Itw_mod=abs(reshape(dct2(double(I_wat)),1,512*512));
It = dct2(double(Iorig));
It_re = reshape(It,1,512*512);
It_sgn = sign(It_re);
It_mod = abs(It_re);
Iatt_re = dct2(double(Iatt));
Iatt_re = abs(reshape(Iatt_re,1,512*512));
[It_sort, Ix]=sort(It_mod,'descend');
alpha=5.5;  %intensità DCT
markTresh=58;   %treshold punteggio

%funzione che cerca il valore k migliore
kfin=0;
min=100;
max=0;
k = 50000;
for f=1:30
    Itw2_mod = It_mod; 
    h=k;
    for j = 1:nValues
    	m = Ix(h);
        Itw2_mod(m) = It_mod(m)*(alpha);
        h = h+1;
    end
    It_new = Itw2_mod.*It_sgn;
    It_newi=reshape(It_new,512,512);
    I_inv2 = idct2(It_newi);
    wpsnr=WPSNR(uint8(I_inv2),uint8(Iorig));
    if(wpsnr>max)
        max=wpsnr;
        maxk=k;
    end
    if(wpsnr>=markTresh)
        if(wpsnr<min)
            kfin=k;
        	break;
        end
    end
    if((((markTresh-max)*1000))<5)
    	k=k+5;
    else
        k=round(k+((markTresh-max)*1000));
    end 
    if(k>262144)
       break; 
    end
end 
if(kfin==0)
    k=maxk;
else
    k=kfin;
end

%estraggo watermark originale e da immagine attaccata
for j = 1:1024
    m = Ix(k);
    extracted_w(j) = (Iatt_re(m)/It_mod(m) - 1)/alpha;
    original_w(j) = (Itw_mod(m)/It_mod(m) - 1)/alpha;
	k=k+1;
end

%creo watermark casuali
rng(7);
w_new=zeros(1000,1024);
for n = 1:49
    w_new(n,:) = round(rand(1,1024));
end
w_new(50,:) = original_w;
for n =51:1000
    w_new(n,:) = round(rand(1,1024));
end

%calcolo similarità tra watermark attaccato e watermark casuali e originale
sim=zeros(1,1000);
for n = 1:1000
    sim(n) = extracted_w.*w_new(n,:)/sqrt(extracted_w.*extracted_w);
end

%calcolo treshold e controllo se il watermark è stato rilevato
wpsnr=WPSNR(uint8(I_wat),uint8(Iatt));
sorted=sort(sim,'descend');
ss=sorted(2)*(1.1);
if(sorted(2)<0)
	ss=sorted(2)*(0.9);
end

%restituisce se il watermark è stato rilevato
if(sim(50)>=ss)
	detected=1;
else
	detected=0;
end

end

