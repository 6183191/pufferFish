function embeddedImage = embedding(original)

%legge immagine
I    = imread(original);
[dimx,dimy] = size(I);
Id   = double(I);

%legge watermark
nValues=1024;   %lunghezza watermark
w = open("pufferfish.mat");
w = w.w;
w = reshape(w, 1, nValues);

%converte immagine in DCT
alpha = 5.5;    %intensità DCT
markTresh=58;   %treshold punteggio
It = dct2(Id);
It_re = reshape(It,1,dimx*dimy);
It_sgn = sign(It_re);
It_mod = abs(It_re);
[It_sort,Ix] = sort(It_mod,'descend');
Itw_mod = It_mod;

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
    It_newi=reshape(It_new,dimx,dimy);
    I_inv2 = idct2(It_newi);
    wpsnr=WPSNR(uint8(I_inv2),uint8(Id));
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

%applicazione watermark
for j = 1:nValues
   	m = Ix(k);
    Itw_mod(m) = It_mod(m)*(1+alpha*w(j));
    k = k+1;
end
It_new = Itw_mod.*It_sgn;
It_newi=reshape(It_new,dimx,dimy);
I_inv = idct2(It_newi);

%salvo immagine
embeddedImage = uint8(I_inv);
[p,n,e]=fileparts(original);
nf=fullfile(n+"_pufferfish"+e);
imwrite(embeddedImage,nf);

%calcolo wpsnr (solo debug)
wpsnr=WPSNR(embeddedImage,I);

end

