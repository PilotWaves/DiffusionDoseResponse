%InjIC1:  The IC is given as a decaying exponential that jumps to zero
%         after injection stops.

alpha = 4; %  internal diffusion constant
eps = 1; %  boundary diffusion constant
lam = sqrt(eps/alpha);  %  sqrt of the ratio of internal to boundary
                        %  also the eigenvalue of the diffusion eq.
r = [0:.01:1];
t = [0:.01:4];

f = zeros(size(t));
f(1:101) = 10*exp(-eps*t(1:101));

u = f'*cos(lam*r) + (2*(sin(lam)^2)/(sin(2*lam) - 2*lam))*f'*sin(lam*r);

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