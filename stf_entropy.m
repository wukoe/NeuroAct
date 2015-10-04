%   E=stf_entropy(ST,method)
% method can be: 'isi','srv'
function E=stf_entropy(ST,method,varargin)
binAmt=100;
bAutoBin=true;
if ~isempty(varargin)
    [pname,pinfo]=paramoption(varargin{:});
    % process the parameter options one by one
    for parai=1:length(pname)
        switch pname{parai}
            case 'bin'
                bin=pinfo{parai};
                bAutoBin=false;
            case 'time'
                time=pinfo{parai};
            otherwise
                error('unidentified options');
        end
    end
end

chAmt=length(ST);

%%%
if strcmp(method,'isi')
    ISI=cell(chAmt,1);
    for chi=1:chAmt
        ISI{chi}=diff(ST{chi});
    end
    
    % all channel use the same bin
    if bAutoBin
        % <<< exclude the low activity channels before calculating max ISI.
        intmin=cellstat(ISI,'min');
        intmax=cellstat(ISI,'max');
        bin=linspace(min(intmin),max(intmax),binAmt+1)';
        bin=[bin(1:binAmt),bin(2:binAmt+1)];
    end    
    
    E=zeros(chAmt,1);
    for chi=1:chAmt
        [~,ba]=binid(ISI{chi},bin);
        p=ba/length(ISI{chi});
        % calculate entropy
        temp=-log(p.^p);
        E(chi)=sum(temp);
    end
    
elseif strcmp(method,'srv') % spike rate variance
    if ~exist('time','var')
        sr=spkrate(ST);
    else
        sr=spkrate(ST,'time',time);
    end
    timebinamt=size(sr,1);
    
    % all channel use the same bin
    if bAutoBin
        srmax=matmax(sr);
        bin=linspace(0,srmax,binAmt+1)';
        bin=[bin(1:binAmt),bin(2:binAmt+1)];
    end
    
    E=zeros(chAmt,1);
    for chi=1:chAmt
        [~,ba]=binid(sr(chi,:),bin);
        p=ba/timebinamt;
        % calculate entropy
        temp=-log(p.^p);
        E(chi)=sum(temp);
    end
end
%<<< how channels with 0 spike give >0 entropy in srv method?
end