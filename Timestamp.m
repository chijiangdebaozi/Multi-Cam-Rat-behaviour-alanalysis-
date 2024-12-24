%%                                                                                                    %��ȡ�ļ�Ŀ¼
FolderPath1 = 'E:\TRcord\figend��source\VIDEtxt\SSAH-417230-EBABA';
FilePattern = '**\*.txt';
FolderPath = fullfile(FolderPath1, FilePattern);
%%                                                                                                    %��ȡ�豸��
% ��ȡ���ļ����б�
SubFolders = dir(FolderPath1);
SubFolders = SubFolders([SubFolders.isdir]);
SubFolders = SubFolders(~ismember({SubFolders.name}, {'.', '..'}));

TimeExel = {};
frameInterval = 1/15;

%%                                                                                                  %����ÿ�����ļ���
for folderIdx = 1:length(SubFolders)
    SubFolder = SubFolders(folderIdx);
    CurrentFolderPath = fullfile(FolderPath1, SubFolder.name);
    TxtList = dir(fullfile(CurrentFolderPath, '*.txt'));
    
 %%                                                                                                   %��ȡʱ��
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
 %%                                                                                             %��ȡtxt�ļ���ÿ������
        for j = 1:numel(FileData)
            line = FileData{j};
            if isempty(strtrim(line)) || isstrprop(line(1), 'digit')
                if isempty(strtrim(line))
                    mousenumber = 0;
                else
                    mousenumber = str2double(line);
                end
%%                                                                                                  %ʱ�����ģ��
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
%%                                                                                              %����ͬ����������ۼ�
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
%%                                                                                                         ����ͼ
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

% ����ÿ���Ӽ���ƽ��ֵ
timeInterval = 1/160; % ÿ���ӵ�ʱ����
smoothedXValues = min(xValues):10*timeInterval:max(xValues);
smoothedYValues = zeros(size(smoothedXValues));
currentIndex = 1;

for i = 1:length(smoothedXValues)
    startTime = smoothedXValues(i);
    endTime = startTime + timeInterval;
    dataInRange = yValues(xValues >= startTime & xValues < endTime);
    
    if ~isempty(dataInRange)
        %averagedValue = round(mean(dataInRange));                                   %�����������룬����������� 
        %smoothedYValues(i) = averagedValue;
        smoothedYValues(i) = mean(dataInRange);
    end
end
plot(smoothedXValues, smoothedYValues, 'Color', [71/255, 96/255, 163/255], 'LineWidth', 1.5); % �����������Ϊ1.5�������������ζ���

xlabel('ʱ��');
ylabel('����');
title('ƽ������������ͼ');
%grid on; % ��ʾ����

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

% ����ÿ�����ӵ���ռ�ٷֱ�
percentageValues = binCounts / totalSum * 100;

% ����ֱ��ͼ
bar(binEdges, percentageValues);
xlabel('ʱ��');
ylabel('�ٷֱ�');
title('0-1���������ٷֱ�ֱ��ͼ');
grid on; % ��ʾ����

