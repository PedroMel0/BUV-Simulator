function tau = thrust(sigma_L, sigma_R, sigma_T, t)
%THRUST  Calculates the vector of forces and moments applied to BUV at time t
% Input:
%          t             - time
%          sigma_L (3x1) - Left  motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%          sigma_R (3x1) - Right motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%          sigma_T (3x1) - Tail  motor parameters: amplitude (degrees), frequency (Hz), offset (degrees)
%    Output:
%          tau (6x1)     - Vector of forces and moments applied to BUV at time t (body reference frame)
%                          tau = [X Y Z K M N]'

%Velocidade de rotação da Cauda (Experimental)  [RPM, motor]
Cauda_Vel=[3000
           1500
           1200
           900
           600
           300
           0];
Cauda_Vel = Cauda_Vel/60/12;  % [Hz, Oscila��o Cauda]
       
%Força aplicada pela Cauda [N]
Cauda_forca=[18
             12.8
             6.4
             2.4
             1.2
             0.4
             0];

%Amplitude da Oscilação na cauda [N]
Cauda_Ampl=[14.2
            8.2
            6.2
            3.2
            1.2
            0.6
            0];

%Velocidade de rotação da Barbatanas laterais (Experimental)   [RPM, motor]
BarbLat_Vel=[3000
           1500
           1200
           900
           600
           300
           0];
BarbLat_Vel = BarbLat_Vel/60/12;   % [Hz, Oscila��o Cauda]
       
%Força aplicada pelas Barbatanas laterais [N]
BarbLat_forca=[8
             6.2
             3.2
             1.2
             0.5
             0.15
             0];

%Amplitude da Oscilação na cauda [N]
BarbLat_Ampl=[5.2
            3.2
            2.2
            1.2
            0.4
            -0.8
            0];

%Amplitudes [º]
% AmpL = sigma_L(1);
% AmpR = sigma_R(1);
% AmpT = sigma_T(1);

%Frequencies [Hz]
FreqL = sigma_L(2);
FreqR = sigma_R(2);
FreqT = sigma_T(2);

%Offset's [º]
alfa = sigma_L(3);
beta = sigma_R(3);
delta = sigma_T(3);



%Distances [m]
r1 = 0.1;  %Distance between GC and Tail
r2 = 0.4;  %Tail lenght
r3 = 0.3;  %Distance between GC and Fins axle
r4 = 0.13;  %Distance between fins axle center and lateral fin
%r5 = 0.15; %Distance between GC and Tail end

%Constantes [Tranformação para Hz]
% Cauda_engr = 12; 
% BarbLat_engr = 12;
% VelCauda = FreqT/60/Cauda_engr;
% VelBarbesq = FreqL/60/BarbLat_engr;
% VelBarbdir = FreqR/60/BarbLat_engr;

%Thrusts [N]
%Força gerada pelas Barbatanas e Cauda
Cauda_av = interp1(Cauda_Vel,Cauda_forca,FreqT,'linear');
Cauda_Long = interp1(Cauda_Vel,Cauda_Ampl,FreqT,'linear');
Tta = Cauda_av + Cauda_Long * sin(t*FreqT*2*pi);

Barbesq_av = interp1(BarbLat_Vel,BarbLat_forca,FreqL,'linear');
Barbesq_Long = interp1(BarbLat_Vel,BarbLat_Ampl,FreqL,'linear');
Tle = Barbesq_av + Barbesq_Long * sin(t*FreqL*2*pi);

Barbdir_av = interp1(BarbLat_Vel,BarbLat_forca,FreqR,'linear');
Barbdir_Long = interp1(BarbLat_Vel,BarbLat_Ampl,FreqR,'linear');
Tri = Barbdir_av + Barbdir_Long * sin(t*FreqR*2*pi); 

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
Ml = r3 * Zl * (1);
Nl = r4 * Xl;


%Thrust right fin
Xr = cosd (beta)* Tri;
Yr = 0;
Zr = sind (beta)* Tri;
Kr = 0;
Mr = r3 * Zr * (1);
Nr = r4 * Xr;

Tt = [Xt Yt Zt Kt Mt Nt];

Tl = [Xl Yl Zl Kl Ml Nl];

Tr = [Xr Yr Zr Kr Mr Nr];

%tau = (Tl + Tr + Tt)';
tau = [(Xt+Xl+Xr),(Yt+Yl+Yl),(Zl+Zr+Zt),0,(Mt+Mr+Ml),Nt-Nr+Nl]';


%tau = [X Y Z K M N]




