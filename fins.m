function zeta = fins(sigma_L, sigma_R, sigma_T, t)
%FINS  Calculates BUV fins positions at time t 
%    Input:
%          t             - time
%          sigma_L (3x1) - Left  motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%          sigma_R (3x1) - Right motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%          sigma_R (3x1) - Tail  motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%    Output:
%          zeta (3x1)    - Left, right, and tail fins positions at instant t (degrees)
%                          zeta = [deltaL deltaR beta]'

zeta(1) = sigma_L(1) * sind( 2*pi*sigma_L(2)*t) + sigma_L(3); %Amplitude * sin(wt) + offset
zeta(2) = sigma_R(1) * sind( 2*pi*sigma_R(2)*t) + sigma_R(3);
zeta(3) = sigma_T(1) * sind( 2*pi*sigma_T(2)*t) + sigma_T(3);



