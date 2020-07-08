function load_gel(obj)
% This function loads 2D X-ray data and store the data in a Blade object 
% Parameters are:
% filename : Filename of the 2D Data
%
% The function returns:
%  ---
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

[filename,path] = uigetfile('*.tif','*.tiff');
CurrFileName = sprintf('%s%s',path,filename);
obj.GelData = imread(CurrFileName);
obj.filename = CurrFileName;
obj.xMetric     = [1:1:size(obj.GelData,2)];  
obj.yMetric     = [1:1:size(obj.GelData,1)];  
obj.Version     = '1.0';
  
end