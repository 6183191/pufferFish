function [ss] = threshold(original_w)


nValues=1024;
%creo watermark casuali
w = open("pufferfish.mat");
w = w.w;
w = reshape(w, 1, nValues);
rng(now);
w_new=zeros(1000,1024);
w_new(1,:) = w;
for n =2:1000
    w_new(n,:) = round(rand(1,1024));
end

%calcolo similarità tra watermark attaccato e watermark casuali e originale
sim=zeros(1,1000);
for n = 1:1000
    sim(n) = original_w.*w_new(n,:)/sqrt(original_w.*original_w);
end

sorted=sort(sim,'descend');
ss=sorted(2)*(1.1);
if(sorted(2)<0)
	ss=sorted(2)*(0.9);
end


end

