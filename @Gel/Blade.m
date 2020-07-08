classdef Gel < handle
   % This class is designed to store 2D X-ray data from the Biological
   % Large angle diffraction Experiment at McMaster University (BLADE). 
   
   % Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
   % Sebastian Himbert (himberts@mcmaster.ca)
   
   properties
       filename      % Filename of the .img file
       xMetric       % Origin Corrected metric x coordinate of the 2D image (in mm)
       yMetric       % Origin Corrected metric x coordinate of the 2D image (in mm)
       
       ThetaChi      % Origin Corrected 2*Chi coordinate of the 2D image (in deg)
       Theta2Theta   % Origin Corrected 2*Theta coordinate of the 2D image (in deg)
       
       qpar          % Origin Corrected q-parallel coordinate of the 2D image (in A^-1)
       qz            % Origin Corrected q-z coordinate of the 2D image (in A^-1)
       
       Data2D        % spherical corrected 2D Data Array 
       
       Energy        % Source Energy setting
       Voltage       % Source Voltage setting
       Amperage      % Source Amperage setting
       Wavelength    % Source Wavelength
       
       SizeX         % Image X Dimension in Pixel
       SizeY         % Image Y Dimension in Pixel
       Origin        % Origin Position in Pixel
       PixelSize     % metric Pixel size Dimension in mm
       DetectorPos   % Relative distance Sample - Detector in mm
       DetectorPosChi% Chi Rotation of the Detector
       
       Inplane       % Integrated in-plane profile
       CircRefl      % Integrated out-of-plane profile
       LinRefl       % Integrated Refelctivity profile
       Herman        % Herman Orientation Function
       Diffuse       % Diffuse Scattering Profile
       
       qminI         %Integration Parameters
       qmaxI
       minAngleI
       maxAngleI
       
       qminCr
       qmaxCr
       minAngleCr
       
       qminH
       qmaxH
       minAngleH
       maxAngleH
       
       qminLr
       qmaxLr
       widthLr
       
       qminD
       qmaxD
       widthD
       
       PeakPosition  % Nx2 Array including the Peakpositons [centerPeakX_1 centerPeakY_1; centerPeakX_2 centerPeakY_2;... ]
       PeakEdges     % Nx4 Array including the peakedges [leftedgeX leftedgeY rightleftedgeX rightleftedgeY; ... ]
       Order
       FitData       % Fitparameter of fitted peaks
       dspacing
       phases
       PeakArea
       ElDensity
       Tfunc
       Orientation
       Version       % Used Library Version
   end
   
   methods
       function r = plus(o1,o2)
            r                        = Blade;
            NumFiles                 = numel(o1.filename);
            r.filename               = o1.filename;
            r.filename(NumFiles + 1) = o2.filename;
            r.xMetric                = o1.xMetric;
            r.yMetric                = o1.yMetric;
            r.Theta2Theta            = o1.Theta2Theta;
            r.ThetaChi               = o1.ThetaChi;
            r.qpar                   = o1.qpar;
            r.qz                     = o1.qz;
            r.Data2D                 = [o2.Data2D] + [o1.Data2D];
            r.Energy                 = o1.Energy;
            r.Voltage                = o1.Voltage;
            r.Amperage               = o1.Amperage;
            r.Wavelength             = o1.Wavelength;
            r.SizeX                  = o1.SizeX;
            r.SizeY                  = o1.SizeY;
            r.Origin                 = o1.Origin;
            r.PixelSize              = o1.PixelSize;
            r.DetectorPos            = o1.DetectorPos;
            r.DetectorPosChi         = o1.DetectorPosChi;
            r.Version                = o1.Version;
       end
       function r = minus(o1,o2)
            r                        = Blade;
            NumFiles                 = numel(o1.filename);
            r.xMetric                = o1.xMetric;
            r.yMetric                = o1.yMetric;
            r.Theta2Theta            = o1.Theta2Theta;
            r.ThetaChi               = o1.ThetaChi;
            r.qpar                   = o1.qpar;
            r.qz                     = o1.qz;
            r.Data2D                 = [o1.Data2D] - [o2.Data2D];
            r.Energy                 = o1.Energy;
            r.Voltage                = o1.Voltage;
            r.Amperage               = o1.Amperage;
            r.Wavelength             = o1.Wavelength;
            r.SizeX                  = o1.SizeX;
            r.SizeY                  = o1.SizeY;
            r.Origin                 = o1.Origin;
            r.PixelSize              = o1.PixelSize;
            r.DetectorPos            = o1.DetectorPos;
            r.DetectorPosChi         = o1.DetectorPosChi;
            r.Version                = o1.Version;
       end
       SetPeakPos(obj,varargin)
       load_img(obj,filename);
       Data = merge(obj,Mode,filename,numImages);
       Plot2Ddata(obj,flag)
       Integration2D(obj,flag, filename, qmin, qmax, varargin)
       ShowPeaks(obj)
       PlotBragg(obj)
       ElectronDensity(obj)
       T_func( obj, source,init,fitp)
       r = crop(obj, ROI)
       Pos = GetqparPos(obj,qparval)
       Pos = GetqzPos(obj,qzval)
       CorrectOrientation(obj);
       SetOrder(obj);
       GetVersion(obj);
       Plot1Ddata(obj,flag1);
       CalculateHerman(obj);
   end
   
end