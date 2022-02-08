% show_distribution_linear.m
function show_distribution_linear(sig)
emit=sqrt(det(sig)); beta=sig(1,1)/emit; alfa=-sig(1,2)/emit;
R=[sqrt(beta),0;-alfa/sqrt(beta),1/sqrt(beta)];
phi=0:pi/50:2*pi; 
y=sqrt(emit)*R*[cos(phi);sin(phi)];
plot(y(1,:),y(2,:),'b','LineWidth',2)
end