close all
figure
subplot(2, 1, 1)

CBrun = uicontrol('Style', 'togglebutton');
CBrun.String = {'pause'};
figsize = get(gcf, 'Position');
CBrun.Position = [figsize(3)/2-20, 30, 40, 30];
CBrun.UserData = 1;
CBrun.Callback = @plotButtonPushed;

CBedit_s = uicontrol('Style', 'edit');
CBedit_s.String = num2str(1);
CBedit_s.Position = [figsize(3)/2-120, 30, 40, 30];
CBedit_s.Callback = @StartIter;

CBedit_f = uicontrol('Style', 'edit');
CBedit_f.String = num2str(1);
CBedit_f.Position = [figsize(3)/2+80, 30, 40, 30];
%CBedit_f.Callback = @EndIter


function StartIter(src, event)
if isempty(str2num(src.String)) | str2num(src.String) <= 0,
    src.String = num2str(1);
end
end

function plotButtonPushed(src, event)
text(0.1, 0.1, 'coucou')
switch src.Value,
    case 0,
        src.String = 'pause';
    case 1,
        src.String = 'run';
        runloop(src.UserData, 100, src);
end
end

function it = runloop(istart, iend, src)

for it = istart:iend
    it = it + 1;
    disp(it)
    pause(1)
    if src.Value == 0
        src.UserData = it;
        return;
    end
end
end
