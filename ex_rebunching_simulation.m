% rebunching_simulation.m
clear; close all;
load('longitudinal_dynamics_support_functions.mat')
addpath ./elliptic
Omegas=0.25;
sigphi0=10;
Npart=1000;
%%
h1=1; v1=1;
h2=5; v2=1;
rebunching_schedule=[
  set_parameters(Npart,Omegas);
  set_vscale(1.4);
  set_pause(0.001);
  save_images();
  start_movie(20);
  set_adiabatic(10000);
  init_dist(h1,v1,sigphi0,-3);
  show_distribution(); 
  prop_adiabatic(h1,v1,-0.005,0); % slow adiabatic reduction of voltage
  prop_adiabatic(h2,0,0.005,v2);  % increase again on h2 
  2, 20, h2,v2,0,0.01;            % 
  show_inset(0.69,0.16);
];
%%
run_schedule(rebunching_schedule);
