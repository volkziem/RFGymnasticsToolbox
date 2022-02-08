% create_support_functions.m, stores the anonymous support functions 
% in the file longitudinal_dynamics_support_functions.mat
clear
init_dist=@(h,v,sigphi,trunc)[1,1,h,v,sigphi,trunc];
prop_dist=@(n,h,v,phi,dt)[2, n, h, v, phi, dt]; 
move_dist=@(dphi,denergy)[4,1,dphi,denergy,0,0];
prop_adiabatic=@(h1,v1,dv,v2)[10, 1, h1, v1, dv, v2]; 
set_parameters=@(Npart,Omegas)[100,1,Npart,Omegas,0,0];
set_vscale=@(vscale)[200,1,vscale,0,0,0];
set_adiabatic=@(Nturn)[300,1,Nturn,0,0,0];
set_pause=@(time)[400,1,time,0,0,0];
show_distribution=@(r,g,b)[900,1,r,g,b,0]; 
show_projections=[901,1,0,0,0,0];
new_figure=[902,1,0,0,0,0]; 
save_distribution=@(n)[903,1,n,0,0,0]; 
load_distribution=@(n)[904,1,n,0,0,0]; 
start_movie=@(fps)[905,1,fps,0,0,0];
stop_movie=[906,1,0,0,0,0];
save_image=[907,1,0,0,0,0];
save_images=[908,1,1,0,0,0];
save_fwhm=[909,1,1,0,0,0];
show_inset=@(xpos,ypos)[910,1,xpos,ypos,0,0];
linear_transport=[911,1,0,0,0,0];
sigma_transport=[912,1,0,0,0,0];

% rotation around the stable fixed point
Rs=@(Omegas,h,v,t)[cos(sqrt(v*h)*Omegas*t), ...
  sin(sqrt(v*h)*Omegas*t)/(h*sqrt(v*h)*Omegas); ...
  -h*sqrt(v*h)*Omegas*sin(sqrt(v*h)*Omegas*t), ...
  cos(sqrt(v*h)*Omegas*t)];

% rotation around the unstable fixed point
Ru=@(Omegas,h,v,t)[cosh(sqrt(v*h)*Omegas*t), ...
  sinh(sqrt(v*h)*Omegas*t)/(h*sqrt(v*h)*Omegas); ...
  h*sqrt(v*h)*Omegas*sinh(sqrt(v*h)*Omegas*t), ...
  cosh(sqrt(v*h)*Omegas*t)];

sigini=@(h,v)[1/(h*sqrt(v*h)*Omegas),0;0,h*sqrt(h*v)*Omegas];

save('longitudinal_dynamics_support_functions.mat')