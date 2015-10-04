% spike trains distance by cost - maily spike indels and moving 
% (Victor-Purpura methord)

function SD=stdist_cost(x1,x2)

% cost of insertion or deletion
costSPIndel=1;
% cost of moving spike along time (1/ms)
costMov=1/5;

% SD=cost
SD=0;
spos1=find(x1);
sa1=length(spos1);
spos2=find(x2);
sa2=length(spos2);
% paradigm: x1 spikes compare to x2 spikes
for si=1:sa1
    % find the nearest x2 spike for si of x1
    [nd,idx]=min(abs(spos2-spos1(si)));
    % calculate the cost of moving the spike to that position
    nd=nd*costMov;
    
    %??? big question: can two spikes in A move to same position in B?
    if nd>costSPIndel*2
        % less cost to do indels, then adopt this method
        SD=SD+costSPIndel*2;% delete and create - so *2
    else
        % less cost to move, then move this one
        SD=SD+nd;
    end
    
    % add the rest that need to be inserted or deleted
    SD=SD+abs(sa1-sa2);
end