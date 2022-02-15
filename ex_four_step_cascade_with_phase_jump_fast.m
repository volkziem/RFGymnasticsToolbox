% Four_step_cascade_with_munch.m
clear; close all;
load('longitudinal_dynamics_support_functions.mat')
addpath ./elliptic
Omegas=0.25;   % Reference synchrotron tune
sigphi0=10;    % Bunch length in degree
Npart=10000;   % Number of particles
%%
h1=1; v1=1; 
h2=2; v2=1;
vhat2=sqrt(v1*v2)*(h1/h2)^1.5;  % eq.17
h3=4; v3=1;
vhat3=sqrt(v2*v3)*(h2/h3)^1.5;
h4=8; v4=1;
vhat4=sqrt(v3*v4)*(h3/h4)^1.5;

four_step_cascade_schedule=[
  set_parameters(Npart,Omegas);
  set_vscale(1.9);
  set_pause(0.001);
  save_images();
  sigma_transport();   % blue ellipse
  linear_transport();  % green dots
% save_fwhm();
% start_movie(20);
  init_dist(h1,v1,sigphi0,-3);
  show_distribution(1,0,0); 
  2, 1, h1, v1,   0, 0.1; 
  2, 1, h2, vhat2,0, 0.25; 
  2, 1, h2, v2,   0, 0.1;
  2, 1, h3, vhat3,0, 0.25; 
  2, 1, h3, v3,   0, 0.1;
  2, 1, h4, vhat4,0, 0.25; 
  2, 1, h4, v4,   0, 0.1
  show_inset(0.69,0.16);
  prop_dist(1, h4, v4, pi, 0.15); 
  prop_dist(1, h4, v4,  0, 0.38); 
  show_inset(0.69,0.16);
  ];

%%
run_schedule(four_step_cascade_schedule);
