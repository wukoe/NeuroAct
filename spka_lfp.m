% spike-aligned LFP - just the instant LFP amplitude, not any features of
% LFP.
%   WX=spka_lfp(ST,fnX,nidx,neuCh)
function [WX,varargout]=spka_lfp(ST,fnX,varargin)
% Default
win=[-100,300]; %(ms)

if ~exist(fnX,'file')
    error('can not find X file');
else
    fid=matfile(fnX);
end
T=fid.T; 

%%% Process
win=round(win/1000*fid.srate);
winLen=win(2)-win(1)+1;
nAmt=length(ST);
[ptsAmt,chAmt]=size(fid,'X');

WX=zeros(chAmt,winLen,nAmt);
for ni=1:nAmt    
    % Find the closes time point
    spkp=closest(ST{ni},T);
    I=(spkp+win(1)<1); spkp(I)=[]; 
    I=(spkp+win(2)>ptsAmt); spkp(I)=[];
    sAmt=length(spkp);
    
    % Cut the window around each spiking
    temp=zeros(sAmt,winLen);
    for chi=1:chAmt
        X=fid.X(:,chi);
        for si=1:sAmt        
            temp(si,:)=X(spkp(si)+win(1):spkp(si)+win(2));
        end        
        WX(chi,:,ni)=mean(temp);
    end
    fprintf('|');
end
fprintf('\n');

%%%
if nargout==2
    varargout{1}=win;
end