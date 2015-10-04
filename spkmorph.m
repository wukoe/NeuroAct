% detect the spike amplitude and width and other morphology
%   res=spkmorph(x,srange)
function res=spkmorph(x,srange)
dlen=length(x);

smean=mean(x);
[smax,idxmax]=max(x); [smin,idxmin]=min(x);
posmax=smax-smean; % +
negmax=smin-smean; % -

if posmax>-negmax
    bPos=true;
    amp=posmax;
    idxpeak=idxmax;
else
    bPos=false;
    amp=negmax;
    idxpeak=idxmin;
end

%%% The peak width
% % 1/N: as segment around peak that are above the mean.
% if bPos
%     I=(x>smean);
% else
%     I=(x<smean);
% end
% 
% 
% I=~I;
% % Search for the start
% for k=idxpeak:-1:1
%     if I(k), break; end
% end
% startpos=k;
% % Search for the end
% for k=idxpeak:dlen
%     if I(k), break; end
% end
% stoppos=k;
% 
% wid=stoppos-startpos;

% 2/N: as the distance between negative peak and the smaller positive follows
x=smovavg(x,5,5);
tp=beinrange(idxpeak+srange,dlen,'high');
if bPos
    [~,wid]=min(x(idxpeak:tp));
else
    [~,wid]=max(x(idxpeak:tp));
end

res=struct('amp',amp,'wid',wid,'startpos',idxpeak,'stoppos',idxpeak+wid);
