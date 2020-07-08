function load_gel(obj,filename)
% This function loads 2D X-ray data and store the data in a Blade object 
% Parameters are:
% filename : Filename of the 2D Data
%
% The function returns:
%  ---
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

obj.xMetric     = x_corr_metricCord;  
obj.yMetric     = y_corr_metricCord;
obj.Theta2Theta = Theta2Theta;
obj.ThetaChi    = Theta2Chi;
obj.Data2D      = data;
obj.qpar        = qpar;
obj.qz          = qz;
obj.Data2D      = data;
obj.DetectorPos = DetectorGonioSet(end);
obj.DetectorPosChi = DetectorGonioSet(3);
obj.Version     = '5.0';
  
end