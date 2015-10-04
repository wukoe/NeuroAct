% plot path on the MEA data
%   meapath(seqlist,CL,DT,seqID)
% DT and seqID is optional. seqID provides types of each channel in CS.
function meapath(seqlist,CL,varargin)
chAmt=120;
coltab=colormap('jet');
colnum=size(coltab,1);

% User
seqAmt=length(seqlist);
seqLen=cellstat(seqlist,'length');
flagDT=false;
flagID=false;
if nargin>=3
    DT=varargin{1};
    assert(isequal(cellstat(DT,'length'),seqLen),'seqDT length not match to seqlist');
    flagDT=true;
end
if nargin==4
    seqID=varargin{2};
    assert(isequal(cellstat(seqID,'length'),seqLen),'seqID length not match to seqlist');
    flagID=true;
end

% Proc
% Adapte the color map intervel to cover whole color spectrum.
tp=ceil(colnum/seqAmt);
if tp>1
    coltab=coltab(1:tp:end,:);
    colnum=size(coltab,1);
end

%%% Draw!
% Put the channel layout figure as background.
cla
[~,electpos]=chlayout(-ones(chAmt,1),CL,'style',2);
if size(electpos,1)~=chAmt
    error('list length not match');
end
axis equal
hold on

% Path.
for seqi=1:seqAmt
    % Copy current CS.
    seq=seqlist{seqi};
    if flagDT
        dt=DT{seqi};
    end
    
    % Decide index of color table for this sequence.
    idx=mod(seqi,colnum);
    if idx==0, idx=colnum; end
    cscolor=coltab(idx,:);
    
    % Separate effective and non channels in current CS.
    if flagID
        seqp=seqID{seqi};
        effI=(seqp==-1);
        seqext=seq(~effI);
        seq=seq(effI);
        dt=dt(effI);
    end
    seqlen=length(seq);
    
    % Draw start location.
    plot(electpos(seq(1),1),electpos(seq(1),2),'.','Color',cscolor,'MarkerSize',30);
    % Draw line.
    line(electpos(seq,1),electpos(seq,2),'Color',cscolor,'LineWidth',3);
    % Draw non-effective channels.
    if flagID        
        plot(electpos(seqext,1),electpos(seqext,2),'O','Color',cscolor,'MarkerSize',10);
    end
    
    % Delay time info.
    if flagDT && seqlen>=2
        stepdt=diff(dt)*1000;%(ms)
        for ci=1:seqlen-1
            % location
            txtloc=electpos(seq(ci+1),:);
%             txtloc(2)
            % disp
            dttxt=num2str(stepdt(ci));
            text(txtloc(1),txtloc(2),dttxt,'Color','w','BackgroundColor',cscolor);
        end
    end
end

end