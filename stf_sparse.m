% sparseness of spike trains - time sparseness temporally
%   [S,paNum]=stf_sparse(ST,winsize)  winsize in (s)
function [S,paNum,paCount]=stf_sparse(ST,winsize)
chAmt=length(ST);
spikeCount=spkrate(ST,'count',1,'bin size', winsize);
B=spikeCount>0;
binAmt=size(B,1); % <<<

%%% Find all patterns of data
paList=B(1,:); % the first pattern
paCount=1; % pattern count
paNum=1; % pattern number
for bi=2:binAmt
    tp=B(bi,:); % pattern of all channels
    flagInList=false;
    for k=1:paNum
        if tp==paList(k,:)
            flagInList=true;
            paCount(k)=paCount(k)+1;
            break
        end
    end
    
    if ~flagInList
        paList=[paList; tp];
        paCount=[paCount; 1];
        paNum=paNum+1;
    end
end

%%% Analyze each pattern
% Get number of '1' in each pattern
S=zeros(paNum,1);
for k=1:paNum
    S(k)=sum(paList(k,:));
end
% Transform to ratio of whole pattern length.
S=S/chAmt;
S=mean(S);

paCount=paCount/binAmt;

end