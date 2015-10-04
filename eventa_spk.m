% Get the event-aligned spike series (event can be stimuli or the spikes of
% a specific neuron).
%   A=eventa_spk(ST,E,win)
% A is in {nAmt * sAmt} form
function A=eventa_spk(E,ST,win)

nAmt=length(ST);
sAmt=length(E);

A=cell(nAmt,sAmt);
for ni=1:nAmt
    for si=1:sAmt
        swin=[E(si)+win(1), E(si)+win(2)];        
        I=(ST{ni}>=swin(1)) & (ST{ni}<=swin(2));
        A{ni,si}=ST{ni}(I);
    end
end