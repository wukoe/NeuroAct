% statistics of individual spike waves
% each column as one spike
function [S,G]=spkstat(spkData,method)
sa=size(spkData,2);

S=zeros(sa,1);
G=false(sa,1);
for k=1:sa
    x=spkData(:,k);
    % 1/2
    % base=mean([x(1:50);x(250:300)]);

    % 2/2
    x=x(51:200);
    % 1/3
    % base=mean(x);
    % 2/3
    % base=mean(topk(x,5,'min'));
    % 3/3
    base=min(x);
    % e/3
    % e/2

    x=x-base;
    x=abs(x);

    if method==0 || method==1
        x=sort(x);
        if method==1
            N=round(length(x)/5);
            x=[x(1:N);x(end-N+1:end)];
        end
        S(k)=ginicoef(x);

        if S(k)>0.42
            G(k)=true;
        end

    elseif method==2
        x=x.^2;
        x=sort(x);
        x=[x(1:N);x(end-N+1:end)];
        S(k)=ginicoef(x);
        if S(k)>0.56
            G(k)=true;
        end
    end
end
