function T_func( obj, source,init,fitp )
% peakpos -> bounds of the peaks 
% qpos -> Centre of the peak
% phases -> phase factor vn 
% data -> qz, as a spec1d data file 
% index -> assigned index vector for each peak 
% source -> keep as zero 

phases = obj.phases;
areas  = obj.PeakArea;
qpos   = (obj.PeakPosition(:,1))';

if nargin == 3; source = 0; end

x = 0:0.01:max(qpos)*1.5;
tmp.x = qpos;
if source == 0
    %[ed, dz, areas] = electron_density_abs(peakpos, qpos,phases,data,index,0,0);
    tmp.y = phases.*sqrt(areas'.*qpos);
elseif source ==1 
    areas = peakpos;
    size(phases)
    size(qpos)
    size(areas)
    tmp.y = phases.*sqrt(areas.*qpos);
end
tmp.e = sqrt(tmp.y);
FF = spec1d(tmp);

[fitarea, fitareadata] = fits(FF, 'hydrationphasesoffset', init, fitp);
pvals = [];
for m=1:size(fitareadata.pvals,1)
    pvals=cat(1,pvals,fitareadata.pvals(m));
end
Tz = hydrationphasesoffset(x,pvals);

% plot(FF)
figure()
hold on;
[xf,yf,errf] = extract(FF);
plot(xf,yf,'k*');
line(x,Tz,'linewidth',2)
hold off;
end

