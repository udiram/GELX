function Plot2Ddata(obj,flag)
% This function plot 2D X-ray data
% Parameters are:
%
% The function returns:
%  2D Plot of the Diffraction Data
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

if nargin == 1
   flag = 'q'; 
end

if strcmp(flag,'q')
    [xi,yi]=meshgrid(obj.qpar,obj.qz);
elseif strcmp(flag,'a')
    [xi,yi]=meshgrid(obj.ThetaChi,obj.Theta2Theta);
elseif strcmp(flag,'m')
    [xi,yi]=meshgrid(obj.xMetric,obj.yMetric);
end

logdata = log(obj.Data2D);

logdata(logdata == -inf) = 0;

figure()
if strcmp(flag,'p')
    pcolorPlot = pcolor(logdata);
else
    pcolorPlot = pcolor(xi,yi,logdata);
end

box on;
set(gca,'layer','top')
set(pcolorPlot,'EdgeColor','none');
% set(pcolorPlot,'FaceColor','interp','EdgeColor','interp');
colormap default
caxis([2 10]);

if strcmp(flag,'q') || nargin == 1
    xlabel('$q_{||}$ ($\AA^{-1}$)','Interpreter','latex');
    ylabel('$q_{z}$ ($\AA^{-1}$)','Interpreter','latex');
elseif strcmp(flag,'a')
    xlabel('ThetaChi (deg)','Interpreter','latex');
    ylabel('Theta2Theta (deg)','Interpreter','latex'); 
elseif strcmp(flag,'m')
    xlabel('X (mm)','Interpreter','latex');
    ylabel('Y (mm)','Interpreter','latex'); 
elseif strcmp(flag,'p')
    xlabel('X (pixel)','Interpreter','latex');
    ylabel('Y (pixel)','Interpreter','latex');    
end

set(gcf,'position',[200 50 850 700]);
end
