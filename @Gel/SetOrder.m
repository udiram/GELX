function SetOrder(obj)
% This function estimates the Order of the detected Bragg peaks 
% Parameters are:
%
% The function returns:
% The values are saved in the order variable
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

  PeakPos = obj.PeakPosition(:,1);
  obj.Order = zeros(1,numel(PeakPos));
  obj.Order(1)=1;
  CurOrder = 2;
  for i = 2:1:numel(PeakPos)
      while abs(CurOrder*PeakPos(1)-PeakPos(i))> 0.02
        CurOrder = CurOrder + 1;
        if CurOrder>15
            break
        end
      end
      obj.Order(i) = CurOrder;
  end
end