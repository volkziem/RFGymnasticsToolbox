% filamentation.m
clear; close all;
load('longitudinal_dynamics_support_functions.mat')
addpath ./elliptic
Omegas=0.25;
sigphi0=10;
Npart=10000;
%%                  define the schedule
h1=2; v1=1;
filamentation_schedule=[
  set_parameters(Npart,Omegas);
  set_vscale(0.9);
  set_pause(0.001);
  save_images();
  start_movie(20);
  init_dist(h1,v1,sigphi0,-3);
  move_dist(0.5*pi/h1,0.0); % wrong injection phase
% move_dist(pi/h1,0.0);     % move to unstable fixed point
  show_distribution(0,1,0); 
  prop_dist(100, h1, v1,  0, 0.1);
  show_inset(0.69,0.16);
  ];
%%
run_schedule(filamentation_schedule);
