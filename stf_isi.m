% ST ISI feature 
%   F=stf_isi(ST,method,varargin)
% method including: 'CV' -coefficient of variance, 'LCV' -local CV, 
% 'KStest' -KS test
% for regularity.
% st as one channel
function F=stf_isi(ST,method,varargin)
chAmt=length(ST);
ISI=cell(chAmt,1);
for chi=1:chAmt
    ISI{chi}=diff(ST{chi});
end

switch method
    case 'CV'
        F=zeros(chAmt,1);
        for chi=1:chAmt
            F(chi)=std(ISI{chi})/mean(ISI{chi});
        end
        
    case 'LCV' % Local CV
        % local number
        locNum=varargin{1};
        locNumAmt=length(locNum);
        
        F=zeros(chAmt,locNumAmt);
        for ni=1:locNumAmt
            for chi=1:chAmt
                dlen=length(ISI{chi});
                rlen=dlen-locNum(ni)+1;
                lcv=zeros(rlen,1);
                for k=1:rlen
                    temp=ISI{chi}(k:k+locNum(ni)-1);
                    lcv(k)=std(temp)/mean(temp);
                end
                F(chi,ni)=mean(lcv); % <<< 
            end
        end
        
    case 'KStest'
        F=zeros(chAmt,1);
        for chi=1:chAmt
            if length(ISI{chi})<2
                F(chi)=0;
            else
            % to a single standard
            x=ISI{chi}-mean(ISI{chi});
            x=x/mean(ISI{chi});%std(x);
            [~,F(chi)]=kstest(x);
            end
        end
        
    otherwise
        error('invalid method name');
end

end