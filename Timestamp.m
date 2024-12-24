%%                                                                                                    %读取文件目录
FolderPath1 = 'E:\TRcord\figend—source\VIDEtxt\SSAH-417230-EBABA';
FilePattern = '**\*.txt';
FolderPath = fullfile(FolderPath1, FilePattern);
%%                                                                                                    %获取设备号
% 获取子文件夹列表
SubFolders = dir(FolderPath1);
SubFolders = SubFolders([SubFolders.isdir]);
SubFolders = SubFolders(~ismember({SubFolders.name}, {'.', '..'}));

TimeExel = {};
frameInterval = 1/15;

%%                                                                                                  %遍历每个子文件夹
for folderIdx = 1:length(SubFolders)
    SubFolder = SubFolders(folderIdx);
    CurrentFolderPath = fullfile(FolderPath1, SubFolder.name);
    TxtList = dir(fullfile(CurrentFolderPath, '*.txt'));
    
 %%                                                                                                   %获取时间
    for txtIdx = 1:length(TxtList)
        TxtName = TxtList(txtIdx).name;
        TxtPath = fullfile(CurrentFolderPath, TxtName);
        FileData = textread(TxtPath, '%s', 'delimiter', '\n');     
        DeviceNumber = SubFolder.name;
        TimeTokens = regexp(TxtName, '[_](\d{2})(\d{2})(\d{2})', 'tokens');
        DayTimeTokens = regexp(TxtName, '([a-zA-Z])(\d{6})', 'tokens');
        DayTime = str2double(DayTimeTokens{1}{2});
        hour = str2double(TimeTokens{1}{1});
        minute = str2double(TimeTokens{1}{2});
        second = str2double(TimeTokens{1}{3});
        
        mousenumber = 0;
        frameCount = 0;
 %%                                                                                             %获取txt文件内每行数据
        for j = 1:numel(FileData)
            line = FileData{j};
            if isempty(strtrim(line)) || isstrprop(line(1), 'digit')
                if isempty(strtrim(line))
                    mousenumber = 0;
                else
                    mousenumber = str2double(line);
                end
%%                                                                                                  %时间计算模块
                frameCount = frameCount + 1;
                if frameCount == 15
                    frameCount = 0;
                    second = second + 1;
                    if second >= 60
                        second = second - 60;
                        minute = minute + 1;
                        if minute >= 60
                            minute = minute - 60;
                            hour = hour + 1;
                            if hour >= 24
                                hour = hour - 24;
                            end
                        end
                    end
%%                                                                                              %处理不同相机，数量累加
                    foundMatchingEntry = false;
                    for existingRow = 1:size(TimeExel, 1)
                        existingEntry = TimeExel(existingRow, :);
                        existingDeviceNumber = existingEntry{1};
                        existingDayTime = existingEntry{2};
                        existingTime = existingEntry{3};

                        if isequal(existingTime, [hour, minute, second])
                            if existingDayTime == DayTime & ~strcmp(existingDeviceNumber, DeviceNumber)
                               TimeExel{existingRow, 4} = existingEntry{4} + mousenumber;
                                foundMatchingEntry = true;                            
                                break;
                            end
                        end
                    end

                    %if mod(minute, 2) == 0 && ~foundMatchingEntry&&second==0
                        timeArray = {DeviceNumber, DayTime, [hour, minute, second], mousenumber};
                        TimeExel = [TimeExel; timeArray];
                    %end
                end
            end
        end
    end
end
%%                                                                                                         曲线图
hold on
scatter(xValues,yValues,'filled');

xValues = [];
yValues = [];
for i = 1:size(TimeExel, 1)
    pTimeline = TimeExel{i, 3};
    pAmount = TimeExel{i, 4};
    xValues = [xValues, pTimeline(1) + pTimeline(2) / 60 + pTimeline(3) / 3600];
    yValues = [yValues, pAmount];
end

% 按照每分钟计算平均值
timeInterval = 1/160; % 每分钟的时间间隔
smoothedXValues = min(xValues):10*timeInterval:max(xValues);
smoothedYValues = zeros(size(smoothedXValues));
currentIndex = 1;

for i = 1:length(smoothedXValues)
    startTime = smoothedXValues(i);
    endTime = startTime + timeInterval;
    dataInRange = yValues(xValues >= startTime & xValues < endTime);
    
    if ~isempty(dataInRange)
        %averagedValue = round(mean(dataInRange));                                   %如需四舍五入，添加以下两行 
        %smoothedYValues(i) = averagedValue;
        smoothedYValues(i) = mean(dataInRange);
    end
end
plot(smoothedXValues, smoothedYValues, 'Color', [71/255, 96/255, 163/255], 'LineWidth', 1.5); % 设置线条宽度为1.5，并绘制三角形定点

xlabel('时间');
ylabel('数量');
title('平滑日消涨曲线图');
%grid on; % 显示网格

%%
xValues = [];
yValues = [];
for i = 1:size(TimeExel, 1)
    pTimeline = TimeExel{i, 3};
    pAmount = TimeExel{i, 4};
    xValues = [xValues, pTimeline(1) + pTimeline(2) / 60 + pTimeline(3) / 3600];
    yValues = [yValues, pAmount];
end
roundedYValues = round(yValues);
binEdges = 0:1:24; 
binCounts = zeros(size(binEdges));

for i = 1:length(binEdges) - 1
    binStart = binEdges(i);
    binEnd = binEdges(i + 1);
    dataInRange = roundedYValues(xValues >= binStart & xValues < binEnd);
    binCounts(i) = sum(dataInRange);
end


totalSum = sum(binCounts);

% 计算每个柱子的所占百分比
percentageValues = binCounts / totalSum * 100;

% 绘制直方图
bar(binEdges, percentageValues);
xlabel('时间');
ylabel('百分比');
title('0-1区间数量百分比直方图');
grid on; % 显示网格

