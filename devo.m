% demonstrate correlation coef. evolve over time
%   devo(SI,T)
function varargout=devo(SI,T)

bin=500; %(ms)
rbin=100; % bin for computing firing rate
if nargout>=1
    bOut=true;    
else
    bOut=false;
end

ST=idx2time(SI,T);
[R,bt]=spkrate(ST,[T(1),T(end)],rbin);
rbina=length(bt);

bin=round(bin/rbin*2);
[segm,sega]=cutseg(rbina,bin);

na=length(SI);
if bOut
    varargout{1}=zeros(na,na,sega);
    varargout{2}=zeros(sega,2);
end

for segi=1:sega
    C=corrcoef(R(segm(segi,1):segm(segi,2),:));
    I=isnan(C); C(I)=0;
    tp=[bt(segm(segi,1)),bt(segm(segi,2))]/1000; %(s)
    if bOut
        varargout{1}(:,:,segi)=C;
        varargout{2}(segi,:)=tp;
    end
    
    imagesc(C,[0,1]);
    title(sprintf('corr coef - %.1f-%.1f s',tp(1),tp(2)));
    colorbar    
    pause(0.5);   
end