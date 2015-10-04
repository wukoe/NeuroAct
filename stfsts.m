% Get statistics for one feature of multiple ST groups
% FS is organized as: multiple conditions, each condition contain several
% replicates/samples.
%   [Y,MO]=stfsts(FS,task,item,chSele)
% FS: {{condition1},{condition2},...}
% task: 'b' boxplot; 'p' p-value.
% item: name of statistics to analyze
% chSele: select specific channels, using chID (! When doing boxplot for 
% channel-specific stats, better select only one channel.)
% MO: include active channel intersect and union.
%   Y=stfsts(FS,'b',item,chSele,gt) 
% gt: name (text) for each condition. Only for 'b' task.
function [Y,varargout]=stfsts(FS,task,item,chSele,varargin)
%%% Proc
ga=length(FS);
fa=cellstat(FS,'length');

if isstruct(FS{1})
    temp=cell(ga,1);
    for gi=1:ga
        temp{gi}=FS(gi);
    end
    FS=temp;
end

% if input is channel related information ,get channel id
if length(FS{1}{1}.(item))>1
    bCR=true; % whether it's channel respective
    if ~isempty(chSele)
        bChSpec=true;
    else
        bChSpec=false;
    end
else
    bCR=false;
    chSele=1;
end

% Get intersect and union of channels
chIntersect=FS{1}{1}.chI;
chUnion=FS{1}{1}.chI;
for gi=1:ga
    for fi=1:fa(gi)
        chIntersect=intersect(chIntersect,FS{gi}{fi}.chI);
        chUnion=union(chUnion,FS{gi}{fi}.chI);
    end
end
MO.chIntersect=chIntersect;
MO.chUnion=chUnion;

if strcmp(item,'chI')
    Y=MO;
    return
end

% Determine channel to use
if bCR && ~bChSpec % 如果特征是通道相关的，但又没有指定通道的话
    chSele=chIntersect;
end
chAmt=length(chSele);

%%%
if task=='b' % box plot
    bGroupText=false;
    if ~isempty(varargin)
        bGroupText=true;
        gt=varargin{1};
        assert(length(gt)==ga,'group text types not match to FS');
    end
    
    D=zeros(0,chAmt); G=[];
    for gi=1:ga        
        tp=zeros(fa(gi),chAmt);
        for fi=1:fa(gi)
            tp(fi,:)=FS{gi}{fi}.(item)(chSele)';
        end
        D=[D;tp];        
        G=[G;ones(fa(gi),1)*gi];        
    end
    if bGroupText
        temp=cell(length(G),1);
        for gi=1:ga
            temp=cellfill(temp,find(G==gi),gt{gi});
        end
        G=temp;
    end
    boxplot(D,G);    
    Y=D;
    
elseif task=='p' % p-value
    Y=zeros(ga,ga,chAmt);
    for chi=1:chAmt
        D=cell(ga,1);
        for gi=1:ga
            D{gi}=zeros(fa(gi),1);
            for fi=1:fa(gi)
                D{gi}(fi)=FS{gi}{fi}.(item)(chSele(chi));
            end
        end
        
        % P-value
        
        for m=1:ga-1
            for n=m+1:ga
                [~,Y(m,n,chi)]=ttest2(D{m},D{n});
            end
        end
        Y(:,:,chi)=Y(:,:,chi)+Y(:,:,chi)';
    end
    
    if chAmt==1
        Y=squeeze(Y);
    end
end

%%%
varargout{1}=MO;
end