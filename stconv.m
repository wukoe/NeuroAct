% convolute spike train with a function to form continuous-valued data
% train. it's like response function of a spike train
%   D=stconv(ST,drate,timeScale)
function D=stconv(ST,drate,timeScale)
tw=ceil(-timeScale*log(0.01)); % template length - determined as the amplitude drops to 1% below

cha=length(ST);

%%% The response function to the spike train.
twbit=ceil(tw*drate/1000); % time window for template length.
tp=linspace(0,tw,twbit);

% template - exponential function
tpl=exp(-tp/timeScale)'; 

%%% Convert ST to new data
tp=cellstat(ST,'min');
stmin=min(tp);
tp=cellstat(ST,'max');
stmax=max(tp);

for chi=1:cha
    ST{chi}=round((ST{chi}-stmin)*drate)+1;
end

dlen=ceil((stmax-stmin)*drate);
dlen=dlen+twbit;
D=zeros(dlen,cha);
for chi=1:cha
    sa=length(ST{chi});
    for si=1:sa
        idx=ST{chi}(si):ST{chi}(si)+twbit-1;
        D(idx,chi)=D(idx,chi)+tpl;
    end
end

end