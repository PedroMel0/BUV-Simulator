function tau = thrustt(sigma_L, sigma_R, sigma_T, t)
%THRUST  Calculates the vector of forces and moments applied to BUV at time t
% Input:
%          t             - time
%          sigma_L (3x1) - Left  motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%          sigma_R (3x1) - Right motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%          sigma_T (3x1) - Tail  motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%    Output:
%          tau (6x1)     - Vector of forces and moments applied to BUV at time t (body reference frame)
%                          tau = [X Y Z K M N]'

%Amplitudes [Âº]
AmpL = sigma_L(1);
AmpR = sigma_R(1);
AmpT = sigma_T(1);

%Frequencies [Hz]
FreqL = sigma_L(2);
FreqR = sigma_R(2);
FreqT = sigma_T(2);

%Offset's [Âº]
alfa = sigma_L(3);
beta = sigma_R(3);
delta = sigma_T(3);

% ForÃ§a gerada pela Cauda       
Kt0 = 0.2;
Kt1 = 0.5;
tphi1 = 0;
Kt2 = 0.1;
tphi2 = 0;

Tta = Kt0*AmpT*FreqT*(1+Kt1*cos(FreqT*t+tphi1)+Kt2*cos(2*FreqT*t+tphi2));

% ForÃ§a gerada pelas Barbatanas 
K0 = 0.2;
K1 = 0.5;
phi1 = 0;
K2 = 0.2;
phi2 = 0;

Tle = K0*AmpL*FreqL*(1+K1*cos(FreqL*t+phi1)+K2*cos(2*FreqL*t+phi2));

Tri = K0*AmpR*FreqR*(1+K1*cos(FreqR*t+phi1)+K2*cos(2*FreqR*t+phi2));



%Distances [m]
r1 = 0.1;  %Distance between GC and Tail
r2 = 0.4;  %Tail lenght
r3 = 0.3;  %Distance between GC and Fins axle
r4 = 0.13;  %Distance between fins axle center and lateral fin
%r5 = 0.15; %Distance between GC and Tail end

%Thrust Tail
Xt = cosd (delta)* Tta;
Yt = sind (delta)* Tta;
Zt = 0;
Kt = 0;
Mt = 0;
raio1 = sqrt(((r1+(r2*cosd(delta)))^2)+((sind(delta)*r2)^2));
teta = atand((sind(delta)*r2)/(r1+(cosd(delta)*r2)));
Nt = raio1 * cosd(teta) * Yt * (-1);

%Thrust left fin
Xl = cosd (alfa)* Tle;
Yl = 0;
Zl = sind (alfa)* Tle;
Kl = 0;
Ml = r3 * Zl * (-1);
Nl = r4 * Xl;


%Thrust right fin
Xr = cosd (beta)* Tri;
Yr = 0;
Zr = sind (beta)* Tri;
Kr = 0;
Mr = r3 * Zr * (-1);
Nr = r4 * Xr;

Tt = [Xt Yt Zt Kt Mt Nt];

Tl = [Xl Yl Zl Kl Ml Nl];

Tr = [Xr Yr Zr Kr Mr Nr];

%tau = (Tl + Tr + Tt)';
tau = [(Xt+Xl+Xr),(Yt+Yl+Yl),(Zl+Zr+Zt),0,(Mt+Mr+Ml),Nt-Nr+Nl]';
