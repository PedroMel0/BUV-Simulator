function [sigma_L, sigma_R, sigma_T] = openLoopController(t)
%OPENLOOPCONTROLLER  Generates the fins sinusoidal parameters (open loop)
%    Input:
%          t              - time
%    Output:
%          sigma_L (3x1)  - Left  motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%          sigma_R (3x1)  - Right motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%          sigma_T (3x1)  - Tail  motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)

if(t<101)
    sigma_R = [0; 0*360/60/12; 0]';  
    sigma_L = [0; 0*360/60/12; 0]';
    sigma_T = [20; 360/60/12; -1]';
elseif(t<110)
    sigma_R = [1, 1080/60/12, -1.5]';  
    sigma_L = [1, 1080/60/12, -1.5]';
    sigma_T = [0, 0*100/60/12, 0]';
elseif(t<150)
    sigma_R = [1, 1080/60/12, 0]';
    sigma_L = [1, 1080/60/12, 0]';
    sigma_T = [0, 0*10/60/12, 0]';
elseif(t<200)
    sigma_R = [1, 1080/60/12, -1]';
    sigma_L = [1, 1080/60/12, -1]';
    sigma_T = [0, 0*10/60/12, 0]';
elseif(t<250)
    sigma_R = [1, 1080/60/12, 5]';
    sigma_L = [1, 1080/60/12, 5]';
    sigma_T = [0, 0*10/60/12, 0]';
elseif(t<300)
    sigma_R = [1, 1080/60/12, 2]';
    sigma_L = [1, 1080/60/12, 2]';
    sigma_T = [0, 0*10/60/12, 0]';
else
    sigma_R = [10, 1080/60/12, 0]';
    sigma_L = [10, 1080/60/12, 0]';
    sigma_T = [0, 0*720/60/12, 0]';
end
