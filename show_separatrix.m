% show_separatrix()
% The function |show_separatrix()| displays the separatrix at the harmonic |nharm| 
% and sunchrotron frequency |Omegas|. 
function show_separatrix(Omegas,nharm,phi0)
hold on
if nargin==2, phi0=0; end
phase0=(1+mod(nharm,2))*pi/2;
phi=-pi:0.01:pi; separatrix=2*Omegas*cos(0.5*(phi-phi0)*nharm+phase0);
plot(phi,separatrix,'k',phi,-separatrix,'k');
end
