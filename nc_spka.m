% To infer connectivity based on spike-aligned statistics 
% including the delay and strength

function [NCP,NCL,TDP,TDL]=nc_spka(ST)

% default
win=[-10,10];
minTimeThres=1; %(ms) %%%%%%%%%%%%
% % threshold: percent of spikes that always in the 10ms bin of certain
% % lagging (10ms as used in spka_rate())
% efThres=0.5;

nAmt=length(ST);

% direction: row -> column
NCP=zeros(nAmt);
NCL=NCP;
TDP=NCP; % time delay
TDL=NCP;
for sni=1:nAmt
    [R,binT]=spka_rate(ST,sni,'window',win,'plot',false);
    % Get center bin rate of sni neuron as reference of relative rate.
    [~,idx]=min(abs(binT));
    cenbin=R(idx,sni);
    % Normalize every one to center bin
    R=R/cenbin;
    
    %%% Find max preceeding neurons to sni
    I=(binT<-minTimeThres);
    [dmax,dtI]=max(R(I,:));
    % translate to real index
    temp=find(I);
    dtI=temp(dtI);    
        
    NCP(:,sni)=dmax;
    TDP(:,sni)=binT(dtI);
    
    %%% Find max lagging neurons to sni
    I=(binT>minTimeThres);
    [dmax,dtI]=max(R(I,:));
    % translate to real index
    temp=find(I);
    dtI=temp(dtI);
    
    NCL(sni,:)=dmax;
    TDL(sni,:)=binT(dtI);
    
    fprintf('|');
end
fprintf('\n');