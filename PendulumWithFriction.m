function PendulumWithFriction(ExpDataFile)
%----------------------------------------------------------------------
%
% M-file for integrating equation of motion of a pendulum with friction
%
% Includes aerodynamic friction from surrounding air as well as
% speed-independent bearing friction as in [Carl Mungan, Eur. J. Phys. 43,
% 045001 (2022), https://doi.org/10.1088/1361-6404/ac646a]
%
%----------------------------------------------------------------------

% Physical parameters
L = 0.485;        % Length of pendulum [meter]
D = 0.01;        % Diameter of pendulum [meter]
M = 0.03;        % Mass of pendulum [kg]

rho = 1.293;     % Air density [kg/meter^3]
CD = 1.0;        % Drag coefficient of cylindrical cross section
%CD = 0;

d = 0.01;       % Diameter of axis [meter]
mu = 2;        % Friction coefficient
%mu = 0;

g = 9.81;        % gravitational acceleration [meter/sec^2]

% Initial conditions
tta0 = 0.318*pi; % initial angle of pendulum
omega0 = 0;      % initial angular velocity of pendulum

Trun = 50; % Run time in units sqrt(L/g)

% Experimental data file 
% ExpDataFile = 'data_HEDS_5504';

%------------------------------
% Precompute

I = M*(L^2)/3; % moment of inertial of pendulum

params.C1 = M*(L^2)/(2*I); 
params.C2 = CD*rho*D*(L^4)/(8*I);
params.C3 = mu*d*L*M/(2*I*sqrt(1+mu^2));

vec0 = [tta0; omega0];

%------------------------------

% Time integration
[tm, vec] = ode45(@(t, vec) RHS(t, vec, params), [0 Trun], vec0);

%------------------------------

figure(1), clf

subplot(2, 1, 1)

% load(ExpDataFile)
TM  = encData(:, 2)*1e-3;
TTA = encData(:, 1); TTA = (TTA - TTA(end))/500;

ind = find( diff(TTA(1:end-1)).*diff(TTA(2:end)) <=0 & diff(TTA(1:end-1)) >= 0) + 1;

plot(TM-TM(ind(1)), TTA, 'r-', 'LineWidth', 2)
hold on
plot(TM(ind)-TM(ind(1)), TTA(ind), 'go', 'MarkerSize', 8, 'LineWidth', 2)

plot(tm*sqrt(L/g), vec(:, 1)/pi, 'b-', 'LineWidth', 2)

grid
xlabel('time [sec]')
ylabel('angle / \pi')
legend('experimental', 'simulation')

subplot(2, 1, 2)

plot(diff(TM(ind)), 'bo', 'MarkerSize', 8, 'LineWidth', 2)
xlabel('period #')
ylabel('period [sec]')
hold on
Tref = 2*pi/sqrt(M*g*L/(2*I));
plot([0, length(TM(ind))], Tref*[1 1], 'r--')

%------------------------------

function dvecdt = RHS(t, vec, params)

dvecdt = zeros(2, 1);

dvecdt(1) = vec(2);
dvecdt(2) = -params.C1*sin(vec(1)) ...
            - sign(vec(2))*(params.C2*vec(2)^2 + 0.05);
%           - sign(vec(2))*(params.C2*vec(2)^2 + params.C3*abs(cos(vec(1))+vec(2)^2/2));

