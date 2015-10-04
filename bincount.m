% To bin the SD into new bins, sum the firing of SD in each new bin.
%   BD=bincount(ST)
%   ...bincount(ST,bin,step) specify bin and step in (ms), step for
% overlapping bins. default bin = 2.5ms
%   [BD,T]=bincount() gives the time at center of each bin.
function [BD,T]=bincount(ST,varargin)
bin=2.5; %(ms)
% isWinSpecified=true; %%%%%%%%

if nargin>=2
    bin=varargin{1};
end
if nargin==3
    step=varargin{2};
    bOverlap=true;
else
    bOverlap=false;
end

bin=bin/1000;
if bOverlap, step=step/1000; end
cha=length(ST);

% Range of time
temp=cellstat(ST,'min');
win(1)=min(temp);
temp=cellstat(ST,'max');
win(2)=max(temp);

%%%
% Determine bins
if bOverlap
    [segm,sega]=cutseg(win,bin,step,'common','equal');
else
    [segm,sega]=cutseg(win,bin,'common','equal');
end

% Transfer SD to bin data
BD=zeros(sega,cha);
parfor chi=1:cha
    [~,BD(:,chi)]=binid(ST{chi},segm);    
end
T=mean(segm,2);