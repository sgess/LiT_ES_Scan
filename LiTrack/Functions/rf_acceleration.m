function [beam_out, Nb, wake_out, rf_out] = rf_acceleration(beam_in,Nb,Qp,Nbin,params)

SI_consts;

[Z,ind] = sort(beam_in(:,1));
Z0 = mean(Z);
E = beam_in(ind,2);
E0 = mean(E);

E_acc = params(2);
phi   = params(3)*pi/180;
rf    = params(4);
fb    = params(5);
Lacc  = params(6);



[dE_wake,zc_wake] = calc_wake(Z,Lacc,Qp,Nbin);  % convolve wake function with beam in Nbin histogram
int_wake = interp1(zc_wake,dE_wake,Z,'linear');	% inerpolate wake response onto particles
wakeloss = 1E-3*mean(int_wake);                 % mean wake loss [GeV]
wake_out = [zc_wake dE_wake];

if fb
    Egain = (E_acc - E0 - wakeloss)/cos(phi+SI_sband_k*Z0);
else
    Egain = E_acc;
end

Erf = Egain*cos(phi + SI_sband_k*Z);
rf_shape = Egain*cos(phi + SI_sband_k*zc_wake);
rf_out = [zc_wake rf_shape];

E = E + Erf + 1E-3*int_wake;

beam_out = [Z E];

Nb = length(beam_out);