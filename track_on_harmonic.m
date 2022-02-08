% track_on_harmonic()
% The function |track_on_harmonic()| receives synchtrotron frequency |Omegas|, 
% the harmonic |nharm|, the phase-space coordinates |x1|, and the time dt to  
% track as input and returns the updated coordinates as |xout.|
function xout=track_on_harmonic(Omegas,nharm,phi0,x1,dt)
x1(1,:)=mod(x1(1,:)-phi0+pi,2*pi)-pi; % truncate into window
for k=1:size(x1,2)
  nb=floor(mod(nharm*(x1(1,k)+pi)/(2*pi),nharm));
  x1(1,k)=(x1(1,k)+pi)*nharm-pi*(2*nb+1);
  x1(:,k)=pendulumtracker(x1(:,k),Omegas,dt);
  x1(1,k)=(x1(1,k)+pi*(2*nb+1))/nharm-pi;
end
%x1(1,:)=x1(1,:)+phi0;
x1(1,:)=mod(x1(1,:)+phi0+pi,2*pi)-pi;
xout=x1;
end