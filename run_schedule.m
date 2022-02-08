% run_schedule.m, steps though the schedule and updates the distribution
function run_schedule(schedule,figpos)
Omegas=0.25; Npart=1000; pause_time=0.001; vscale=1.9; % default values
Ts=2*pi/Omegas;
if nargin<2, figpos=[2300,200,1401,900]; end
basename=inputname(1);
load('longitudinal_dynamics_support_functions.mat')
do_linear=false;
do_map=false;
stop_it=false;
autoplot=false;
save_fwhm=false;
record_video=false;
tic
image_counter=0;
nlines=size(schedule,1);
for line=1:nlines        % Loop over schedule
  for seg=1:schedule(line,2)
    switch schedule(line,1)
      case 0
        stop_it=true;
        %return
      case 1   % initial distribution
        h=schedule(line,3);
        v=schedule(line,4);
        sigphi=schedule(line,5);    
        truncation=schedule(line,6);
        pd=makedist('Normal');
        trunc=truncate(pd,-abs(truncation),abs(truncation));
        x1=random(trunc,size(x1))*sigphi*pi/(180*h);
        x1(2,:)=x1(2,:)*h*sqrt(v*h)*Omegas;
        Ndist=Npart/h; n0=1;
        if do_linear, x2=x1; end       
        if truncation > 0
          for nb=1:h
            x1(1,n0:n0+Ndist-1)=x1(1,n0:n0+Ndist-1)+nb*2*pi/h-pi-mod(h,2)*pi/h;
            n0=n0+Ndist;
          end        
        end
        if do_map   % initialize the sigma matrix
          sigma3=zeros(2,2);
          sigma3(1,1)=(sigphi*pi/(180*h))^2;
          sigma3(2,2)=sigma3(1,1)*v*h^3*Omegas^2;
        end
      case 2
        h=schedule(line,3);
        v=schedule(line,4);
        T0=2*pi/(sqrt(v*h)*Omegas);
        phi0=schedule(line,5)/h;     
        if ~mod(h,2), phi0=phi0+pi/h; end  %  even-odd harmonics
        dt=schedule(line,6);       
        x1=track_on_harmonic(sqrt(v*h)*Omegas,h,phi0,x1,dt*T0);
        hold off
        show_distribution(x1); show_separatrix(sqrt(v*h)*Omegas,h,phi0)
        if do_linear   % linear transport with matrices
          unstable=0; if abs(schedule(line,5)-pi)<1e-3, unstable=1; end
          if unstable==0
            x2=Rs(Omegas,h,v,dt*T0)*x2;
          else
            x2=Ru(Omegas,h,v,dt*T0)*x2;
          end
          show_distribution(x2,'g.');
        end
        if do_map
          if abs(schedule(line,5)-pi)<1e-3
             RR=Ru(Omegas,h,v,dt*T0);
          else
             RR=Rs(Omegas,h,v,dt*T0);
          end
          sigma3=RR*sigma3*RR';
          show_distribution_linear(sigma3)
        end
        ylim([-vscale,vscale]) 
        text(-2.8,-0.9*vscale,['h = ',num2str(h),',   v = ',num2str(v,'%7.4f'),',       ', ...
          num2str(seg),'/',num2str(schedule(line,2))],'FontSize',16)
        pause(pause_time)
        if record_video, writeVideo(vidObj, getframe(gca)); end
        if save_fwhm
          ifwhm=ifwhm+1;
          [psi,edges]=histcounts(x1(1,:),50);
          fwhm_saved(ifwhm,1)=fwhm(psi)*(edges(2)-edges(1));   
          fwhm_saved(ifwhm,2)=h;
          fwhm_saved(ifwhm,3)=v;        
        end
      case 3    % damping from electron cooling
        damping_time=schedule(line,3);
        dt=schedule(line,6);
        x1(2,:)=x1(2,:)*exp(-dt/damping_time);
        if do_linear, x2(2,:)=x2(2,:)*exp(-dt/damping_time); end
        hold off
        show_distribution(x1); show_separatrix(sqrt(v*h)*Omegas,h,phi0)
        ylim([-vscale,vscale])
        pause(pause_time)
        if record_video, writeVideo(vidObj, getframe(gca)); end
      case 4    % move distribution in phase space
        x1=x1+[schedule(line,3);schedule(line,4)];
      case 10   % adiabatically change voltage
        h=schedule(line,3);
        vstart=schedule(line,4);
        dv=schedule(line,5);
        vend=schedule(line,6);
        phi0=0; if ~mod(h,2), phi0=phi0+pi/h; end  %  even-odd harmonics
        for v=vstart:dv:vend
          x1=track_on_harmonic(sqrt(v*h)*Omegas,h,phi0,x1,Nturn*Ts);
          hold off
          show_distribution(x1); show_separatrix(sqrt(v*h)*Omegas,h,phi0)
          ylim([-vscale,vscale])
          text(-2.8,-0.9*vscale,['v = ',num2str(v,'%7.4f'),' -> ',num2str(vend,'%7.4f')],'FontSize',16)
          pause(pause_time)
          if record_video, writeVideo(vidObj, getframe(gca)); end
        end
      case 100
        Npart=schedule(line,3);
        x1=zeros(2,Npart);
        Omegas=schedule(line,4); Ts=2*pi/Omegas;
        phi0=schedule(line,5);
      case 200
        vscale=schedule(line,3);
      case 300
        Nturn=schedule(line,3);
      case 400
        pause_time=schedule(line,3); 
      case 900    % show distribution and separatrix
        if schedule(line,5)==1, color='b.'; elseif schedule(line,4)==1, color='g.'; else color='r.'; end
        figure; set(gcf,'Position',figpos);
        phi0=0; if ~mod(h,2), phi0=phi0+pi/h; end  %  even-odd harmonics
        show_distribution(x1,color); show_separatrix(sqrt(v*h)*Omegas,h,phi0)
        ylim([-vscale,vscale])
      case 901    % display histogram
        figure; show_projections(x1)
        [psi,edges]=histcounts(x1(1,:),100);
        fff=fwhm(psi)*(edges(2)-edges(1));
      case 902    % start a new figure
        figure; set(gcf,'Position',figpos);
      case 903    % save distribution to file 'dist_x1.nnn'
        nnn=schedule(line,3);
        fn=sprintf('dist_x1_%03d.mat',nnn);
        save(fn,'x1')
      case 904    % load distribution from file 'dist_x1.nnn'
        nnn=schedule(line,3);
        fn=sprintf('dist_x1_%03d.mat',nnn);
        load(fn);
        Npart=size(x1,2);
      case 905 % start movie
        fps=schedule(line,3);
        if fps==0, fps=20; end
 %      vidObj = VideoWriter(sprintf('%s.avi',basename));
        vidObj = VideoWriter('tmp.avi'); 
        vidObj.Quality = 50;
        vidObj.FrameRate = fps;
        open(vidObj);
        record_video=true;
      case 906
        close(vidObj);
        record_video=false;
      case 907
        fn=sprintf('%s_%03d.png',basename,image_counter);
        print(fn,'-dpng','-r0');
        image_counter=image_counter+1;
      case 908
        if schedule(line,3)==1
          autoplot=true;
        else
          autoplot=false;
        end
      case 909
        if schedule(line,3)==1
          save_fwhm=true;
          ifwhm=0;
          fwhm_saved=zeros(1000,3);
        else
          save_fwhm=false;
        end
      case 910 % show projection on inset, only works at the end
        xpos=schedule(line,3);
        ypos=schedule(line,4);
        show_projection_inset(x1,100,[xpos,ypos,0.2,0.2])
%       show_projection_inset(x1);
      case 911 % do_linear
        do_linear=true;
      case 912
        do_map=true;
    end
  end
  if autoplot
    switch schedule(line,1)
      case {2,3,10,900,910}
        fn=sprintf('%s_%03d.png',basename,image_counter);
        image_counter=image_counter+1;
        print(fn,'-dpng','-r0');
    end
    if schedule(line,1)==910 && line<size(schedule,1)  % not at the end
      figure; set(gcf,'Position',figpos)
    end
  end
  if stop_it, break; end
end

if save_fwhm
  figure
  subplot(2,1,1);
  plot(1:ifwhm,fwhm_saved(1:ifwhm,2),'k','LineWidth',2);
  xlim([1,ifwhm]); set(gca,'FontSize',16)
  xlabel('a.u.'); ylabel('h');
  subplot(2,1,2);
  plot(1:ifwhm,fwhm_saved(1:ifwhm,3),'k','LineWidth',2);
  xlim([1,ifwhm]); set(gca,'FontSize',16)
  xlabel('a.u.'); ylabel('v');
  set(gcf,'Position',figpos)
  fn=sprintf('%s_hv.png',basename); print(fn,'-dpng','-r0');
  figure
  plot(1:ifwhm,fwhm_saved(1:ifwhm,1)/(2*pi),'k','LineWidth',2);
  xlim([1,ifwhm]); ylim([0,min(0.1,max(fwhm_saved(1:ifwhm,1)/(2*pi)))]);
  xlabel('a.u.'); ylabel('FWHM [Fraction of circumference]')
  legend(['FWHM(end) = ',num2str(fwhm_saved(ifwhm,1)/(2*pi),4)]);
  set(gca,'FontSize',16)
  set(gcf,'Position',figpos)
  fn=sprintf('%s_fwhm.png',basename); print(fn,'-dpng','-r0');
end
toc
if record_video, close(vidObj); end

end