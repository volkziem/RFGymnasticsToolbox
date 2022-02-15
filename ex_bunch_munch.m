% bunch_munch.m, Section 3.3 
clear; close all;
load('longitudinal_dynamics_support_functions.mat')
addpath ./elliptic
Omegas=0.25;
phi0=10;
Npart=1000;
%% one bunch munch from h=1,v=1 to h2=1,v=5
h1=1; v1=1; 
h2=1; v2=5;
vhat=v1*sqrt(v1/v2)*(h1/h2)^1.5;
bunch_munch_schedule=[
  set_parameters(Npart,Omegas);
  set_vscale(1.4);
  set_pause(0.001);
  save_images();
% start_movie(20);
  sigma_transport();
  linear_transport();
  init_dist(h1,v1,phi0,-3);
  show_distribution(1,0,0); 
  2, 70, h1, v1,   0, 0.01; 
  2, 25, h1, vhat, 0, 0.01; 
  2, 25, h1, v1,   0, 0.01; 
  2, 30, h2, v2,   0, 0.01;
  ];

%%
run_schedule(bunch_munch_schedule);
