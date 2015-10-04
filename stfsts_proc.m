% analyzing all features' P-value together.
fea={'AvgRate','SpaceGini','TimeGini','isiFrequent','isiCV','FanoFrequent','chEntropyISI','chEntropySRV'};
feaA=8; chA=length(chI);

pmin=zeros(feaA,1); pch=zeros(feaA,chA); pchn=pmin;
for k=1:feaA
    p=stfsts({FS(1:4),FS([5,7,8])},'p',fea{k},chI);
    if size(p,3)==1
        pmin(k)=p(1,2);
    else
        tp=squeeze(p(1,2,:));
        pmin(k)=min(tp);
        pch(k,:)=tp';
        pchn(k)=sum(tp<0.05);
    end
end

%%
tp=zeros(120,1);
tp(STchID(chI))=1-pch(8,:);