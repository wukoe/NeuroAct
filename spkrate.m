% spk train windowed sequential spiking rate
%   R=spkrate(ST)   ST: time index format; R: rate change (/sec)
%   R=spkrate(ST,'time',time,'bin size',binSize)  time:[start,end] of segment of time axis (s)
% and  specify the bin size (s). default: 0.2s, overlapping bins
%   NC=spkrate(ST,'count',[]) 
% output spike count in each window instead of rate.
%   [R,C]=spkrate()   can output the time of center of each bin.
function [R,varargout]=spkrate(SD,varargin)
% default
bin=0.2; % (s)
bTimeInput=false;
bCount=false;
binstep=1/2;
bBSinput=false;

% input
if ~isempty(varargin)
    [pname,pinfo]=paramoption(varargin{:});
    % process the parameter options one by one
    for parai=1:length(pname)
        switch pname{parai}
            case 'count'
                bCount=true;
            case 'time'
                time=pinfo{parai};
                bTimeInput=true;
            case 'bin size'
                bin=pinfo{parai};
            case 'bin step'
                binstep=pinfo{parai};
                bBSinput=true;
            otherwise
                error('unidentified options');
        end
    end
end

%%% Process
cha=length(SD);
% Use data max and min as time if not specified.
if ~bTimeInput
    %%% If segment for analysis is NOT specified, the start and end time is set at the range of data.    
    % get the first and last spike time of each channel
    time=[min(cellstat(SD,'min')),max(cellstat(SD,'max'))];
end
if ~bBSinput, binstep=bin*binstep; end

%%% Cut into bins - note that the bins are 50% overlapping each other.
[segm,sega]=cutseg(time,bin,binstep,'common'); 
segSearchRange=floor(bin/binstep); % only work backward time
R=zeros(sega,cha);
for chi=1:cha
    spka=length(SD{chi});
    % * two methods for speeding up. When spk number > seg num, compare spk
    % time to bin edge to decide; When opposite, get bin ID of spk by
    % dividing the step length to each.
    if spka>sega
        for si=1:sega
            I = (SD{chi}>segm(si,1)) & (SD{chi}<=segm(si,2));
            R(si,chi)=sum(I);
        end
    else
        % Locate to "step bins" defined by step interval        
        A=ceil((SD{chi}-time(1))/binstep);
%         A(A>sega)=sega;
        
        % Add to bins in search range backward time
        for si=1:spka
            tp= max(A(si)-segSearchRange,1) : A(si) ;
            I=(tp<=sega); tp=tp(I);            
            I=(SD{chi}(si)<=segm(tp,2));
            R(tp(I),chi)=R(tp(I),chi)+1;
        end
    end
end

% Transform to (/sec)
if ~bCount
    R=R/bin;
%     % special for last bin (different bin size possible)
%     bin=segm(sega,2)-segm(sega,1);
%     R(sega,:)=R(sega,:)/bin;
end

% 
if nargout==2
    varargout{1}=segm;
end

end