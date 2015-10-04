function [NC]=nc_kld(ST,varargin)
cha=length(ST);
NC=zeros(cha);
for m=1:chAmt
    for n=1:chAmt
        p1=[P(m);1-P(m)];
        p2=[P(n);1-P(n)];
        NC(m,n)=kld(p1,p2);
    end
end
NC=1-NC;