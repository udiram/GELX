function [z,rho] = ElectronDensity(obj)
% This function calculates the electron density profile for a given set of
% Bragg peaks.
% Parameters are:
%  ---
%
% The function returns:
%  ---
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

qpos = obj.PeakPosition(:,1);
npeaks = numel(qpos);
peakint = obj.PeakArea;

dspacing = 2*pi/obj.dspacing(1);
phases = obj.phases;

peakint = peakint';

formfactor = sqrt(peakint.*qpos');
z = -dspacing/2:0.1:dspacing/2;
rho = 0;

for i=1:npeaks
    rho = rho + (2/dspacing) * abs(formfactor(i)) * phases(i) * cos(2*i*pi*z/dspacing);
end

obj.ElDensity = zeros(numel(rho),2);
obj.ElDensity(:,1) = z;
obj.ElDensity(:,2) = rho;

figure()
hold on;
plot(obj.ElDensity(:,1),obj.ElDensity(:,2),'linewidth',2);
xlabel('z(Å)','interp','tex','fontsize',[24],'fontname','Arial');
ylabel('\rho(e/V)','interp','tex','fontsize',[24],'fontname','Arial');
hold off
set(gcf,'Position',[800 100 770 640],...
        'PaperPositionMode', 'auto');    
end

