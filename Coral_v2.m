%%This is for the drowning of a coral reef, after Galewsky (1998)
% Rachel Havranek, 1/27/16

%% Initialize

%Things that control subsidence and growth 
Gm=0.014; %14mm/yr max growth rate
I0=2000; % mE/m2s, surface light intensity
Ik=450; %mE/m2s, saturating light intensity
u=8; %mm/yr -- sinking rate
u = u/1000; % now in m

%horizontal array
dx = 100;
xmax = 10000;
x = 0:dx:xmax;

% depth array
zmax = 400;
S = 0.03; %slope of the ocean bottom
zb = zmax - (S*x); %y=mx+b
C = zeros(size(x)); %establish C
z = zb+C;

% time array
tmax=100000;
dt=100; %kdt/dz^2 has to be less than 0.5 for it to run
t=0:dt:tmax; %creates an array of time steps (time)
imax=length(t);
nplots = 100; %so our code runs faster - we'll plot one hundred times
tplot = tmax/nplots; %so our code runs faster - divides total time up into 100 time steps 

% sealevel array
sl_amp = 25;
sl_bar = 0;
P = 10000;
sl = sl_bar + sl_amp*sin(2*pi*t/P);

%% Run

for i=1:imax
    depth=sl(i)-z; %depth of coral relative to mean sea level
    
%coral thickness
Tc(1)=0;
G=zeros(length(z));
G=Gm*tanh(I0*exp(-depth)./Ik); %defined in the paper
G(depth<0)=0;
C = C + (G*dt);

zb = zb-(u*dt);

z = zb + C;

if(rem(t(i),tplot)==0)
figure(1)
     plot(x,zb,'k')
     hold on
     plot(x,z,'r')
     sea = find(depth>0);
     plot(x(sea),sl(i)*ones(size(x(sea))),'b','linewidth',2);
     axis ([0,10000,-500, 100])
     xlabel('Distance (m)','fontname','arial','fontsize',21)
     ylabel('Depth (m)','fontname','arial','fontsize',21)
     set(gca,'fontsize',18,'fontname','arial')
     %set(gca,'YDIR','reverse')
     pause(0.1)
     hold off
end

end
