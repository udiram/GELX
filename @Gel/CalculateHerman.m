function CalculateHerman(obj)
% This function calculates a circular profile along the first order bragg
% peak and calculates the orientation based on Hermans function
% Parameters are:
%  ---
%
% The function returns:
%  ---
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)
   
   qmax = obj.PeakPosition(1);
   qmin = obj.PeakPosition(1);
   minAngle = 10;
   maxAngle = 90;
 
   obj.Integration2D('h',qmin,qmax,minAngle,maxAngle);
   obj.Herman(:,1) = 90 - obj.Herman(:,1);
   data_s1d = spec1d(obj.Herman(:,1),obj.Herman(:,2),obj.Herman(:,3));
   
   init = [8000 0 20 100];
   fitp = [1 0 1 1];
   [~, GaussFitData] = fits(cut(data_s1d,[20 80]), 'ngauss', init, fitp);
   
   obj.Plot1Ddata('h');
   xval = 0:.1:80;
   hold on
   FitPlot = plot(xval,ngauss(xval,GaussFitData.pvals));
   hold off
   xlim([20 80]);
   
   set(FitPlot,'LineWidth',2,'Color',[1 0 0]);
   
   Parameters = GaussFitData.pvals;
   Errors     = GaussFitData.evals;
   
   Norm = trapz(0:.01:90,ngauss(0:.01:90,[1 1 1 0]'.*Parameters));
   Norm_max = trapz(0:.01:90,ngauss(0:.01:90,[1 1 1 0]'.* (Parameters + Errors)));

   P_phi = 1./Norm .* ngauss(0:.01:90,[1 1 1 0]'.*Parameters);
   P_phi_max = 1./Norm_max .* ngauss(0:.01:90,[1 1 1 0]'.*(Parameters + Errors));
   CosPhiSqrt = (cosd(0:.01:90)).^2;

   CosAvg = trapz(0:.01:90,CosPhiSqrt.*P_phi);
   CosAvg_max = trapz(0:.01:90,CosPhiSqrt.*P_phi_max);

   obj.Orientation(:,1) = (3.*CosAvg-1)./2;
   H = obj.Orientation(:,1);
   obj.Orientation(:,2) = abs(H - (3.*CosAvg_max-1)./2);
end