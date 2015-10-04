% 这是为了将一个时间序列转换成多个并列的时间序列，并且在时序进行逐次错位。
% 目的用于Ising model中的多历史时间点的引入。 直接用于nc_mtising.
% Y=multi_time_disloc(X,locAmt)
% if locAmt=0, Y=X.
function Y=multi_time_disloc(X,locAmt)
[pts,cha]=size(X);

newpts=pts-locAmt;
locAmt=locAmt+1;
Y=zeros(newpts,cha*locAmt);
for loci=1:locAmt
    Y(:,(0:cha-1)*locAmt+loci)=X(loci:pts-locAmt+loci,:); % move backward in time
end