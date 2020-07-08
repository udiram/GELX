function Data = merge(obj,Mode,filename_base,numImages)
% This function loads n 2D X-ray data and store the data in a vector of
% Blade objects. The Datafiles are then combined to either a Panorama or a
% long time exposure (lte) blade object.
% Parameters are:
% Mode: Type of combination. Select 'p' or 'P' for Panorama and 'lte' or
%       'LTE' for a long time exposure image.
% filename : Filename Base of the 2D Data (without number and .img -postfix)
% numImages: #images that needs to be combined.
%
% The function returns:
%  Data = nx1 Array of Blade objects, where n is the number of Datafiles.
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

for k = 1:1:numImages
   Data(k) = Blade;
end

if (Mode == 'p')  %|| (Mode == 'P')
    for k = 1:1:numImages
        filename = sprintf('%s_%04d.img',filename_base,k);  
        if k == 1
            Data(k).load_img(filename);
            obj.filename = {filename};
        else
            Data(k).load_img(filename);
            obj.filename(k) = {filename};
            minqpar(k) = Data(k).qpar(1);
            maxqpar(k) = Data(k).qpar(end);
            minqz(k) = Data(k).qz(1);
            maxqz(k) = Data(k).qz(end);
        end
    end
        globalMaxqz = max(maxqz);
        globalMinqz = min(minqz);
        MinCrop = Data(1).qpar(1);
        TotalqparSize = 0;
    for k=1:1:numImages
        MaxCrop = Data(k).qpar(end);
        DataCrop(k) = Data(k).crop([MinCrop,MaxCrop,globalMinqz,globalMaxqz]);
        MinCrop = Data(k).qpar(end);
        TotalqparSize = TotalqparSize + DataCrop(k).SizeX;
    end
    obj.Data2D = zeros(Data(1).SizeY,TotalqparSize);
    obj.qpar = zeros(1,TotalqparSize);
    obj.qz = zeros(1,Data(1).SizeX);
    obj.qz = Data(1).qz;
    obj.Origin = Data(1).Origin;
    obj.Wavelength = Data(1).Wavelength;
    obj.Energy = Data(1).Energy;
    obj.Amperage = Data(1).Amperage;
    obj.Voltage = Data(1).Voltage;
    MinPos = 0;
    for k=1:1:numImages
       obj.Data2D(:,MinPos+1:MinPos+DataCrop(k).SizeX) = DataCrop(k).Data2D;
       obj.qpar(:,MinPos+1:MinPos+DataCrop(k).SizeX)   = DataCrop(k).qpar;
       MinPos = MinPos+DataCrop(k).SizeX;
    end
    obj.Theta2Theta = 2*asind(obj.qz*obj.Wavelength/4/pi);
    obj.ThetaChi = 2*asind(obj.qpar*obj.Wavelength/4/pi);
    obj.SizeX = numel(obj.qpar);
    obj.SizeY = numel(obj.qz);
    obj.Version = Data(1).Version;
    obj.DetectorPos = Data(1).DetectorPos;
    obj.PixelSize = Data(1).PixelSize;
    obj.DetectorPosChi = NaN;
    
    x_corr_pxCord     = (1:1:obj.SizeX) - obj.Origin(1);   
    y_corr_pxCord     = (1:1:obj.SizeY) - obj.Origin(2);

    obj.xMetric = x_corr_pxCord*obj.PixelSize(1);
    obj.yMetric = y_corr_pxCord*obj.PixelSize(2); 
    
    
elseif (Mode == 'lte') %|| (Mode == 'LTE')
    DataSum = Blade;
    for k = 1:1:numImages
        filename = sprintf('%s_%04d.img',filename_base,k);  
        Data(k).load_img(filename);
    end
    
    DataSum = Data(1); 
    
    for k = 2:1:numImages
      DataSum = DataSum + Data(k);
    end
    
    obj.filename = DataSum.filename;
    obj.Data2D = DataSum.Data2D;
    obj.qpar = DataSum.qpar;
    obj.qz = DataSum.qz;
    obj.Origin = DataSum.Origin;
    obj.Wavelength = DataSum.Wavelength;
    obj.Energy = DataSum.Energy;
    obj.Amperage = DataSum.Amperage;
    obj.SizeX = DataSum.SizeX;
    obj.SizeY = DataSum.SizeY;
    obj.Voltage = DataSum.Voltage;
    obj.xMetric = DataSum.xMetric;
    obj.yMetric = DataSum.yMetric;
    obj.Theta2Theta = DataSum.Theta2Theta;
    obj.ThetaChi = DataSum.ThetaChi;
    obj.Version = DataSum.Version;
    obj.DetectorPos = DataSum.DetectorPos;
    obj.DetectorPosChi = DataSum.DetectorPosChi;
    obj.PixelSize = DataSum.PixelSize;
end

end