% show_projections()
function show_projections(x1,nbin)
if nargin==1, nbin=100; end
subplot(2,1,1); histogram(x1(1,:),nbin); xlabel('\phi')
[psi,edges]=histcounts(x1(1,:),nbin);
fff=fwhm(psi)*(edges(2)-edges(1));
legend(['rms,fwhm = ',num2str(std(x1(1,:)),3),',',num2str(fff,3)])
subplot(2,1,2); histogram(x1(2,:),nbin); xlabel('d\phi/dt')
legend(['rms = ',num2str(std(x1(2,:)),3)])
title(['Fraction of circumference = ',num2str(fff/(2*pi),3)])
end

