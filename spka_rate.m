% spike-aligned other neurons' relative spike rate to the align reference
%   [R,T]=spka_rate(ST,nidx)
% R: [bin * neuron];  T: centers of bins.
function [R,T]=spka_rate(ST,nidx,varargin)
% Default
win=[-0.1,0.1];
bPlot=true;

% User input
if ~isempty(varargin)
    [pname,pinfo]=paramoption(varargin{:});
    % process the parameter options one by one
    for parai=1:length(pname)
        switch pname{parai}
            case 'window'
                win=pinfo{parai};
            case 'chID'
                chID=pinfo{parai};
            case 'plot'
                if pinfo{parai}==0 || strcmp(pinfo{parai},'off')
                    bPlot=false;
                end
            otherwise
                error('unidentified options');
        end
    end
end

% Data info
nAmt=length(ST);

%%%%%%%%%%%%
WS=spka_spk(ST,nidx,'window',win,'plot',0);

bin=(win(2)-win(1))/20;
[R,T]=spkrate(WS,'time',win,'bin size',bin);
R=R/length(ST{nidx}); % need to normalize by the number of spikes of neuron #nidx.

% % Remove the the number itself 
% sega=length(T);
% tp=ceil(sega/2);
% tp=[tp-1:tp+1];
% R(tp,nidx)=0;

%%%%%%%%%%%%
if bPlot
    Y=1:nAmt;
    imagesc(T,Y,R');
    hold on
    plot([0,0],[0,nAmt+1],'r');

    if exist('chID','var')
        title(sprintf('firing rate aligned to neuron #%d - ch#%d (/s)',nidx,chID(nidx)));
    else
        title(sprintf('firing rate aligned to neuron #%d (/s)',nidx));
    end
    xlabel('(s)');
    ylabel('neuron');
    colorbar
    hold off
end