%Dans cette simulation, nous allons utiliser les equations que nous avons
%dérivées pour visualiser le mouvement du pendule et du chariot. Pour
%cela, on peu utiliser la commande ode45 qui est capable d'intégrer des
%système d'quations du premier ordre. Dans notre système, il y a du dexième
%ordre, c'est pourquoi il faut faire un système d'équation avec
%omega(vitesse angulaire) = \dot{theta}

function [t, y, Movie] = simulationTM
close all; clear all;

% Ici on défini les paramètres du pendule

M = 0.6;    % masse du chariot     [kg]
m = 0.2;    % masse du pendule     [kg]
l = 0.4;    %longueur pendule      [m]
g = 9.81;   % accélération gravifique terrestre [m/s^2]

tref = 1;%2*pi*sqrt(l/g); % temps de reference (= periode petite oscillations)

%-------------------------------------------------------
% Ici on initialise nos variables
theta0 = 1;               % angle initial en degrèes
X0 = 0;                     % position initiale du chariot
init = [X0, 0, theta0*pi/180, 0];  % [angle initial, vitesse angulaire initiale, position initiale, vitesse initiale]
trun= 10*tref;             % temps sur lequel on intègre
dtsnap = tref/24;    % intervale de temps entre l'acquisition de données
%F = 0;                     % La force du moteur sur le chariot

SlowMow = 1; % SlowMow factor for movies visualisation
%-------------------------------------------------------
%emballage des paramètres dans une structure + calcul du moment d'inertie
params.M = M;
params.m = m;
params.l = l;
params.g = g;
params.I = 1/12*m*l^2;

%avec odeset, on définit l'erreur relative et l'erreur absolue pour plus de précision
ODEoptions = odeset('RelTol',1e-8,'AbsTol',1e-10);
tspan = 0:dtsnap:trun;
[t, y] = ode45(@(t, y) RHS(t, y, params), tspan, init, ODEoptions);
%[t, y] = ode45(@(t, y) RHS(t, y, params), tspan, init);

%-------------------------------------------------------
% angle en fonction du temps
figure('name', 'data chariot + pendule'); clf
%la figure doit ocupper 80% de l'écran
scr = get(0, 'Screensize');
set(gcf, 'Position', [0.1*scr(3), 0.1*scr(4), 0.8*scr(3), 0.8*scr(4)])

% array of plot handles
hplot = [];
htline = [];
YLIM = [];
Xline = [0, 0];
ip = 0;

%angle en fonction du temps
ip = ip+1;
hplot(ip) = subplot(4, 3, 1);
plot(t, y(:, 1),'.-')
hold on
YLIM = [YLIM; get(gca, 'ylim')];
htline(ip) = plot(Xline, YLIM(ip, :), 'r--');   %ligne du temps 
set(htline(ip), 'XDataSource', 'Xline');
grid on
xlabel('temps [s]')
ylabel('position chariot [m]')

%vitesse angulaire en fonction du temps
ip = ip+1;
hplot(ip) = subplot(4, 3, 4);
plot(t, y(:, 2),'.-')
hold on
YLIM = [YLIM; get(gca, 'ylim')];
htline(ip) = plot(Xline, YLIM(ip, :), 'r--');     %line 
set(htline(ip), 'XDataSource', 'Xline');
grid on
xlabel('temps [s]')
ylabel('vitesse chariot [m/s]')

%position du chariot en fonction du temps
ip = ip+1;
hplot(ip) = subplot(4, 3, 7);
plot(t, y(:, 3)/pi,'.-')
hold on
YLIM = [YLIM; get(gca, 'ylim')];
htline(ip) = plot(Xline, YLIM(ip, :), 'r--');     %line
set(htline(ip), 'XDataSource', 'Xline');
grid on
xlabel('temps [s]')
ylabel('angle[rad/pi]')

%vitesse du chariot en fonction du temps
ip = ip+1;
hplot(ip) = subplot(4, 3, 10);
plot(t, y(:, 4),'.-')
hold on
YLIM = [YLIM; get(gca, 'ylim')];
htline(ip) = plot(Xline, YLIM(ip, :), 'r--');     %line
set(htline(ip), 'XDataSource', 'Xline');
grid on
xlabel('temps [s]')
ylabel('vitesse angulaire [1/s]')

%énergie mécanique en fonction du temps
[Etot, EcinTr_ch, EcinTr_pe, EcinRo_pe, Epot_pe] = Emeca(y(:, 2), y(:, 3), y(:, 4), params);

ip = ip+1;
hplot(ip) = subplot(4, 3, [2, 3]);
plot(t, Etot, '.-')
hold on
YLIM = [YLIM; get(gca, 'ylim')];
htline(ip) = plot(Xline, YLIM(ip, :), 'r--');     %line
set(htline(ip), 'XDataSource', 'Xline');
grid on
xlabel('temps[s]')
ylabel('énergie mécanique[J]')

%chaque types d'énergie
ip = ip+1;
hplot(ip) = subplot(4, 3, [11, 12]);
plot(t, EcinTr_ch, t, EcinTr_pe, t, EcinRo_pe, t, Epot_pe)
hold on
YLIM = [YLIM; get(gca, 'ylim')];
htline(ip) = plot(Xline, YLIM(ip, :), 'r--');     %line
set(htline(ip), 'XDataSource', 'Xline');
grid on
legend('Energie cinétique du chariot', ...
       'Energie cinétique de translation du pendule', ...
       'Energie cinétique de rotation du pendule', 'Energie potentielle du pendule')
xlabel('temps[s]')
ylabel('Energie[J]')

%-------------------------------------------------------
%ANIMATION
hanim = subplot(4, 3, [5, 6, 8, 9]);
axis equal
sizeanim = get(hanim, 'Position');
%axis([-2 2 -1.4*scr(4)/scr(3) 1.8*scr(4)/scr(3)]*l)             %limite des axes
axis([[-1, 1]*2.5*sizeanim(3)/sizeanim(4) -1.1 1.4]*l)
hold on
grid on
xlabel('mètres'), ylabel('mètres')

%initialliser Movie avec un array 1xlenght(t)
Movie = zeros(size(t));

%Dessiner rail
xlim = get(gca, 'XLim');    %extraction de la limite de l'axe X
line(xlim, [0, 0], 'Color', 'k', 'LineWidth', 2)    %rail  

%calcul de l'interval entre pas de temps successifs 
dt = diff(t); dt = [dt; 0];  

hobjs = []; %création d'un tableau vide pour contenir tous les objets
for it = 1: 1: length(t)
    tc = t(it);   %temps courant
    
%Pour optimiser le code, on plot seulement se qui bouge. C'est à dire que 
%on efface l'ancienne image avant de dessiner la nouvelle. Cela fait gagner
%du temps car on ne doit pas redessiner ce qui ne bouge pas comme par
%exemple les axes ou le rail.

    %si il existe des objets efface les
    if ~isempty(hobjs), delete(hobjs); end
    
    %ici, on donne un handle pour chaque objets de la fonction drawSystemState
    hobjs = drawSystemState(y(it, 1), y(it, 3), l);
    %pour faire un titre on a converti le temps en string
    title(sprintf('Time = %.3f sec', tc), 'FontSize', 18)
    
    % Update time line on all plots
    Xline = [tc, tc];   
    refreshdata(htline, 'caller')
    drawnow
   
    %capturer une image pour le film avec getframe() et movie()
    Movie = getframe(gcf);
    %pause avant le prochain pas de temps(dépend de dt)
    pause(SlowMow*dt(it))
end

%-------------------------------------------------------
%Dans cette fonction, on introduit les équations du mouvement

function dydt = RHS(t, y, ODEparams)

%déballage des paramètres
M = ODEparams.M;
m = ODEparams.m;
l = ODEparams.l;
g = ODEparams.g;

costta = cos(y(3));
sintta = sin(y(3));
den = (M+m) - 0.75*m*costta^2;

%Ici, on définit la force du chariot comme une constante
F = feedback(y(3, :), y(4, :), y(1, :), y(2, :));

dydt = zeros(4, 1);

dydt(1) = y(2); % vitesse = Xdot
dydt(2) = (F - 0.5*m*l*sintta*y(4)^2 + 0.75*m*g*costta*sintta)/den;
dydt(3) = y(4); % vitesse angulaire = thetadot
dydt(4) = 1.5/l*((M+m)*g*sintta + F*costta - 0.5*m*l*costta*sintta*y(4)^2)/den; 


%-------------------------------------------------------
%Dans cette fonction, on calcul l'énergie mécanique du système pour
%véréfier qu'elle est bien constante

function [Etot, EcinTr_ch, EcinTr_pe, EcinRo_pe, Epot_pe] = Emeca(Vx, theta, omega, Eparams)

%déballage des paramètres
M = Eparams.M;
m = Eparams.m;
l = Eparams.l;
g = Eparams.g;
I = Eparams.I;

%Ne pas oublier .* ou .^ avec les multiplications de matrices
vx = Vx-0.5*l*cos(theta).*omega;
vy =   -0.5*l*sin(theta).*omega;

EcinTr_ch = 0.5*M*Vx.^2;            %energie cinétique chariot
EcinTr_pe = 0.5*m*(vx.^2 + vy.^2);  %energie cinétique de translation pendule
EcinRo_pe = 0.5*I*omega.^2;         %energie cinétique de rotation penddule
Epot_pe   = 0.5*m*g*l*cos(theta);   %energie potentielle pendule

Etot =  EcinTr_ch + EcinTr_pe + EcinRo_pe + Epot_pe;    %energie totale

%-------------------------------------------------------
% Cette fonction dessine le système pendule + chariot
function hobjs = drawSystemState(x, theta, l)

%figure(hfig)
subplot(4, 3, [5, 6, 8, 9])

% Dessiner pendule
lineX   = [x,   x   - sin(theta)*l];
lineY   = [0.1, 0.1 + cos(theta)]*l;
hpend = line(lineX, lineY);

% Dessiner chariot
chariot = [x-0.05*l, 0, 0.1*l, 0.1*l];
hchar = rectangle('position', chariot);

hobjs = [hpend, hchar];

function F = feedback(theta, omega, x, v)

%constantes de feedback pour le pendule
k_pp = -25;
%k_ip = 0;
k_dp = -1;

%constantes de feedback pour le chariot
k_pc = 7;
%k_ic = 0;
k_dc = 1;

target = k_pc*x + k_dc*v;
F = k_pp*theta+target + k_dp*omega;
F = 0 ;