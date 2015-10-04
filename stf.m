% get features of one data set.
%   [AF,SF]=stf(ST,info,varargin)
%   [AF,SF]=stf(ST,info,ml) specify the to do list ml
%   [AF,SF,ml,param]=stf() give the inherent to do list and parameters used
%   in some features.
function [AF,SF,ml,varargout]=stf(ST,info,varargin)
bSubTime=false;
if bSubTime
subtime=cutseg([0,info.TimeSpan],30,'common','equal'); 
% subtime=[0,30; 120,150; 240,270];
subtimeAmt=size(subtime,1);
end

srThres=6/60;

% Setting for some features.
ffwin=[0.01, 0.02, 0.05, 0.1, 0.2, 0.5,1, 2, 5, 10]';
ffwinAmt=length(ffwin);
isibin=[0,0.005,0.01,0.015,0.02,0.03,0.05,0.07,0.1,0.15,0.2,0.3,0.5,0.7,1,5]';
isibin=[isibin(1:end-1),isibin(2:end)];
isibinAmt=length(isibin);

% running flag
if ~isempty(varargin)
    ml=varargin{1};
else
    ml=struct();
    % AvgRate 必用
    ml.SpaceTimeGini=1; % include: SpaceGini, TimeGini
    ml.SpaceDRatio=1; %
    ml.isiHist=0; % isi distribution
    ml.isiMean=1; % mean of ISI
    ml.isiFrequent=1; % the most typical ISI number (bined histogram required)
    ml.isiCV=1;
    ml.isiLCV=0; % local
    ml.isiKS=1;
    ml.FF=1;
    ml.FFFrequent=1;
    ml.blCount=1;
    ml.burstCount=1;
    ml.chEntropyISI=1;
    ml.chEntropySRV=1;
end

%%% Inter-dependece between features - some flag must be forced on.
if ml.isiMean || ml.isiFrequent || ml.isiHist
    bISI=true;
else
    bISI=false;
end
if ml.isiFrequent
    ml.isiHist=1;
end

%%% Proc
chAmt=length(ST);
if bSubTime
assert(subtime(end,2)<=info.TimeSpan,'subtime segs exceeds time length');
end

%%% Calculate
% Full time feature
tt=info.TimeSpan;
AF=ststf(ST,tt);

if bSubTime
% Sub time segments feature
SF=cell(subtimeAmt,1);
for si=1:subtimeAmt
    st=sdcut(ST,subtime(si,:));
    tt=subtime(si,2)-subtime(si,1);
    SF{si}=ststf(st,tt);
end
else
    SF=[];
end

if nargout==4
    varargout{1}=struct('subtime',subtime,'ffwin',ffwin,'isibin',isibin);
end
%%%%%%%%%%%%% end of main


%%%%%%%%%%%%%%%%%%%%
% features for ST
    function F=ststf(ST,totaltime)
        F=struct();
        %%% Firing related
        [~,F.AvgRate]=stf_count(ST,totaltime);
        % Get index of qualified (fire enough channels). 这是后面其他计算必须的。
        chI=find(F.AvgRate>=srThres);
        F.chI=chI;
        F.activeChAmt=length(chI);
        % time-varying spk rate
        SR=spkrate(ST,'bin size',0.5);
        %     binnum=size(SR,1);
        if ml.SpaceTimeGini
            % spatial distribution (only of those active channels)
            F.SpaceGini=ginicoef(F.AvgRate(chI));
            % temporal distribution
            F.TimeGini=ginicoef(SR)';
        end
        % 50% of spk accumulate in how many channels
        if ml.SpaceDRatio
            temp=F.AvgRate(fi,:)';
            F.SpaceDRatio=cumthres(temp,0.5);
            F.SpaceDRatio=F.SpaceDRatio/chAmt;
        end
        
        %%% ISI calculation
        if bISI
            ISI=cell(chAmt,1);
            for chi=1:chAmt
                ISI{chi}=diff(ST{chi});
            end
        end
        if ml.isiHist
            F.isiHist=zeros(isibinAmt,chAmt);
            for chi=1:chAmt
                [~,F.isiHist(:,chi)]=binid(ISI{chi},isibin);
            end
            F.isiHist=F.isiHist';
        end
        
        if ml.isiMean
            F.isiMean=cellstat(ISI,'mean');
        end
        if ml.isiFrequent
            F.isiFrequent=zeros(chAmt,1);
            for chi=1:chAmt
                [~,idx]=max(F.isiHist(chi,:));
                F.isiFrequent(chi)=isibin(idx,2);
            end
        end
        if ml.isiCV, F.isiCV=stf_isi(ST,'CV')'; end
        if ml.isiKS, F.isiKS=stf_isi(ST,'KStest')'; end
        
        %%% Fano factor
        if ml.FF
            F.FF=zeros(chAmt,ffwinAmt);
            for k=1:ffwinAmt
                F.FF(:,k)=stf_ff(ST,[0,totaltime],ffwin(k),ffwin(k)/10);
            end
        end
        % Now maximum frequecny dependes on Fano factor results
        if ml.FFFrequent
            [~,idx]=max(F.FF,[],2); % index of maximum FF
            tp=ffwin(idx); % window size
            F.FanoFrequent=1./tp;
        end
        
        %%% Burst related
        if ml.blCount
            F.blCount=zeros(chAmt,1);
            for chi=1:chAmt
                temp=burstlet(ST{chi});
                F.blCount(chi)=size(temp,1);
            end
        end
        if ml.burstCount
            temp=burstdetect(ST);
            F.burstCount=sum(temp(:,3)>=30);
        end
        
        %%% Entropy related
        if ml.chEntropyISI
            F.chEntropyISI=stf_entropy(ST,'isi');
        end
        if ml.chEntropySRV
            F.chEntropySRV=stf_entropy(ST,'srv');
        end
        
    end

end