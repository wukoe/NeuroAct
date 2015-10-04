% This is multi-time Ising model method.
function [NC,varargout]=nc_mtising(BD,varargin)

binSize=5; 
lagAmt=50/binSize-1;
BD=multi_time_disloc(BD,lagAmt);

[NC,IM]=nc_ising(BD,varargin{:});

varargout{1}=IM;