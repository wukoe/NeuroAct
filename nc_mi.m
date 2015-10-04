% mutual information
% without any shift of the 2 series in comparison.
function [NC,varargout]=nc_mi(BD,varargin)

bShift=false;

% User input
if ~isempty(varargin)
    [pname,pinfo]=paramoption(varargin{:});
    % process the parameter options one by one
    for parai=1:length(pname)
        switch pname{parai}
            case 'shift' % whether to use shift to find the optimal 
                bShift=true;
                shiftTime=pinfo{parai}; % (s)            
            otherwise
                error('unidentified options');
        end
    end
end


%%% Process
[bAmt,chAmt]=size(BD);

% Transfer to number of bins to shift
if bShift
    shiftTime=round(shiftTime/binSize);
    if shiftTime>20 % warning message for long input
        fprintf('in total %d shifts needed!\n',shiftTime+1);
    end
end


%%% Calculation
% firing probability of each channel respectively
P=sum(BD)/bAmt; 

NC=zeros(chAmt);
if bShift % When the shift is needed    
    res=zeros(shiftTime+1,1);
    L=zeros(chAmt); % lagging information
    
    %%% Each pair of channels
    % * method: shift the second to behind, after the whole matrix is done,
    % compare the transposing elements to selecte the larger one.
    for m=1:chAmt
        for n=1:chAmt
            % Individual firing probatbilities
            p1=[P(m);1-P(m)];
            p2=[P(n);1-P(n)];            
            
            for st=1:shiftTime+1
                % Joint firing prob
                pj=zeros(2);
                nr=1:bAmt-st+1;
                pj(1,1)=sum(BD(st:end,m)&BD(nr,n))/bAmt;
                pj(2,1)=sum(BD(st:end,m)&~BD(nr,n))/bAmt;
                pj(1,2)=sum(~BD(st:end,m)&BD(nr,n))/bAmt;
                pj(2,2)=sum(~BD(st:end,m)&~BD(nr,n))/bAmt;

                % Calculate the MI
                res(st)=mi(p1,p2,pj);
            end
            
            % Fill in the max information position
            [NC(m,n),idx]=max(res);
            L(m,n)=idx-1;
        end
    end
    
    %%% Compare the transposed elements
    for m=1:chAmt-1
        for n=m+1:chAmt
            if NC(m,n)>NC(n,m)
                NC(n,m)=NC(m,n);
                L(n,m)=-L(m,n);
            else
                NC(m,n)=NC(n,m);
                L(m,n)=-L(n,m);
            end
        end
    end
    
else
    for m=1:chAmt
        for n=m:chAmt
            % Individual firing probatbilities
            p1=[P(m);1-P(m)];
            p2=[P(n);1-P(n)];

            % Joint firing prob
            pj=zeros(2);
            pj(1,1)=sum(BD(:,m)&BD(:,n))/bAmt;
            pj(2,1)=sum(BD(:,m)&~BD(:,n))/bAmt;
            pj(1,2)=sum(~BD(:,m)&BD(:,n))/bAmt;
            pj(2,2)=sum(~BD(:,m)&~BD(:,n))/bAmt;

            % Calculate the MI
            NC(m,n)=mi(p1,p2,pj);            
        end
    end
    
    %%% Copy to the lower triangle of connectivity matrix
    NC=NC+(rmdiag(NC))';
end

if bShift
    varargout{1}=L;
end

end