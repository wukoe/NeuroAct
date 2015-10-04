% Fano factor (windowed index of dispersion)
%   F=stf_ff(ST,timeInt,win,winstep)
function F=stf_ff(ST,timeInt,win,winstep)
% chAmt=length(ST);
% [segm,sega]=cutseg(timeInt,win,'common');

X=spkrate(ST,'count',[],'time',timeInt,'bin size',win,'bin step',winstep);

F=var(X)./mean(X);
F(isnan(F))=0;
F=F';

% I=(X>0);
% X=X(I);
% F=F/log(mean(X)+2);