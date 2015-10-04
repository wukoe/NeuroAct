% spk train feature - total spike number count
%   cn=stf_count(SD)
%   [cn,rate]=stf_count(SD,timeLen); gets full length of time timeLen
% rate is average rate of whole time axis (/sec)
function [cn,varargout]=stf_count(SD,varargin)

if ~iscell(SD)  % when it is the content of one channel (content of cell) 
    SD={SD};
end
cha=length(SD);
cn=zeros(1,cha);
for k=1:cha
    cn(k)=length(SD{k});
end
   
%%%
if nargout==2 % If need the rate information 
    if isempty(varargin) % check whether there is time information, when NOT:
        % if it is index format, use the max and min spike time of all
        % neurons as the range of time.
        temp=[min(cellstat(SD,'min')),max(cellstat(SD,'max'))];
        timeLen=temp(2)-temp(1);

    else % Else if there is time info.
        timeLen=varargin{1}; % it is now measured in (s)
    end
    bRate=true;
else
    bRate=false;
end

%%%
if bRate    
    varargout{1}=cn/timeLen;
end

