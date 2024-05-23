%InjIC1:  The IC is given as a decaying exponential that jumps to zero
%         after injection stops.

alpha = 4; %  internal diffusion constant

r = [0:.01:1];
t = [0:.01:4];

Psi0 = 1;
r0 = 1/4;

fcn = @(x) exp(-1./(1-x.^2/r0^2)).*sin(x/sqrt(alpha));
I = integral(fcn,0,r0);

A = Psi0;
B = 4*Psi0*(exp(1)*I - sqrt(alpha)*sin(sqrt(alpha))^2)/(2-sqrt(alpha)*sin(2*sqrt(alpha)));
u = exp(-t)'*(A*cos(r/sqrt(alpha)) + B*sin(r/sqrt(alpha)));

x = r'*cos([0:pi/50:2*pi]);
y = r'*sin([0:pi/50:2*pi]);
z = u(1,:)'*ones(size(r));
% surf(x,y,u)
col = z;  % This is the color, vary with u in this case.
surface(x,y,z,col,...
        'facecol','no',...
        'edgecol','interp',...
        'linew',5);
axis([-1.5 1.5 -1.5 1.5])
axis off