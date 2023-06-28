close all
figure

instrreset()
s = serial('/dev/cu.usbmodem641');
set(s,'BaudRate',9600); 

dataLength = 100;
i = 0;
DataS = zeros(dataLength, 5);

fopen(s);
while i < dataLength
    
    i = i+1;
    
    out = fgetl(s);
    out = sscanf(out, 'theta: %f, thetaDot: %f,  X: %f, XDot: %f,  time: %f' );
   
    DataS(i, 1) = out(1);
    DataS(i, 2) = out(2);
    DataS(i, 3) = out(3);
    DataS(i, 4) = out(4);
    DataS(i, 5) = out(5);
    
end 
fclose(s);

subplot(2, 1, 1)
plot(DataS(:, 5), DataS(:, 1), 'k.-')
hold on
plot(DataS(:, 5), DataS(:, 2), 'b.-')
xlabel('temps[s]');
legend('Angle[rad]', 'Vitesse angulaire[rad/s]');

subplot(2, 1, 2)
plot(DataS(:, 5), DataS(:, 3), 'k.-')
hold on
plot(DataS(:, 5), DataS(:, 4), 'g.-')
xlabel('temps[s]');
legend('position[m]', 'vitesse[m/s]');

