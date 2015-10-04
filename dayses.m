% day-session plot of data - data that contain groups (days), each with
% several individuals (sessions). Plot each group as one position in
% x-axis, different ways to show individuals according to user option
%   dayses(X,sessions,'days',dayinfo)
function varargout=dayses(X,sessions,varargin)
option='ind';

flagDayInfo=false;
if ~isempty(varargin)
    [pname,pinfo]=paramoption(varargin{:});
    % process the parameter options one by one
    for parai=1:length(pname)
        switch pname{parai}
            case 'days'
                days=pinfo{parai};
                flagDayInfo=true;
            otherwise
                error('unidentified options');
        end
    end
end

sAmt=length(X);
dAmt=size(sessions,1);

% if exist session list item larger than total number of data individuals,
if sum(sessions(:,2)>sAmt)>0
    error('session number wrong');
end

if ~exist('days','var')
    days=1:dAmt;
end

%%%
xd=zeros(dAmt,1);
for k=1:dAmt
    xd(sessions(k,1):sessions(k,2))=days(k);
end

%
if strcmp(option,'ind');
    plot(xd,X,'.');
end
if flagDayInfo
    xlabel('days');
end

end