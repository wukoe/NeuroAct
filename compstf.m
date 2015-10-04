% Make channel-specific features put together into one (currently mainly by
% averaging), so two cultures/two conditions can be compared by a single
% measure.

function [ft,chf]=compstf(F)
ft=struct();
chI=F.chI';
chf=zeros(length(chI),9);
chf(:,1)=chI;

ft.ac=F.activeChAmt;
ft.ar=mean(F.AvgRate(chI));
chf(:,2)=F.AvgRate(chI);
ft.cdtime=mean(F.cdTime(chI));
chf(:,3)=F.cdTime(chI);
ft.isimean=mean(F.isiMean(chI));
chf(:,4)=F.isiMean(chI);
ft.isicv=mean(F.isiCV(chI));
chf(:,5)=F.isiCV(chI);
ft.isimajor=mean(F.isiMajor(chI));
chf(:,6)=F.isiMajor(chI);
ft.blcount=mean(F.blCount(chI));
chf(:,7)=F.blCount(chI);
ft.bc=F.burstCount;
ft.chent=mean(F.chEntropy(chI));
chf(:,9)=F.chEntropy(chI);

ft=[ft.ac,ft.ar,ft.cdtime,ft.isimean,ft.isicv,ft.isimajor,ft.blcount,ft.bc,ft.chent];
% disp(chf);