% Get the analytic signal property (amp & ang) at each spike time.
function [ampH,angH]=spka_lfpansig(ST,X,T,srate,varargin)
% Parameter
freq=[4,10,18,26,40,80,160];
ampBinNum=20;
angBinNum=20;
bOnlySelf=true;

frqAmt=length(freq);
STchAmt=length(ST);
[ptsAmt,XchAmt]=size(X);
freq=freq/srate*2; % relative frequency

%%% Get the analytic signal
xamp=zeros(frqAmt,ptsAmt,XchAmt);
xang=xamp;
for chi=1:XchAmt
%     chi=chI(k);
    [xamp(:,:,chi),xang(:,:,chi)]=ansig(X(:,chi),2,freq);
    fprintf('|');
end
fprintf('\n');

%%% Get the index of the analytic values corresponding to spike timing.
ST=time2idx(ST,T);

%%% Align the samp and sang to the timing of spikes, average to rate at
% specific analytic values.
ampH=cell(STchAmt,1);
angH=ampH;
for chi=1:STchAmt
    %%% Amplitude
    if bOnlySelf
        ampH{chi}=zeros(ampBinNum,frqAmt);
        angH{chi}=zeros(ampBinNum,frqAmt);
    else
        ampH{chi}=zeros(ampBinNum,frqAmt,XchAmt);
        angH{chi}=zeros(ampBinNum,frqAmt,XchAmt);
    end
    samp=xamp(:,ST{chi},:);
    sang=xang(:,ST{chi},:);
    if bOnlySelf
        for fi=1:frqAmt            
            ampH{chi}(:,fi)=hist(samp(fi,:,chi),ampBinNum);
            angH{chi}(:,fi)=hist(sang(fi,:,chi),angBinNum); 
        end
    else
        for fi=1:frqAmt
            for k=1:XchAmt
                ampH{chi}(:,fi,k)=hist(samp(fi,:,k),ampBinNum);
                angH{chi}(:,fi,k)=hist(sang(fi,:,k),angBinNum); % <<<
            end
        end
    end
       
    fprintf('|');
end
fprintf('\n');