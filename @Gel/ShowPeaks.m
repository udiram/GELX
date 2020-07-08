function ShowPeaks(obj)
% This function shows the peaks found by obj.SetPeakPos()
% Parameters are:
%
% The function returns:
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

  peakdata = obj.PeakEdges;
  PeakPos = obj.PeakPosition;
  
  NumPeaks = numel(PeakPos(:,1));
  
  slope = ( peakdata(:,4)-peakdata(:,2) ) ./ ( peakdata(:,3)-peakdata(:,1) );
  Intersept = peakdata(:,2) - peakdata(:,1).*slope; 
  figure()
  hold on;
  plot(obj.LinRefl(:,1),obj.LinRefl(:,2),'k*')
  plot(PeakPos(:,1),PeakPos(:,2),'r*');
  for k=1:1:NumPeaks
      x =  [peakdata(k,1) peakdata(k,3)];
      y = slope(k).*x+Intersept(k);
      plot(x,y,'Linewidth',2);
  end
  hold off;
  set(gca, 'YScale', 'log');
end