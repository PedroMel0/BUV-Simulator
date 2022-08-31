function [dNu, M, D, F, Dl, Dq, Dlf, Dqf, Cent] = dynamics( Nu, eta, zeta, tau)
%DYNAMICS  Obtains the BUV generalized acceleration vector
%    Input:
%          Nu (6x1)   - Generalized velocity vector (body reference frame)
%                       Nu = [u v w p q r]'       
%          eta (6x1)  - Generalized position vector (NED reference frame)
%                       eta = [x y z phi theta psi]'
%          zeta (3x1) - Left, right, and tail fins positions at instant t (degrees)
%                       zeta = [deltaL deltaR beta]'
%          tau (6x1)  - Vector of forces and moments applied to BUV at time t (body reference frame)
%                       tau = [X Y Z K M N]'
%    Output:
%          dNu (6x1)  - Generalized acceleration vector (body reference frame)
%         dNu = dNu/dt

m = 45; 
Ix = 0.73; Iy = 7.72; Iz = 7.72;
Xup = 4.5; Yup = 59; Zup = 59; 
Kup = 0; Mup = 11.2; Nup = 11.2;

MRB = [m 0 0 0 0 0; 
       0 m 0 0 0 0; 
       0 0 m 0 0 0; 
       0 0 0 Ix 0 0; 
       0 0 0 0 Iy 0; 
       0 0 0 0 0 Iz];

MA = [Xup 0 0 0 0 0; 
       0 Yup 0 0 0 0; 
       0 0 Zup  0 0 0; 
       0 0 0 Kup 0 0; 
       0 0 0 0 Mup 0; 
       0 0 0 0 0 Nup];

   M	=	MRB + MA;
   invM = inv(M);
   
 Xu = 0.0894;   Xuu = 5.72; 
 Yv = 1.9;      Yvv = 18.58; 
 Zw = 1.9;      Zww = 18.58;
 Kp = 0;        Kpp = 0; 
 Mq = 0.8;      Mqq = 11; 
 Nr = 0.7;      Nrr = 10;  
  

%Efeito das barbatanas como atrito
%Eixo dos Xx
Xvx=0.014; 
Xvxx=0.91; 
lfex = Xvx*(abs(sind(zeta(1))+sind(zeta(2))));
Qfex = Xvxx*(abs(sind(zeta(1))+sind(zeta(2))));

%Eixo dos Yy
Yvy = 0.015;
Yvyy = 0.95;
ltey = Yvy*(abs(cosd(zeta(3))));
Qtey = Yvyy*(abs(cosd(zeta(3))));%;%;

%Eixo dos Zz
Zvz = 0.0001;
Zvzz = 0.01;
lfez = Zvz*(abs(cosd(zeta(1)))+abs(cosd(zeta(2))));
Qfez = Zvzz*(abs(cosd(zeta(1)))+abs(cosd(zeta(2))));

 
 Dl = [Xu;Yv;Zw;Kp;Mq;Nr];
 Dq = [Xuu;Yvv;Zww;Kpp;Mqq;Nrr];
 Dlf = [Xvx; Yvy; Zvz];
 Dqf = [Xvxx; Yvyy; Zvzz];
 
   D11=Xu +(Xuu*abs(Nu(1))) + lfex + (Qfex*abs(Nu(1))); 
   D22=Yv +(Yvv*abs(Nu(2))) + ltey + (Qtey*abs(Nu(2)));
   D33=Zw +(Zww*abs(Nu(3))) + lfez + (Qfez*abs(Nu(3)));
   D44=Kp +(Kpp*abs(Nu(4)));
   D55=Mq +(Mqq*abs(Nu(5)));
   D66=Nr +(Nrr*abs(Nu(6)));   
   D = [
          D11			0				0	    	0	    	0       0
     	   0		   D22			    0			0   		0		0
           0			0			   D33			0           0		0
           0			0	            0		   D44			0		0
           0		    0				0		    0		   D55		0
           0		    0		        0			0			0	   D66];
   
%x0 = 0; y0 = 0; z0 = 0; 
  
   xB = 0;  xG = 0; 
   yB = 0; yG = 0; 
   zB = 0; zG = 0;
   
   P = 450; B = 450;
   F = P-B;  
   
   theta = eta(5);
   phi = eta(4);
   Cent = [xB; xG; zB; zG];
   
   G = [
         F*sin(theta)
       	 F*cos(theta)*sin(phi)
         -F*cos(theta)*cos(phi)
         0
         -(zG*P+zB*B)*sin(theta)*cos(phi) + (xG*P+xB*B)*cos(theta)*cos(phi)
         0]';

dNu = invM*(tau+G'-D*Nu);
% -(yG*P-yB*B)*cos(theta)*cos(phi) + (zG*P-zB*B)*cos(theta)*sin(phi)
% -(xG*P-xB*B)*cos(theta)*sin(phi) - (yG*P-yB*B)*sin(phi)