% calculate the distance of CS sequences
%   [htd,pld,plsegd]=csdist(seqlist,CL)
% htd is length connecting head and tail, pld is the cumulative length over
% path.
% All distance in (fold of interval)

% Euclidean measure of X,Y distance of sequence (fold of grid)
% HT= head to tail,
% PL= each link in path.
function varargout=csdist(seqlist,CL,method)
%%% pre-Proc.
% User
flagHT=false; flagPL=false; flagNear=false; flagMST=false;
if method==1
    flagHT=true;
elseif method==2
    flagPL=true;
elseif method==3
    flagNear=true;
elseif method==4
    flagMST=true;
else
    error('!');
end

% In case the input is a single CS.
if isnumeric(seqlist)
    seqlist={seqlist};
end
% Basic Numbers
seqa=length(seqlist);
sl=cellstat(seqlist,'length');
% In case any CS with just one channel (though not likeli).
seleI=(sl>=2);
seqlist=seqlist(seleI);
newseqa=length(seqlist);
sl=sl(seleI);

%%%
if flagHT, HT=zeros(newseqa,1); end
if flagPL, PL=zeros(newseqa,1); plsegd=cell(newseqa,1); end
if flagNear, minD=zeros(newseqa,1); pairI=cell(newseqa,1); end
for seqi=1:newseqa
    % Localize each unit's position in CL matrix (as index start from top-left corner).
    yd=zeros(sl(seqi),1); xd=yd;
    for k=1:sl(seqi)
        [yd(k),xd(k)]=find(CL==seqlist{seqi}(k));
    end
    
    % Distance of head-tail of seq path.
    if flagHT
        HT(seqi)=sqrt((xd(1)-xd(end)).^2 + (yd(1)-yd(end)).^2);
    end
    
    % Distance of sum of each link in seq path.
    if flagPL
        xs=diff(xd);
        ys=diff(yd);
        plsegd{seqi}=sqrt(xs.^2 + ys.^2);
        PL(seqi)=sum(plsegd{seqi});
    end
    
    % Distance of sum of nearest pairs.
    if flagNear
        % Distance between each pair
        chD=juli([xd,yd]);
        % remove the distance to itself.
        for k=1:sl(seqi)
            chD(k,k)=NaN;
        end
        %
        [tp,I]=min(chD);
        minD(seqi)=sum(tp);
        pairI{seqi}=[(1:sl(seqi))',I'];
    end
    
    % Distance by MST
    if flagMST
    end
end

%%% post-Proc.
% Give the empty non-selected spaces back & output.
if flagHT
    temp=zeros(seqa,1);
    temp(seleI)=HT;
    HT=temp;
    varargout{1}=HT;
end
if flagPL
    temp=zeros(seqa,1);
    temp(seleI)=PL;
    PL=temp;
    temp=cell(seqa,1);
    temp(seleI)=plsegd;
    plsegd=temp;
    varargout{1}=PL;
    varargout{2}=plsegd;
end
if flagNear
    temp=zeros(seqa,1);
    temp(seleI)=minD;
    varargout{1}=temp;
    temp=cell(seqa,1);
    temp(seleI)=pairI;
    varargout{2}=temp;
end
if flagMST
end

end