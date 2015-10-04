% merge two channels into one
%   SD=chmerge(fileName,tar,src)
function SD=chmerge(fileName,tar,src)
% If the last 2 letter of fileName is not '_c', make warning.
[~,tp,~]=fname(fileName);
if ~strcmp(tp(end-1:end),'_c')
    s=input('file not end in _c, continue?','s');
    if ~strcmp(s,'y')
        return
    end
end
% else load the input
load(fileName,'info','CSI','SD');

% default target
if isempty(tar)
    tar=src(1);
end
% target is in source list, delete from that list.
tp=find(src==tar);
if ~isempty(tp)
    src(tp)=[];
end
srcAmt=length(src);

% If the source and target channel is not from same electrode, make error
tarCh=info.chID(tar);
if sum(info.chID(src)==tarCh)<srcAmt
    error('source and target not from same electrode');
end

%%%
% CSI
src=sort(src,'ascend');
nlist=find(info.chID==tarCh);
newCSI=CSI{tarCh};
CSIele=unique(CSI{tarCh});
% location of tar in CSIele list
idx=(nlist==tar);
tarCSI=CSIele(idx);
for k=1:srcAmt
    % Get CSI number of the src
    idx=(nlist==src(k));
    srcCSI=CSIele(idx);
    newCSI(newCSI==srcCSI)=tarCSI;
end
CSI{tarCh}=newCSI;

% SD
temp=SD{tar};
for k=1:srcAmt
    temp=[temp;SD{src(k)}];
end
SD{tar}=sort(temp,'ascend');
SD(src)=[];

% info (must be behind CSI)
info.chID(src)=[];

save(fileName,'-append','info','SD','CSI');
end