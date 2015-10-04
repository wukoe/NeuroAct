% spike-aligned other spikes
%   WS=spka_spk(ST,nidx)
%   spka_spk(ST,nidx,'close',1) only output the closest (pre and post)
%   spikes of other neurons to nidx; 
%   spka_spk(ST,nidx,'window',[l,h]) specify the time window. [l,h] in (s)
function WS=spka_spk(ST,nidx,varargin)
% Default
win=[-0.005,0.005]; %(s)
nAmt=length(ST);
sAmt=length(ST{nidx});

bOnlyClose=false; % whether only record the spikes closest to it (pre and post)
bPlot=true;

% User input
if ~isempty(varargin)
    [pname,pinfo]=paramoption(varargin{:});
    % process the parameter options one by one
    for parai=1:length(pname)
        switch pname{parai}
            case 'window'
                win=pinfo{parai};                
            case 'close'
                if pinfo{parai}==1
                    bOnlyClose=true;
                end
            case 'plot'
                if strcmp(pinfo{parai},'off') || pinfo{parai}==0
                    bPlot=false;
                end
            otherwise
                error('unidentified options');
        end
    end
end


%%%%%%%%%%
% init output
WS=cell(nAmt,1);

A=eventa_spk(ST{nidx},ST,win); % now A is {nAmt * sAmt} form
%%% If only choose the closest spike
if bOnlyClose
    for ni=1:nAmt
        WS{ni}=zeros(0,1);
        for si=1:sAmt
            % spike time re-referenced to spikes of nidx.
            rt=A{ni,si}-ST{nidx}(si);
            % the prewin part
            tp=rt(rt<0);
            tp=max(tp);
            WS{ni}=[WS{ni}; tp];
            % the postwin part
            tp=rt(rt>0);
            tp=min(tp);
            WS{ni}=[WS{ni}; tp];
            % if right at same time
            tp=rt(rt==0);            
            WS{ni}=[WS{ni}; tp];
        end
    end
    
%%% If choose the all spikes
else
    for ni=1:nAmt
        WS{ni}=zeros(0,1);
        for si=1:sAmt
            % spike time re-referenced to spikes of nidx.
            rt=A{ni,si}-ST{nidx}(si);
            % put together in one 
            WS{ni}=[WS{ni}; rt];
        end
    end
end
    
    
%%%%%%%%% Draw
if bPlot
    cla;
    hold on
    % The main sync line
    plot([0,0],[0,nAmt+1],'r');

    % The individual spikes
    for ni=1:nAmt
        I=WS{ni}';
        % transfer into time based on sampling rate
        spikeNum=length(I);
        % use chi as draw height of each neuron
        if ni==nidx
            plot([I;I],[ni+zeros(1,spikeNum);ni+ones(1,spikeNum)],'r');
        else
            plot([I;I],[ni+zeros(1,spikeNum);ni+ones(1,spikeNum)],'b');
        end
    end

    axis([win(1),win(2),-1,nAmt+2]);
    hold off
end