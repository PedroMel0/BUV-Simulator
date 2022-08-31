function [sigma_L, sigma_R, sigma_T] = closedLoopController(setpoint, eta, sigma_L, sigma_R, sigma_T, t)
%CLOSEDLOOPCONTROLLER  Generates the fins sinusoidal parameters     (closed loop)
%    Input:
%          setpoint (6x1) - Generalized reference position vector (NED reference frame)
%                           eta = [x y z phi theta psi]'
%          eta (6x1)      - Generalized position vector (NED reference frame)
%                           eta = [x y z phi theta psi]'
%          sigma_L (3x1)  - Left  motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%          sigma_R (3x1)  - Right motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%          sigma_R (3x1)  - Tail  motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%          t              - time
%    Output:
%          sigma_L (3x1)  - New left  motor parameters
%          sigma_R (3x1)  - New right motor parameters
%          sigma_R (3x1)  - New tail  motor parameters
