% Ce code permet de trouver les extremas d'une fonction en localisant le 
% point le plus haut dans une zone. La taille de la zone peut etre modifiee 
% pour eliminer les problemes lies au bruit.
% 
% l'argument data doit etre une matrice a deux colones

function [Px, Py] = Extremas(data)

close all
figure('name', 'amplitude & frequency analysis'); clf

%la figure doit ocupper 80% de l'écran
scr = get(0, 'Screensize');
set(gcf, 'Position', [0.1*scr(3), 0.1*scr(4), 0.8*scr(3), 0.8*scr(4)])

Xdata = data(:, 2)*1e-3;
Ydata = data(:, 1);

%plot de la courbe
subplot(2, 2, 1)
hold on
plot(Xdata, Ydata, '-k')
xlabel('data X')
ylabel('data Y')

%calcul des extremas
df = diff(Ydata);
Iext = find(df(1:end-1).*df(2:end) <= 0);
Imax = find(df(1:end-1).*df(2:end) <= 0 & df(1:end-1) > 0);
Imin = find(df(1:end-1).*df(2:end) <= 0 & df(1:end-1) < 0);

Px = Xdata(Iext+1);
Py = Ydata(Iext+1);

%plot des extremas
hmin = plot(Xdata(Imax+1), Ydata(Imax+1), 'or');
hmax = plot(Xdata(Imin+1), Ydata(Imin+1), 'ob');
legend([hmin, hmax], 'min', 'max')

%calcul de l'amplitude et frequence
amp = abs(diff(Ydata(Iext+1)));
freq = diff(Xdata(Iext+1));

%plot de l'amplitude vs data
subplot(2, 2, 2)
plot(Xdata(Iext(1:end-1)), amp, '-go')
xlabel('data X')
ylabel('amplitude')

%plot de la frequence vs periode
subplot(2, 2, 3)
Xfreq = 1:1:length(Iext)-1;
plot(Xfreq, freq, '-ro')
xlabel('periode')
ylabel('frequence')

%plot de la frequence vs amplitude
subplot(2, 2, 4)
plot(freq, amp, '-bo')
xlabel('frequence')
ylabel('amplitude')




