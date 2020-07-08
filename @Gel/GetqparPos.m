function Pos = GetqparPos(obj,qparval)
% This function calculates the position in pixel for a given q parallel
% Parameters are:
%  qparval : q parallel value
%
% The function returns:
%  ---
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

  [~, Pos] = min( abs( obj.qpar - qparval ));
end