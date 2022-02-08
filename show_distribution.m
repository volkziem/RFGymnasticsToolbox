% show_distribution()
% The function |show_distribution()| displays the phase-space coordinates |x1| 
% as a cloud of red dots.
function show_distribution(x1,color,vscale)
if nargin<3, vscale=1.22; end
if nargin<2, color='r.'; end % default 'color' is red dots
x1(1,:)=mod(x1(1,:)+pi,2*pi)-pi; % truncate into window
plot(x1(1,:),x1(2,:),color)
xlabel('\phi'); ylabel('d\phi/dt')
axis([-pi,pi,-vscale,vscale]);
set(gca,'xtick',[-pi,-pi/2,0,pi/2,pi],'fontsize',14, ...
     'xticklabels',{'-\pi','-\pi/2','0','\pi/2','\pi'})
end
