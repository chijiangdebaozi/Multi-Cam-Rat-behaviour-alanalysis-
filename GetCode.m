FolderPath1 = 'E:\TRcord\figend—source\VIDEtxt';
FilePattern = '**\*.txt';
FolderPath = fullfile(FolderPath1, FilePattern);

SubFolders = dir(FolderPath1);
SubFolders = SubFolders([SubFolders.isdir]);
SubFolders = SubFolders(~ismember({SubFolders.name}, {'.', '..'}));

MouseData = {}; 

for folderIdx = 1:length(SubFolders)
    SubFolder = SubFolders(folderIdx);
    CurrentFolderPath = fullfile(FolderPath1, SubFolder.name);
    TxtList = dir(fullfile(CurrentFolderPath, '*.txt'));
    
    for txtIdx = 1:length(TxtList)
        TxtName = TxtList(txtIdx).name;
        TxtPath = fullfile(CurrentFolderPath, TxtName);
        FileData = textread(TxtPath, '%s', 'delimiter', '\n');     
        DeviceNumber = SubFolder.name;
        
        for j = 1:numel(FileData)
            line = FileData{j};
            mousePattern = 'mouse:\s*([\d.]+),\s*([\d.]+),\s*(\d+)';
            match = regexp(line, mousePattern, 'tokens', 'once');
            
            if ~isempty(match)
                x = str2double(match{1});
                y = str2double(match{2});
                mousenumber = str2double(match{3});
                
                mouseEntry = {DeviceNumber, x, y, mousenumber};
                MouseData = [MouseData; mouseEntry];
            end
        end
    end
end

%%                                                                                                  绘制点位
xCoordinates = cell2mat(MouseData(strcmp(MouseData(:, 1), 'SSAH-417230-EBABA'), 2));
yCoordinates = cell2mat(MouseData(strcmp(MouseData(:, 1), 'SSAH-417230-EBABA'), 3));

scatter(xCoordinates, yCoordinates, 'filled');
xlabel('X Coordinate');
ylabel('Y Coordinate');
title('Mouse Coordinates for SSAH-417230-EBABA');
grid on;
%%                                                                                                  进行映射1号相机
source_points=[59,495;481,435;827,380;937,893;1535,1339;410,1369;344,530;690,536;570,1165;1236,841;];
destination_points=[135,0;1324,0;1535,1869;741,3694;741,4674;335,4374;343,1322;1030,1395;414,3025;1011,2898;];

%%                                                                                                    删除多余点 
A=[xCoordinates,yCoordinates];
selectedPoints = [80,541;679,303;1142,4;0,0;] ;% 不规则框选范围的顶点坐标

xCoords = selectedPoints(:, 1);
yCoords = selectedPoints(:, 2);
pointsInBox = inpolygon(A(:, 1), A(:, 2), xCoords, yCoords);

A(pointsInBox, :) = [];
%%
tform1=fitgeotrans(source_points,destination_points,'projective');
B=transformPointsForward(tform1,A);
%%                                                                                                    画图
imshow('FeasibleScenario2.png')
hold on;
x=B(:,1);
y=B(:,2);
scatter(x,y,'filled');
hold off;
%%
imshow('333.JPG')
hold on;
x=A(:,1);
y=A(:,2);
scatter(x,y,'filled');
hold off;