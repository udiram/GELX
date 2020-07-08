function r = crop(obj,ROI)
% This function crops 2D X-ray data stored in a Blade Object
% Parameters are:
% ROI = vector with [qpar_min qpar_max qz_min qz_max]
%
% The function returns:
%  Blade Object with the cropped data
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

r               = Blade;
[~, qparminPos] = min( abs(obj.qpar - ROI(1)));
[~, qparmaxPos] = min( abs(obj.qpar - ROI(2)));
[~, qzminPos]   = min( abs(obj.qz - ROI(3)));
[~, qzmaxPos]   = min( abs(obj.qz - ROI(4)));

r.filename               = obj.filename;
r.xMetric                = obj.xMetric(qparminPos:qparmaxPos);
r.yMetric                = obj.yMetric(qzminPos:qzmaxPos);
r.ThetaChi               = obj.ThetaChi(qparminPos:qparmaxPos);
r.Theta2Theta            = obj.Theta2Theta(qzminPos:qzmaxPos);
r.qpar                   = obj.qpar(qparminPos:qparmaxPos);
r.qz                     = obj.qz(qzminPos:qzmaxPos);
r.Data2D                 = obj.Data2D(qzminPos:qzmaxPos,qparminPos:qparmaxPos);
r.Energy                 = obj.Energy;
r.Voltage                = obj.Voltage;
r.Amperage               = obj.Amperage;
r.Wavelength             = obj.Wavelength;
r.SizeX                  = numel(r.qpar);
r.SizeY                  = numel(r.qz);
r.Origin                 = [find(r.qpar==0);find(r.qz==0)];
r.PixelSize              = obj.PixelSize;
r.DetectorPos            = obj.DetectorPos;
end