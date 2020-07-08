function Plot1Ddata(obj,flag1)
% This function Plots reduce X-ray data stored in a Blade object 
% Parameters are:
% flag : use 'i'  for Inplane
%        use 'cr' for circular reflectivity
%        use 'lr' for linear reflectivity
%        use 'h'  for circular Profile
%        use 'd'  for diffuse Profile
%
% The function returns:
%  ---
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

figure()
if flag1 == 'i'
    Plottmp = errorbar(obj.Inplane(:,1),obj.Inplane(:,2),obj.Inplane(:,3),'.','MarkerSize',10);
    xlabel('$q_{||}$ ($\AA^{-1}$)','Interpreter','latex');
    ylabel('Intensity (cps)','Interpreter','latex');
elseif flag1 == 'cr'
    Plottmp = errorbar(obj.CircRefl(:,1),obj.CircRefl(:,2),obj.CircRefl(:,3),'.','MarkerSize',10);
    xlabel('$q_{z}$ ($\AA^{-1}$)','Interpreter','latex');
    ylabel('Intensity (cps)','Interpreter','latex');
elseif flag1 == 'lr'
    Plottmp = errorbar(obj.LinRefl(:,1),obj.LinRefl(:,2),obj.LinRefl(:,3),'.','MarkerSize',10);
    set(gca, 'yScale', 'log');
    xlabel('$q_{z}$ ($\AA^{-1}$)','Interpreter','latex');
    ylabel('Intensity (cps)','Interpreter','latex');
elseif flag1 == 'h'
    Plottmp = errorbar(obj.Herman(:,1),obj.Herman(:,2),obj.Herman(:,3),'.','MarkerSize',10);
    xlabel('$\phi$ (degrees)','Interpreter','latex');
    ylabel('Intensity (cps)','Interpreter','latex');
elseif flag1 == 'd'
    Plottmp = errorbar(obj.Diffuse(:,1),obj.Diffuse(:,2),obj.Diffuse(:,3),'.','MarkerSize',10);
    xlabel('$q_{||}$ ($\AA^{-1}$)','Interpreter','latex');
    ylabel('Intensity (cps)','Interpreter','latex');
end

set(Plottmp,'Color','k');

set(gcf,'position',[200 50 850 700]);

end