% use lagged correlation coefficient to infer the connectivity
%   [NC,L]=nc_corr(CX)
% L(m,n)>0 means m is leading n (depend on how CX is calculated), vice
% verse.
function [NC,L]=nc_corr(CX,varargin)
% parameters
if isempty(varargin)
    maxdelay=20;
else
    maxdelay=varargin{1};
end

dlen=size(CX,1);
cha=size(CX,2);
corrRange=(dlen-1)/2;

%
NC=zeros(cha);
L=zeros(cha);
for m=1:cha-1
    for n=m+1:cha
        cd=CX(:,m,n);
        [~,idx]=max(abs(cd));
        NC(m,n)=cd(idx);
        idx=idx-corrRange-1;
        if abs(idx)<=maxdelay
            L(m,n)=idx;
        end
    end
end
NC=NC+NC';
L=L-L';
end