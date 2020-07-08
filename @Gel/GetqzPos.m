function Pos = GetqzPos(obj,qzval)
% This function calculates the position in pixel for a given q-z
% Parameters are:
%  qzval : q-z value
%
% The function returns:
%  ---
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)

  [~, Pos] = min( abs( obj.qz - qzval ));
end