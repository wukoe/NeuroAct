% Detect of burstlets (aggregated events in individual channel)
%   [BI,BT,BA]=burstlet(st)
%   ...=burstlet(st,srate)
% output: spike index of burstlet, bl time interval, bl amplitude.
% burst amplitude is measured by spike rate (num/sec)
% parameters:
% 'interval ratio'
% 'max interval'
% 'spike number'
% 'extend'
% 'extend interval ratio'
% 'max extend interval'
% * Based on SIMMUX algorithm [An extremely rich repertoire of bursting patterns 
% during the development of cortical cultures, 2006]
function [BI,varargout]=burstlet(st,varargin)
%%% Setting
ratioThres=1/4; % ratio to inverse of average spike rate.
intThres=0.006; %0.1%(s)
spkNumThres=4; % at least 4 spikes in a roll with interval less than threshold.
% for extended region of burstlet
bAddExt=false;%true;
extRatioThres=1/3;
extIntThres=0.012;%0.2;

%%% User input
bAutoSrate=true;
if ~isempty(varargin)
    [pname,pinfo]=paramoption(varargin{:});
    % process the parameter options one by one
    for parai=1:length(pname)
        switch pname{parai}
            case 'srate'
                srate=pinfo{parai};
                bAutoSrate=0;
            case 'interval ratio'
                ratioThres=pinfo{parai};
            case 'max interval'
                intThres=pinfo{parai};
            case 'spike number'
                spkNumThres=pinfo{parai};
            case 'extend'
                bAddExt=pinfo{parai};
            case 'extend interval ratio'
                extRatioThres=pinfo{parai};
            case 'max extend interval'
                extIntThres=pinfo{parai};
            otherwise
                error('unidentified options');
        end
    end
end

%%% Process
if size(st,1)==1, st=st'; end
sAmt=length(st);

if sAmt<spkNumThres
    BI=[]; varargout{1}=[]; varargout{2}=[];
    return;
end

% Unless the average spike rate of this channel is specified, calculate the
% average rate by the 1st & last spike time.
if bAutoSrate
    srate=sAmt/(st(end)-st(1));
end

% Determine threshold
intThres=min(intThres,1/srate*ratioThres);
extIntThres=min(extIntThres,1/srate*extRatioThres);


%%%%%%%%%%%%%%%%
%%% Find core burstlets
% Mark all <threshold interval clusters
D=diff(st);
seg=continuous_segment(D<intThres);

% Find spike cluster(segments) with spike number above threshold
I=(diff(seg,[],2)>=spkNumThres-2);

BI=seg(I,:);
BI(:,2)=BI(:,2)+1;

%%% Extend the burstlet range 
%<<< 疑问：到底是200ms以内的spike还是可以200-200这样一直延伸下去？
% - currently it stretch on.
if bAddExt
    ba=size(BI,1);
    for bi=1:ba
        % Extend to past
        if BI(bi,1)>1
            for k=BI(bi,1)-1:-1:1
                if D(k)>=extIntThres, break; end
            end
            % 
            BI(bi,1)=k+1;
        end
        
        % Extend to future
        if BI(bi,2)<ba
            for k=BI(bi,2):sAmt-1
                if D(k)>=extIntThres, break; end
            end
            %
            BI(bi,2)=k;
        end
    end
end

%%% Transform BI to time if needed
if nargout>=2    
    varargout{1}=[st(BI(:,1)),st(BI(:,2))];
end

%%% Get burst amplitude
if nargout==3    
    spknum=diff(BI,[],2)+1;
    burstlen=diff(varargout{1},[],2);
    varargout{2}=spknum./burstlen;
end

end


%%%%%% Obsolete
% %%% Detect "in a roll" - by this Finite State Machine.
% D=(D<intThres);
% spkNumThres=spkNumThres-1; % from spike number to interval number
% BI=zeros(0,2); % output burst start/end as index in spike train.
% burstCount=1;
% 
% Cstat=0;
% burstStart=1;
% for si=1:sAmt-1
%     if D(si)
%         if Cstat==0 % means start of a new burst
%             burstStart=si;
%         end
%         Cstat=Cstat+1;
%     else           
%         if Cstat>=spkNumThres % means reach end of small-interval series. number threshold, mark this as a burst
%             % write to the burst list
%             BI(burstCount,:)=[burstStart,si]; % end location is actually si-1+1
%             burstCount=burstCount+1;            
%         % Else it is between bursts, do nothing.
%         end
%         
%         % Back to 0 state
%         Cstat=0;
%     end            
% end
% % Check whether the series is in high state on exit. If do, add to list.
% if Cstat>=spkNumThres
%     BI(burstCount,:)=[burstStart,si+1];
% end