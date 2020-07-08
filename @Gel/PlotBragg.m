function PlotBragg(obj)
% This function plot 2D X-ray data
% Parameters are:
%
% The function returns:
%  Plot the peak position vs the expected order and performs a linear fit.
%  The result is stored in the dspacing variable.
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

  PeakPos = obj.PeakPosition(:,1);
  figure()
  
  order = obj.Order;
  errorbar(order,PeakPos,0.01*PeakPos,'k*');
  xlabel('Order');
  ylabel('Peak Position');
  data = spec1d(order,PeakPos,0.01*PeakPos);
  [~,LinFitData]=fits(data,'strline',[1 0],[1 0]);
  hold on;
  plot(order,strline(order,LinFitData.pvals));
  obj.dspacing = [LinFitData.pvals(1) LinFitData.evals(1)];
  hold off;
end