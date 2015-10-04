% detect burst
%   [BL,chlist]=burstdetect(ST)
% each row of BL: [start time, stop time, burstlet contained]
function [BL,varargout]=burstdetect(ST)
chA=length(ST);

%%% Detect burstlet of each channel
% event list for start and end of all burstlet - 4 numbers: 
% [time, flag for start/end (1 for start/0 for end), channel ID, burstlet index].
% EV=zeros(0,4);
blL=zeros(0,3); % burstlet list [ts,te,ch idx]
for chi=1:chA
    [~,BT,~]=burstlet(ST{chi},'extend',1);
    ba=size(BT,1);
    if ba>0 
%         % Add to EV
%         temp=[BT(:,1),ones(ba,1),chi*ones(ba,1),(1:ba)']; 
%         EV=[EV;temp];
%         temp=[BT(:,2),zeros(ba,1),chi*ones(ba,1),(1:ba)']; 
%         EV=[EV;temp];
        
        % Add to blL
        temp=[BT,ones(ba,1)*chi];
        blL=[blL;temp];
    end
end
% % Sort by time
% [~,I]=sort(EV(:,1),'ascend');
% EV=EV(I,:);
% % <<< test
% % EV=[1,1;2,1;3,0;4,1;5,0;6,0;7,1;8,1;9,0;10,0;11,1;12,0];
% eAmt=size(EV,1);

%%% Find all overlapping "pileup" (including with 1 burstlet)
% 1/N if previous in adding, turn to down side mark end of a burst
[ol,~,ols]=findoverlap(blL);
BL=zeros(length(ol),3);
BL(:,1:2)=ols;
BL(:,3)=cellstat(ol,'length');

% % 2/N if drops to half of peak burstlet count, mark end of a burst (method may contain flaw)
% burC=0; % burst count
% BL=zeros(0,3);
% flagStat=0; % 1=adding burstlet, 0=subtracting burstlet
% blC=0; % burstlet count (in overlapping)
% 
% maxblC=blC;
% for ei=1:eAmt
%     if EV(ei,2)
%         % if this is a back to adding burstlet, prepare to start a new burst
%         if flagStat==0
%             flagStat=1;
%         end
%         blC=blC+1;
%         if blC>=maxblC
%             maxblC=blC;
%             maxloc=ei;
%         end
%         waitbacktoup=false;
%     else
%         flagStat=0;
%         if blC>0
%             blC=blC-1;            
%         end
%         % if previous in adding, turn to down side will mark end of a burst
%         if blC<=maxblC/2 && ~waitbacktoup
%             burC=burC+1;
%             BL(burC,:)=[maxloc,ei,maxblC]; % mark the end is ok <<<
%             
%             maxblC=blC;
%             maxloc=ei;
%             waitbacktoup=true;
%             
%             %<<< debug
%             if burC==136
%                 pause(1);
%             end
%         end
%         
%     end
% end       
% 
% % Get time interval and burstlet number of burst
% BL(:,1)=EV(BL(:,1),1);
% BL(:,2)=EV(BL(:,2),1);


%%% Get channels participating in each burst
% * 方法：计算所有EV
if nargout==2
    % central time of each burst
    T=mean(BL(:,1:2),2);
    
    blA=size(BL,1);
    chlist=cell(blA,1);
    for bi=1:blA
        % Find all burstlets that cover the centeral burst time
        I=(blL(:,1)<T(bi)) & (blL(:,2)>T(bi));
        chlist{bi}=blL(I,3);
    end
    varargout{1}=chlist;
end

end