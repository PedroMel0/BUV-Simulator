function X = integration(dX, X0, T)
%INTEGRATION  Numerical integration of vector X
%    Input:
%          X0 - Current value of vector X
%          dX - Time derivative of vector X
%          dt - Time interval
%    Output:
%         X  - New value of vector X
 
X = X0 + T*dX;   % (Euler Method)


