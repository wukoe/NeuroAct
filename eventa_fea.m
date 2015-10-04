% Event-aligned signal features
function A=eventa_fea(E,F,T,varargin)

[dlen,cha]=size(F);
if length(T)~=dlen
    error('time information and feature data length mismatch');
end

%%% 
% Find the cloest time mark to eachy event
eventTime=closest(E,T); % actually we get index of T

% Export the value at exact point.
A=F(eventTime,:);