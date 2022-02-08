% creates an inset 
function show_projection_inset(x1,nbin,pos)
if nargin<3, pos=[0.7,0.7,0.2,0.2]; end
if nargin==1, nbin=100; end
axes('Position',pos); box on
histogram(x1(1,:),nbin); xlabel('\phi'); % xlim([-pi,pi])
[psi,edges]=histcounts(x1(1,:),nbin);
fff=fwhm(psi)*(edges(2)-edges(1));
legend(['rms,fwhm = ',num2str(std(x1(1,:)),3),',',num2str(fff,3)])
end