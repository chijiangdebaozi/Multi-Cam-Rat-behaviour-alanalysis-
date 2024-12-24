%%                                                                                                    %读取文件目录
FolderPath1 = 'E:\2023_01_10\FIRST DAY';
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

                    if mod(minute, 2) == 0 && ~foundMatchingEntry&&second==0
                        timeArray = {DeviceNumber, DayTime, [hour, minute, second], mousenumber};
                        TimeExel = [TimeExel; timeArray];
                    end
                end
            end
        end
    end
end
xValues = [];
yValues = [];
for i = 1:size(TimeExel, 1)
    pTimeline = TimeExel{i, 3};
    pAmount = TimeExel{i, 4};
    xValues = [xValues, pTimeline(1) + pTimeline(2) / 60 + pTimeline(3) / 3600];
    yValues = [yValues, pAmount];
end
[xValues, sortIndices] = sort(xValues);
yValues = yValues(sortIndices);
plot(xValues, yValues, '-*b');
xlabel('时间');
ylabel('数量');
title('日消涨')
