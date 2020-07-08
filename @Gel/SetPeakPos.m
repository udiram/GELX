function SetPeakPos(obj,varargin)
% This function allows to select the peak positions. A figure opens and the
% user can select the left and right edge of each peak successivly. 
% Parameters are:
%  peakdata : information about edges (optional)
%  peakdata : information about edges (optional)
%
% The function returns:
%  ---
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

if nargin~=3
  figure()
  hold on;
  plot(obj.LinRefl(:,1),obj.LinRefl(:,2),'*')
  set(gca, 'YScale', 'log');
  hold off;
  set(gcf,'position',[200 50 1920 1080]);
  
  [x,~]        = ginput;
  NumPeaks     = numel(x)/2;
  
  peakdatatemp = zeros(NumPeaks,2);
  for k = 1:1:NumPeaks
      peakdatatemp(k,:) = [x(k*2-1) x(k*2)];
  end
  
  temppks  = repmat(peakdatatemp(:,1),[1 numel(obj.LinRefl(:,1))]);
  temppks  = temppks';
  tempdata = repmat(obj.LinRefl(:,1),[1 NumPeaks]);
  [~, MinPos1] = min(abs(tempdata-temppks)); 
  LeftEdge = obj.LinRefl(MinPos1,:);
  
  temppks  = repmat(peakdatatemp(:,2),[1 numel(obj.LinRefl(:,1))]);
  temppks  = temppks';
  tempdata = repmat(obj.LinRefl(:,1),[1 NumPeaks]);
  [~, MinPos2] = min(abs(tempdata-temppks)); 
  RightEdge = obj.LinRefl(MinPos2,:);
  
  peakdata = zeros(NumPeaks,4);
  PeakPos  = zeros(NumPeaks,2);
  PeakArea = zeros(NumPeaks,1);
  
%   slope = ( RightEdge(:,2)-LeftEdge(k,2) ) ./ ( RightEdge(:,1)-LeftEdge(:,1) );
%   Intersept = LeftEdge(:,2) - LeftEdge(:,1).*slope; 
  
  figure()
  hold on;
  for k = 1:1:NumPeaks
      peakdata(k,:) = [LeftEdge(k,1) LeftEdge(k,2) RightEdge(k,1) RightEdge(k,2)];
      slope = ( peakdata(k,4)-peakdata(k,2) ) ./ ( peakdata(k,3)-peakdata(k,1) );
      Intersept = peakdata(k,2) - peakdata(k,1).*slope; 
      temp = obj.LinRefl(MinPos1(k):MinPos2(k),1:2);
      [~,TempPos] = max(temp(:,2));
      PeakPos(k,:) = obj.LinRefl(MinPos1(k)+TempPos-1,1:2);
      CurrentLine = slope*temp(:,1)+Intersept;
      CurrentCorrectedPeak(:,1) = temp(:,1);
      CurrentCorrectedPeak(:,2) = temp(:,2) - CurrentLine;
      plot(CurrentCorrectedPeak(:,1),CurrentCorrectedPeak(:,2),'*');
%       plot(temp(:,1),CurrentLine,'-')
      PeakArea(k) = trapz(CurrentCorrectedPeak(:,1),CurrentCorrectedPeak(:,2));
      clear CurrentCorrectedPeak
  end
  hold off
  obj.PeakEdges = peakdata;
  obj.PeakPosition = PeakPos;
  obj.PeakArea = PeakArea;
else
  obj.PeakEdges = varargin{1};
  obj.PeakPosition = varargin{2};
end
%   close;
  obj.ShowPeaks;
  obj.SetOrder();
end