close all
figure

Xline = [0, 0];

CBrun = uicontrol('Style', 'togglebutton');
CBrun.String = {'pause'};
figsize = get(gcf, 'Position');
CBrun.Position = [figsize(3)/2-20, 30, 40, 30];
CBrun.UserData = 1;
CBrun.Callback = @plotButtonPushed;

subplot(2, 1, 1)
x = 0:0.1:10;
y = sin(x);
hold on
plot (x, y)
hplot1 = plot (Xline, [-1 1], '--r');
hplot1.XDataSource = 'Xline';

% subplot(2, 1, 2)
% x = 0:0.1:10;
% y = cos(x);
% hold on
% plot (x, y)
% hplot2 = plot (Xline, [-1 1], '--r');
% hplot2.XDataSource = 'Xline';

%loops = 1;
%M(loops) = struct('cdata',[],'colormap',[]);

function plotButtonPushed(src, event, Xline, hplot1, x)
%text(0.1, 0.1, 'coucou')
switch src.Value
    case 0
        src.String = 'pause';
    case 1
        src.String = 'run';
        runloop(src.UserData, 100, src, Xline, hplot1, x);
end
end

function it = runloop(istart, iend, src, Xline, hplot1, x)
for it = istart:1:iend
    Xline = [x(it), x(it)];
    refreshdata([hplot1])     
    drawnow 
    disp(it)
    pause(1)
    if src.Value == 0
        src.UserData = it;
        return;
    end
end
end
