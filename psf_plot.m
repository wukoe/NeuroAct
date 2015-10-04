% plot the results of PSF and CUSUM
%   psf_plot(IFG,nidx)
function psf_plot(IFG,nidx)

% Plot it the IR data for specified neuron
IRtime=IFG{nidx}(:,1);
IR=IFG{nidx}(:,2);
plot(IRtime,IR,'.');
        
% Additional information to graph
xlabel('time (ms)');
ylabel('instant firing rate (Hz)');
title('PSF');