% get combination of ST statistics from multiple files specified by file list 'fl'.
% before run, obtain _os,ol,etc.
ml=struct();
ml.SpaceTimeGini=1; % include: SpaceGini, TimeGini
ml.SpaceDRatio=1; %
ml.isiHist=0; % isi distribution
ml.isiMean=1; % mean of ISI
ml.isiFrequent=1; % the most typical ISI number (bined histogram required)
ml.isiCV=1;
ml.isiLCV=0; % local
ml.isiKS=0;
ml.FF=1;
ml.FFFrequent=1;
ml.blCount=1;
ml.burstCount=1;
ml.chEntropyISI=1;
ml.chEntropySRV=1;
% <<< add sparseness, spike count distribution,power spectra,

chAmt=59;
totaltime=300;

%%%
FS=cell(fa,1); SFS=FS;
for fi=1:fa
    load(fl{fi},'SDT','info');
    [F,SF]=stf(SDT,info);%,ml);    
    FS{fi}=F; 
    SFS{fi}=SF;

    fprintf('|');
end
fprintf('\n');

% %% Get day - session list
% dnum=zeros(fa,1); % recoding date number
% for fi=1:fa
%     dnum(fi)=str2double(fl{fi}([1,2,4,5])); % <<< 4, 5
% end
% 
% startdate=0807; % <<<
% days=dnum-startdate+1;
% 
% %%
% lbi=reabylb(days);
% sessions=zeros(lbi.cAmt,2);
% days=lbi.types';
% for k=1:lbi.cAmt
%     sessions(k,:)=[lbi.ids{k}(1),lbi.ids{k}(end)];
% end
