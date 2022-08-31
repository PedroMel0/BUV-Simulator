function logg (tau, dNu, Nu, eta, sigma_L, sigma_R, sigma_T, zeta, t, k)
global Dados
Dados(k,:) = [t, Nu(1), Nu(2), Nu(3), Nu(4), Nu(5), Nu(6), eta(1), eta(2), eta(3), eta(4), eta(5), eta(6), tau(1), tau(2), tau(3), tau(4), tau(5), tau(6), dNu(1), dNu(2), dNu(3), dNu(4), dNu(5), dNu(6), zeta(1), zeta(2), zeta(3)];

end 
