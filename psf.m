% PSF (peri-stimulus frequency-gram)
% refer to [Gurcan 2014, Mimicking human neuronal pathways in silico- an
% emergent model on the effective connectivity]
%   [IFG,varargout]=psf(ST,E)
% E is event
function [IFG,varargout]=psf(ST,E)

prewin=-100;
postwin=200;

nAmt=length(ST);
etAmt=length(E);

%%%%%%%%%%%%
% First align the data to the event E.
A=eventa_spk(ST,E,[prewin,postwin]);



IFG=cell(nAmt,1); % data to store Instant firing frequency
for ni=1:nAmt
    IFG{ni}=zeros(0,2);
    % debug
cla
hold on

    %%% Get IR referenced to each event in E
    for eti=1:etAmt
        % each ISI
        D=diff(A{ni,eti});    
        % Instantaneous spiking rate
        IR=1000./D;        
        % place of time IR data (referenced to event)
        IRtime=A{ni,eti}(2:end)-E(eti);
        
        % Save the time and frequency data        
        IFG{ni}=[IFG{ni};[IRtime,IR]];
        
        % debug
        plot(A{ni,eti}-E(eti),ones(length(A{ni,eti}),1)*eti,'.');
    end    
end
 

%%%%%%%%%%% The CUSUM of PSF
if nargout==2
    % Determine bin of the time
    [binm,bina]=cutseg([prewin,postwin],10,'common'); % 10ms a bin

    CS=cell(nAmt,1);
    for ni=1:nAmt
        % Bin the IR data to time
        BI=binid(IFG{ni}(:,1),binm);

        % Bin avarage
        binAvg=zeros(bina,1);    
        for bi=1:bina
            temp=IFG{ni}((BI==bi),2); 
            if isempty(temp) % if not take care of empty bin case, mean() will give Nan value.
                binAvg(bi)=0;
            else
                binAvg(bi)=mean(temp);
            end
        end
        
        % Find the base line before the event - use average of each point
        % before event.
        I=(IFG{ni}(:,1)<-10);
        blm=mean(IFG{ni}(I,2));

        CS{ni}=binAvg-blm;
%         CS{ni}=cumsum(CS{ni});
    end
    varargout{1}=CS;
end

return
