% one_step_transfer.m, Section 3.1 and 3.2
clear; close all;
load('longitudinal_dynamics_support_functions.mat')
addpath ./elliptic
Omegas=0.25;
sigphi0=10;
Npart=1000;
%%
% single transfer, either on h1 or on h2
h1=1; v1=1; 
h3=2; v3=3;
v2a=sqrt(v1*v3)*(h1/h3)^1.5;  % eq.17
v2b=sqrt(v1*v3)*(h3/h1)^1.5;  % eq.18
one_step_transfer_schedule=[
  set_parameters(Npart,Omegas);
  set_vscale(1.7);
  set_pause(0.001);
  save_images();
% start_movie(20);
  sigma_transport();
  linear_transport();
  init_dist(h1,v1,sigphi0,-3);     
  show_distribution(1,0,0); 
  2, 50, h1, v1,   0, 0.01;     % equilibrium beam stay unchanged
  2, 25, h3, v2a,  0, 0.01;     % transfer on h2, eq.17
%  2, 25, h1, v2b,  0, 0.01;     % transfer on h1, eq.18
  2, 50, h3, v3,   0, 0.01;
  show_inset(0.69,0.16);
  ];
%%
run_schedule(one_step_transfer_schedule);
