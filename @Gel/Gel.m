classdef Gel < handle
   % This class is designed to store 2D X-ray data from the Biological
   % Large angle diffraction Experiment at McMaster University (BLADE). 
   
   % Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
   % Sebastian Himbert (himberts@mcmaster.ca)
   
   properties
       filename      % Filename of the .img file
       xMetric       % Origin Corrected metric x coordinate of the 2D image (in mm)
       yMetric       % Origin Corrected metric x coordinate of the 2D image (in mm)
       GelData
       CalibData
       LadderPos
       ReducedColumns
       XposColumns
       Version       % Used Library Version
   end
   
   methods
       load_gel(obj,filename);
       ShowGel(obj);
       Calibrate(obj);
       Reduce(obj);
       PlotColumns(obj,ColumnID,flag,varargin);
       save(obj);
   end
   
end