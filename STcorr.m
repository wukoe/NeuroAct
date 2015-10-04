% Processing for the GLM of network.
% 1. Get permutated xcorr of data
repnum=20;
corrRange=50; %(bin)

sAmt=cellstat(NSD,'length');
thr=info.TimeSpan*0.2;
I=(sAmt>=thr);
NSD=NSD(I);
sAmt=sAmt(I);
NSTchID=chinfo.CluchID(I);

cLen=corrRange*2+1;
lag=-corrRange:corrRange;
SL=idx2logic(NSD,info.ptsAmt,20);
[sdlen,cha]=size(SL);

% % Smooth the curve?
% tc=50; % time constant (ms)
% D=stconv(ST,drate,tc); %for exponential template

save I9123_01cx NSD NSTchID SL info lag

%%
% Calc CX
CX=zeros(cLen,cha,cha);
for m=1:cha
    parfor n=m:cha
        % cross-corr of data
        CX(:,m,n)=crosscorr(SL(:,m),SL(:,n),corrRange);
        
        % permutation
        Perm=zeros(cLen,repnum);
        for k=1:repnum
            I=randperm(sdlen);
            Y=SL(I,n);
            Perm(:,k)=crosscorr(SL(:,m),Y,corrRange);
        end
        
        CX(:,m,n)=CX(:,m,n)-mean(Perm,2);
    end
    fprintf('|');
end
fprintf('\n');

%% Fill the bottom triangle.
for m=2:cha
    for n=1:m-1
        tp=CX(:,n,m);
        CX(:,m,n)=tp(end:-1:1);
    end
end

save I9123_01cx -append CX

% %%
% winsize=10;
% rg=corrRange+1-winsize:corrRange+1+winsize;
% auc=zeros(cha);
% pk=zeros(cha);
% for m=1:cha-1
%     for n=m+1:cha
%         cx=squeeze(CX(:,m,n));
%         auc(m,n)=sum(abs(cx(rg)));
%         pk(m,n)=max(abs(cx(rg)));
%     end
% end