% connection info by transfer entropy
%   NC=nc_te(ST,varargin)
% 'bin',binSize(s): specify bin size. default: 0.01
function [NC]=nc_te(ST,varargin)
binSize=0.01; % (s)

%%% Process
if iscell(ST)
    % User input - only needed when data is ST form:
    if ~isempty(varargin)
        [pname,pinfo]=paramoption(varargin{:});
        % process the parameter options one by one
        for parai=1:length(pname)
            switch pname{parai}
                case 'bin'
                    binSize=pinfo{parai};
                otherwise
                    error('unidentified options');
            end
        end
    end

    BD=bincount(ST,binSize*1000);
    BD=(BD>0);

elseif isnumeric(ST)
    BD=ST;
    chAmt=size(BD,2);
    % Check the data 
    BD(BD<1)=0;
    BD(BD>=1)=1;
else
    error('invalid data form');
end

%%% Calculation
NC=zeros(chAmt);
for m=1:chAmt
    for n=1:chAmt
        % Calculate the MI
        NC(m,n)=te(BD(:,m),BD(:,n),1,1);            
    end
    fprintf('|');
end
fprintf('\n');

end