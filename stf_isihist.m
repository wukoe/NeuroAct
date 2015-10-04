% spk train feature - ISI histogram SD is a single channel data
%   D=stf_isihist(ST) 
% ST in time format, D is average rate in /sec
%   D=stf_count(ST,'plot')  shows the figure
%   (ST,bn) uses specified bin number.
function D=stf_isihist(SDT,varargin)
bPlot=false;
bn=20;

%%% User input
nvarargin=length(varargin);
for ni=1:nvarargin
    if ischar(varargin{ni})
        if strcmp(varargin{ni},'plot')
            bPlot=true;
        end
    elseif isnumeric(varargin{ni}) % specify the number of bins
        bn=varargin{ni};
    else
        error('invalid input type');
    end
end

%%% 
ISI=diff(SDT);

% remove certain too large ones
I=(ISI>=6);
ISI(I)=[];

% ISI=log(ISI);

D=hist(ISI,bn);
if bPlot
    hist(ISI,bn);
end

