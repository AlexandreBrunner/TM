function [t, z] = DampedOscillator

omega0 = 1;
nu = 0.1;

x0 = 1;
v0 = 0;

T = 2*pi/omega0;
trun = 10*T;
dtsnap = T/20;



%------------------------------

params.omega0 = omega0 ;
params.nu = nu;

z0 = [x0, v0];

%avec odeset, on définit l'erreur relative et l'erreur absolue pour plus de précision
ODEoptions = odeset('RelTol',1e-8,'AbsTol',1e-10);
tspan = 0:dtsnap:trun;
[t, z] = ode45(@(t, z) RHS(t, z, params), tspan, z0, ODEoptions);

figure

plot(t, z(:, 1))
grid
xlabel('time')
ylabel('position')

%------------------------------

function dzdt = RHS(t, z, ODEparams)

omega0 = ODEparams.omega0;
nu = ODEparams.nu;

dzdt = zeros(2, 1);

dzdt(1) = z(2);
%dzdt(2) = -omega0^2*z(1) - nu*z(2);
dzdt(2) = -omega0^2*z(1) - sign(z(2))*nu*z(2)^2;
