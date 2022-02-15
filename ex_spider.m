% ex_spider.m
clear; close all;
load('longitudinal_dynamics_support_functions.mat')
addpath ./elliptic
Omegas=0.25;
phi0=10;
Npart=1000;
%%                  define the schedule
h1=3; v1=1;
phase_jump_schedule=[
  set_parameters(Npart,Omegas);
  set_vscale(1.2);
% set_adiabatic(10000);
  set_pause(0.001);
%  save_images();
%  sigma_transport();
%  linear_transport();
% save_fwhm();
  start_movie(20);
  init_dist(h1,v1,10,-3);
  show_distribution(1,0,0); 
  prop_dist(25, h1, v1,  0, 0.01);
  prop_dist(150, h1, v1, pi, 0.01); 
  prop_dist(38, h1, v1,  0, 0.01); 
  show_inset(0.69,0.16);
% show_projections();
  ];
%%
run_schedule(phase_jump_schedule);
