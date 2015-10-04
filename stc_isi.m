% compare the ISI of two spk trains
%   [D,binm]=stc_isi(st1,st2,method)
function [D,varargout]=stc_isi(st1,st2,method)
cha=length(st1);
D=zeros(cha,1);

if method==1 % K-S test of the all the ISIs 
    h=D;
    for chi=1:cha
        if length(st1{chi})>1 && length(st2{chi})>1
            d1=diff(st1{chi});
            d2=diff(st2{chi});

            [h(chi),pv]=kstest2(d1,d2);
            D(chi)=-log(pv); %<<<<<<
        else
            h(chi)=nan; D(chi)=nan;
        end
    end
    varargout{1}=h;

else % KL divergence of the probability distribution (histogram)
    binnum=20;
    maxInterval=10;% 10 seconds
    for chi=1:cha
        if length(st1{chi})>1 && length(st2{chi})>1
            d1=diff(st1{chi});
            d2=diff(st2{chi});
            d1=log(d1); d2=log(d2);
            dmin=min(min(d1),min(d2));
            dmax=max(max(d1),max(d2));
            dmax=beinrange(dmax,log(maxInterval),'high'); 
            binm=linspace(dmin,dmax,binnum);
            
            h1=hist(d1,binm);
            h2=hist(d2,binm);
            
            D(chi)=kldm(h1,h2);
            
        else
            D(chi)=nan;
        end
    end
    
    varargout{1}=binm;
end

end