%Ethanol diffusion in tumor
tic

dr = 0.01;
dt = dr^2/2;
nu = dt/dr;
mu = dt/dr^2;
T = 4;
X = 1;
N = round(T/dt + 1);
M = round(X/dr + 1);

eps = 1/10;
U_thresh = 0.25;

r = [0:dr:1];
U = zeros(N,M);
width = 1/4;
r1 = round(length(r)*width);
height = 10/(r(r1)*width);
U(1,1:r1 - 1) = exp(1 - 1./(1 - r(1:r1 - 1)/r(r1)))*(height);

 writerObj = VideoWriter('EthanolBump.avi');
 writerObj.FrameRate = round(N/1000);
 open(writerObj);

%Plotting Initial Condition

hfig = figure;
pos = get(hfig,'position');
set(hfig,'position',pos.*[.5 1 2 1]);
   
subplot(1,2,1);
   x = r'*cos([0:2*pi/(length(r)-1):2*pi]);
y = r'*sin([0:2*pi/(length(r)-1):2*pi]);
z = U(1,:)'*ones(size(r))/max(U(1,:));
col = 1-z;  % This is the color, vary with u in this case.
surf(x,y,z,col,...
        'facecol','no',...
        'edgecol','interp',...
        'linew',5);
axis([-1.5 1.5 -1.5 1.5],'square');
title('Radial Diffusion');
axis off;

subplot(1,2,2);
h = plot(r,U(1,:),'b',-r,flipud(U(1,:)),'b',[-1,1],[0.25 0.25],'r--');
set(h(1),'Linewidth',3);
set(h(2),'Linewidth',3);
set(h(3),'Linewidth',2);
alw = 0.75;    % AxesLineWidth
fsz = 14;      % Fontsize
xlabel('Position');
ylabel('Concentration');
title('Concentration Profile');
%axis([-1 1 0 height]);

   %pause
   
    frame = getframe(hfig);
 writeVideo(writerObj,frame);
   
for n = 2:N
    
    %Point at origin
     U(n,1) = U(n-1,1) + 2*mu*(U(n-1,2) - U(n-1,1));
    
   %Points in the middle
   for m = 2:M-1
       U(n,m) = U(n-1,m) + (nu/(r(m)))*(U(n-1,m+1) - U(n-1,m-1)) + ...
                mu*(U(n-1,m+1) - 2*U(n-1,m) + U(n-1,m-1));
   end
   
   %Boundary Condition
   
   if U(n,M) <= U_thresh
       U(n,M) = U(n,M-1);
   else
       U(n,M) = (U(n,M-2)+2*eps*dr*U_thresh)/(1+2*eps*dr);
   end
   
   %Plotting
   
   subplot(1,2,1);
z = U(n,:)'*ones(size(r))/max(U(n,:));
col = 1-z;  % This is the color, vary with u in this case.
surf(x,y,z,col,...
        'facecol','no',...
        'edgecol','interp',...
        'linew',5);
axis([-1.5 1.5 -1.5 1.5],'square');
title('Radial Diffusion');
axis off;

subplot(1,2,2);
 h = plot(r,U(n,:),'b',-r,flipud(U(n,:)),'b',[-1 1],[0.25 0.25],'r--');
set(h(1),'Linewidth',3);
set(h(2),'Linewidth',3);
set(h(3),'Linewidth',2);
alw = 0.75;    % AxesLineWidth
fsz = 14;      % Fontsize
xlabel('Position');
ylabel('Concentration');
title('Concentration Profile');
%axis([-1 1 0 height]);

   %pause
   
    frame = getframe(hfig);
 writeVideo(writerObj,frame);
 
 if abs(U(n,1) - U(n,m)) <= 0.001
     break;
 end
 
end

 close(writerObj);

toc