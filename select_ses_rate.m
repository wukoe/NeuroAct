% to select sessions based on rate
%   [SR,I,selectNum]=select_rate(R,session)
function [SR,I,selectNum]=select_ses_rate(R,session)

[seAmt,chAmt]=size(R);
dAmt=length(session);

% Calculate average rate of only active channels
seR=zeros(seAmt,1); selectNum=seR;
for si=1:seAmt
    sr=R(si,:);
    [sr,I]=sort(sr,'descend');
    srcumsum=cumsum(sr);
    srcumsum=srcumsum/srcumsum(end); % normalize the cum sum
    % Find the place that cross the threshold
    [~,idx]=find(srcumsum>0.9,1);
    seR(si)=mean(sr(1:idx));
    selectNum(si)=idx;
end

SR=zeros(dAmt,1); I=SR;
for k=1:dAmt
    [SR(k),I(k)]=max(seR(session(k,1):session(k,2)));
end

selectNum=selectNum(session(:,1)+I-1);

end