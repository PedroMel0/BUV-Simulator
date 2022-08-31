clear  
T = 1/18; 
t = T;
Tf = 100;              %Tempo de Simulação
Nu = [0 0 0 0 0 0]' ; %Estado de velocidade
eta = [0 0 0 0 0 0]' ;%Estado de Posição
tau = [0 0 0 0 0 0]';
N = ceil(Tf/T);	
rad = 180/pi;
global Dados 
Dados = zeros (N,28);

global Parametros
Parametros = zeros (1,35); 

     % Ciclo principal (main):
for k=1:N
     % Actuation:
    
     [sigma_L, sigma_R, sigma_T] = openLoopController(t);
     % [sigma_L, sigma_R, sigma_T] = closedLoopController(setpoint, eta, sigma_L, sigma_R, sigma_T, t);
     zeta = fins(sigma_L, sigma_R, sigma_T, t);
     
     % Disturbances:
     %vCurr = seaCurrents(t);
     
     % Forces and accelerations (Body frame):
     tau = thrust(sigma_L, sigma_R, sigma_T, t);
     [dNu, M, D, F, Dl, Dq, Dlf, Dqf, Cent] = dynamics( Nu, eta, zeta, tau);
 
     % Logging, plotting, etc:
     logg(tau, dNu, Nu, eta, sigma_L, sigma_R, sigma_T, zeta, t, k);   %vCurr
     
     % Numerical integration and BUV next state
     t = t + T;
     Nu = integration(dNu, Nu, T);     %Velocity
     dEta = body2ned(Nu, eta); %vCurr
     eta = integration(dEta, eta, T);  %Position
    
         
     % Termination
     %if( t > Tf)
%            break;
%      end
end

right(M, D, F, Dl, Dq, Dlf, Dqf, zeta, Cent)
save 'ParametrosC.txt' Parametros -ascii;


save 'dataC.txt' Dados -ascii;


BUV = figure;              %plot das figuras
subplot(3,2,[1 3]); plot(Dados(:,8),Dados(:,9),'r'); xlabel('x [m]');  ylabel('y [m]'); grid;
subplot(3,2,2); plot3(Dados(:,8),Dados(:,9),Dados(:,10),'r'); xlabel('x [m]');  ylabel('y [m]'); zlabel('z [m]'); grid;
subplot(3,2,5); plot(Dados(:,1),Dados(:,2),'g',Dados(:,1),Dados(:,4),'b');  xlabel('t [s]'); ylabel('u, w [m/s]'); grid; legend('u','w');
subplot(3,2,4); plot(Dados(:,1),Dados(:,12)*rad,'r', Dados(:,1),Dados(:,13)*rad,'c'); xlabel('t [s]'); ylabel('\theta, \psi [deg]'); grid; legend('\theta', '\psi');
subplot(3,2,6); plot(Dados(:,1),Dados(:,14),'m', Dados(:,1),Dados(:,19),'k'); xlabel('t [s]'); ylabel('X, N [N]'); grid; legend('X', 'N');
