%% Ler dados produzidos pelo simulador
clear dados

dados = importdata("C:\Users\pdias\Desktop\Tese\Programação\BUV_V2\datab.txt");



% dados é uma matriz que para cada linha tem a seguinte informação:
% [t Nu1 Nu2 ... Nu6 eta1 eta2 ... eta6 tau1 ... tau6 dNu1 dNu2 ... dNu6]

%% Ler parâmetros reais da simulação
Theta = importdata("C:\Users\pdias\Desktop\Tese\Programação\BUV_V2\Parametrosb.txt")';

Theta = Theta([1:3,5:6,13:15,17:21,23:31]);


%% Parâmetros para a identificação
T = 50; %Tempo de simulação (segundos)
rng('shuffle') %valores produzidos são sempre diferentes cada vez que o script é corrido
WN1 = 1e-3;  %Desvio padrão na Velocidade (Nu)
WN2 = 0;  %Desvio Padrão na AceleraÃ§Ã£o (dNu)
WN3 = 0;  %Desvio padrão na Velocidade quadrática   (Nu*(abs(Nu))
WN4 = 0;  %Desvio padrão na Atuação   (tau)
WN5 = 0;  %Desvio padrão no efeito das barbatanas (linear)    
WN6 = 0;  %Desvio padrão no efeito das barbatanas (quadrático)

N = 18*T; 

RMSE = zeros(1,N);
% Se eu quiser ver a evolução do erro para parâmetros individuais:
RMSE_M1 = zeros(1,N);
RMSE_M2 = zeros(1,N);


C = [];
d = [];


for k = 1:N
    t  = dados(k,1);

    Nu1  = dados(k,2) + WN1*randn;
    Nu2  = dados(k,3) + WN1*randn;
    Nu3  = dados(k,4) + WN1*randn;
    Nu4  = dados(k,5) + WN1*randn;
    Nu5  = dados(k,6) + WN1*randn;
    Nu6  = dados(k,7) + WN1*randn;
%    NNu = [Nu1,Nu2,Nu3,Nu4,Nu5,Nu6]';

    % QNu1 = abs(Nu1)*Nu1;
    QNu1  = abs(dados(k,2))*dados(k,2) + WN3*randn;
    QNu2  = abs(dados(k,3))*dados(k,3) + WN3*randn;
    QNu3  = abs(dados(k,4))*dados(k,4) + WN3*randn;
    QNu4  = abs(dados(k,5))*dados(k,5) + WN3*randn;
    QNu5  = abs(dados(k,6))*dados(k,6) + WN3*randn;
    QNu6  = abs(dados(k,7))*dados(k,7) + WN3*randn;

    %eta1  = dados(k,8);
    %eta2  = dados(k,9);
    %eta3  = dados(k,10);
    eta4  = dados(k,11);
    eta5  = dados(k,12);
    %eta6  = dados(k,13);

    tau1  = dados(k,14) + WN4*randn;
    tau2  = dados(k,15) + WN4*randn;
    tau3  = dados(k,16) + WN4*randn;
    tau4  = dados(k,17) + WN4*randn;
    tau5  = dados(k,18) + WN4*randn;
    tau6  = dados(k,19) + WN4*randn;
%    Ntau = [tau1,tau2,tau3,tau4,tau5,tau6]';

    dNu1 = dados(k,20) + WN2*randn;
    dNu2 = dados(k,21) + WN2*randn;
    dNu3 = dados(k,22) + WN2*randn;
    dNu4 = dados(k,23) + WN2*randn;
    dNu5 = dados(k,24) + WN2*randn;
    dNu6 = dados(k,25) + WN2*randn;
    
    zeta1 = dados(k,26);
    zeta2 = dados(k,27);
    zeta3 = dados(k,28);
    
  
    bNu1  = Nu1*((abs(sind(zeta1)+sind(zeta2)))); 
    bNu2  = Nu2*(abs(cosd(zeta3))); 
    bNu3  = Nu3*(abs(cosd(zeta1))+abs(cosd(zeta2))); 

    bQNu1  = QNu1*((abs(sind(zeta1)+sind(zeta2)))); 
    bQNu2  = QNu2*((abs(cosd(zeta3)))); 
    bQNu3  = QNu3*((abs(cosd(zeta1))+abs(cosd(zeta2)))); 
    

    g1 = sin(eta5);
    g2 = cos(eta5)*sin(eta4);
    g3 = -cos(eta5)*cos(eta4);
%    Ng = [g1,g2,g3,0,0,0]';

    V = [dNu1 0 0 0 0 Nu1 0 0 0 0 QNu1 0 0 0 0 bNu1 0    0    bQNu1 0     0     g1;
         0 dNu2 0 0 0 0 Nu2 0 0 0 0 QNu2 0 0 0 0    bNu2 0    0     bQNu2 0     g2;
         0 0 dNu3 0 0 0 0 Nu3 0 0 0 0 QNu3 0 0 0    0    bNu3 0     0     bQNu3 g3;
         0 0 0 dNu5 0 0 0 0 Nu5 0 0 0 0 QNu5 0 0    0    0    0     0     0     0;
         0 0 0 0 dNu6 0 0 0 0 Nu6 0 0 0 0 QNu6 0    0    0    0     0     0     0;
        ];

    T = [tau1;
         tau2;
         tau3;
         tau5;
         tau6;   
        ];
    
    C = [C; V];
    d = [d; T];
    
    % Valores estimados para os parâmetros na iteração k
    estTheta = C\d;
    
    % RMSE
    RMSE(k) = sqrt((estTheta-Theta)'*(estTheta-Theta)/length(Theta));
    
    % Se eu quiser fazer o plot do erro para apenas um parâmetro (M1 e M3,
    % por exemplo):
    RMSE_M1(k) = abs(estTheta(1)-Theta(1));
    RMSE_M2(k) = abs(estTheta(2)-Theta(2));
end    

[Theta'; estTheta']

figure; plot(RMSE); legend('RMSE com SNR alto'); 
xlabel('Número de Amostras');  ylabel('Roat Mean Square Error'); grid;
% figure; plot(RMSE_M1);
% figure; plot(RMSE_M3);



RMSE3 = RMSE;