function DataS = save_data_arduino2
%close all

instrreset()
s = serial('/dev/cu.usbmodem641', 'BaudRate', 230400);

dataLength = 1000;
i = 0;
DataS = zeros(dataLength, 2);

fopen(s);
pause(5)
fprintf("Start Now")

while i < dataLength
    
    out = fgetl(s);
    out = sscanf(out, '%i,%i');
    
    if out(2) > 4000,
        i = i+1;
        DataS(i, 1) = out(1);
        DataS(i, 2) = out(2);
    end
    
end 
fclose(s);

figure(3)
hold off
plot(DataS(:, 2), DataS(:, 1))