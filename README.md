# RFGymnasticsToolbox
Bunch manipulations with the radio-frequency system of a particle accelerator

**Important:** this package requires the elliptic package from https://github.com/moiseevigor/elliptic located in a subdirectory below the present one!

Check out the following papers for the theory behind the code
  - V. Ziemann, *Longitudinal phase-space matching between radio-frequency systems with different harmonic numbers and accelerating voltages,*
    FREIA Report 2021-06, December 2021; see also [arXiv:2112.14085](https://arxiv.org/abs/2112.14085);
  - V. Ziemann, *RF gymnastics with transfer matrices*, FREIA Report 2022-03, February 2022; see also [arXiv:2202.03964](https://arxiv.org/abs/2202.03964).

## Examples
The following example define a sequence of commands, such as creating a distribution, propagating a distribution, and displaying it, 
which is called a **schedule**. Check out the examples, most of the commands are reasonably self-explanatory. All commands are 
explained below on this page.
  - **ex_one_step_transfer.m**, quarter-wave transfer from h1,v1 to h2,v2 via one intermediate state;
  - **ex_bunch_munch.m**, transfer by quarter rotation at lower voltage and subsequent quarter rotation with the original settings;  
  - **ex_phase_jump.m**, transfer by moving the beam into the unstable fixed point and a subsequent 135 degree rotation;
  - **ex_four_step_cascade_with_munch.m**, transfer via four quarter-wave steps to *h4 = 2 h3 = 4 h2 = 8 h1* and a final bunch munch;
  - **ex_four_step_cascade_with_phase_jump.m**, with a final phase jump to shorten the bunch;
  - **ex_four_step_cascade_with_phase_jump_fast.m**, the same as the previous, but without intermediate steps;
  - **ex_filamentation.m**, example of bunch filamentation;
  - **ex_rebunching_simulation.m**, debunch on first harmonic and rebunch on a higher harmonis.
  - **ex_spider.m**, make short bunches in adjacent buckets.

## Support files
 
  - **create_support_functions.m**, must be run once before any other function. It creates a number of anonymous functions that make 
    writing a **schedule** more readable. It creates a file *longitudinal_dynamics_support_functions.mat* that **must** be present in the 
    current subdirectory. 
  - **run_schedule.m(schedule)**, this function receives the **schedule** and performs all calculations. It's the heart of this package.
  - **pendulumtracker.m**, integrates the pendulum equation in terms of Jacobi elliptic functions. Requires the elliptic package from 
    https://github.com/moiseevigor/elliptic located in a subdirectory below the present one (for the fast evaluation of elliptic functions).
  - **track_on_harmonic.m**, shifts and scales the phase appropriately to integrate pendulum equation on a harmonic larger than the first.
  - **show_distribution.m**, displays the distribution of sample particles.
  - **show_distribution_linear.m**, given the longitudinal sigma matrix, this function displays the appropriate phase ellipse.
  - **show_projection_inset.m**, creates a small inset with the longitudinal projection of the particle distribution.
  - **show_projections.m**, creates a separate figure with the projections onto the phase and energy axis.
  - **show_separatrix.m**, displays the separatrix suitable for the harmonic and voltage
  - **fwhm.m**, returns the full-width at half maximum of a distribution.
  - **Makefile**, contains commands to convert the movie file *tmp.avi* to *tmp.mp4* and to display it (requires *ffmpeg* installed). 

## Commands understood by run_schedule()
The **schedule** is an array with six 6 columns and one command for each row, which starts with a *code*, followed by a *repeat* and 
four numbers whose interpretation depend on the code in the first column. The *repeat* column is just a convenient way to break up
long step into a sequence of smaller steps, which makes movies very easy to create.

The first set of commands sets parameters and enables features of the simulation.
  - **set_parameters(Npart,Omegas)** is used to define the number of particles *Npart* used in the simulation and the reference synchrotron
    frequency *Omegas*. It returns [100,1,Npart,Omegas,0,0]; Note that Omegas=0.5 at *h=1,v=1* causes the separatrix to have a height of 
    unity, thus setting a natural scale for the bucket half-height.
  - **set_vscale(vscale)** set the vertical scale of the plots. It returns *[200,1,vscale,0,0,0];*
  
  - **set_adiabatic(Nturn)** sets the number of turns *Nturn* to propagate the particles when simulating an adiabatic
    change of the voltage. It returns [300,1,Nturn,0,0,0];
  - **set_pause(time)** sets the waiting time between plots displayed. It returns [400,1,time,0,0,0];
  - **show_distribution(r,g,b)** displays the particle distribution. It returns [900,1,r,g,b,0]; 
  - **show_projections**  displays the projections of the particle distribution onto the horizontal and vertical axis. It
    returns [901,1,0,0,0,0];
  - **new_figure** starts a new figure. It returns [902,1,0,0,0,0]; 
  - **save_distribution(n)** saves the current particle distribution into file *dist_x1.n*. It returns [903,1,n,0,0,0]; 
  - **load_distribution(n)** loads the previously-saved distribution from file *dist_x1.n*. It returns [904,1,n,0,0,0]; 
  - **start_movie(fps)** starts recording a movie with frame rate *fps*. The file is called *tmp.avi*. It returns [905,1,fps,0,0,0];
  - **stop_movie** stops recoring the move. It returns [906,1,0,0,0,0];
  - **save_image** saves the current image to a file. It returns [907,1,0,0,0,0];
  - **save_images** causes all images to be automatically saved. It returns [908,1,1,0,0,0];
  - **save_fwhm** saves the full-width at half-maximum in a file for later display. It returns [909,1,1,0,0,0];
  - **show_inset(xpos,ypos)** displays the longitudinal projection of the distribution in a small inset on the bottom right of
    the current plot. It returns a [910,1,xpos,ypos,0,0];
  - **linear_transport** enables the transport of the particles with the transfer matrices discussed in the papers mentioned
    above, normally shown as the green dots. It returns [911,1,0,0,0,0];
  - **sigma_transport** enables the transport of the beam (sigma) matrix with the transfer matrices mentioned in the papers above,
    normally shown as the blue ellipse. It returns [912,1,0,0,0,0];

The second set of parameters actually manipulates the particle distribution
  - **init_dist(h,v,sigphi,trunc)** returns the following row *[1,1,h,v,sigphi,trunc]*, which initializes the particle distribution with
    a bunch, matched to harmonic *h* and voltage *v*, having a length of *sigphi* degrees and the particles are sampled from a Gaussian
    that is truncated a *trunc* sigmas. If trunc is positive, all buckets are filled, if it is negative ony the one at phase zero.
  - **prop_dist(n,h,v,phi,dt)** moves the distribution forward in *n* steps, each of duration *dt* at harmonic *h* and voltage *v* with 
    phase shifted by *phi*. It returns [2, n, h, v, phi, dt]; Note that *dt* refers to the fraction of the revolution time **at** the 
    harmonic and voltage given. Also *phi* refers to phase at harmonic *h*.
  - **move_dist(dphi,denergy)** moves all particles by *dph* and *denergy*. It returns [4,1,dphi,denergy,0,0];
  - **prop_adiabatic(h1,v1,dv,v2)** simulates an adiabatic (very slow) change of the RF voltage. It propagates all particles with a 
    RF system operating at harmonic *h1* and increases the voltage in steps of *dv* from *v1* to *v2*. At each step *Nturn* 
    (set with **set_adiabatic()**) synchrotron oscillations are performed before incrementing the voltage. It returns [10, 1, h1, v1, dv, v2]; 
