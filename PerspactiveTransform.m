%%                                                                                                              %透视变换
imshow('4.JPG');
impixelinfo;
figure;
imshow('FeasibleScenario2.png');
impixelinfo;
image=imread('shouhui.jpg');

% --------------Times 1 6个边缘点--------Effect：中间区域不准 
%source_points=[59,395;481,235;827,380;937,893;1535,1339;410,1369;];
%destination_points=[35,38;1824,34;1835,2369;941,3994;941,4974;35,4674;];

% --------------Times 2 6个边缘点，增加一个中间点--------Effect：跟踪点位超出映射图片
%source_points=[59,395;481,235;827,380;937,893;1535,1339;410,1369;];
%destination_points=[35,38;1824,34;1835,2369;941,3994;941,4974;35,4674;];

% --------------Times 3 6个边缘点，向中间缩进--------Effect：通过点位移动，效变好                    ￥￥￥￥第二采取方案（可自选择）            
source_points=[59,395;481,235;827,380;937,893;1535,1339;410,1369;697,796;];
destination_points=[335,138;1724,134;1735,2269;931,3694;841,4674;335,4374;953,2204;];
%---------------Times 4 10个点，包括顺时针6外圈点，顺时针4内圈点，同时增加缩进 ------ Effect：效果更佳   ￥￥￥￥优先第一采取方案（可自选择）
source_points=[59,395;481,235;827,380;937,893;1535,1339;410,1369;344,730;890,536;570,1165;1236,841;];
destination_points=[335,138;1724,134;1735,2269;931,3694;841,4674;335,4374;343,1822;1230,1795;414,3525;1211,398;];
%%%%------------Times 效果较好
% --------------Times 3 6个边缘点，向中间缩进--------Effect：通过点位移动，效变好                    ￥￥￥￥最后采取方案（可自选择）            
source_points1=[59,395;481,235;827,380;937,893;1535,1339;410,1369;697,796;];
destination_points1=[-35,138;1724,134;1535,2069;731,3694;341,4674;235,4374;953,2204;];

%%----------zuihou嘗試
source_points1= [618,1914;180,970;78,492;678,275;1179,503;1336,1257;2172,1866];
destination_points1=[16,5016;100,2700;-16,22;1831,34;1837,2370;920,4015;932,4980];

tform1=fitgeotrans(source_points1,destination_points1,'projective');
AA=transformPointsForward(tform1,A);

source_points3=[80,1100;380,1906;1960,1897;2403,1279;1682,789;1631,536;];
destination_points3=[6790,3970;6803,2518;6186,2318;4663,2106;4667,3182;4597,3686;];

tform3=fitgeotrans(source_points3,destination_points3,'projective');
D=transformPointsForward(tform3,A);

source_points4=[789,335;595,215;364,340;242,139;46,227;208,597;];
destination_points4=[2700,3974;3148,3990;3144,2787;4663,3236;4640,2010;2700,2018;];

tform4=fitgeotrans(source_points4,destination_points4,'projective');
D=transformPointsForward(tform4,A);
%检测世界坐标
imshow('FeasibleScenario2.png')
hold on;
x=AA(:,1);
y=AA(:,2);
scatter(x,y,'filled');
hold off;
%检测相机坐标
figure;
imshow('37.jpg');
hold on;
x=A(:,1);
y=A(:,2);
scatter(x,y,'filled');


%%                                                                                                              %读取坐标

folderPath = 'E:\TRcord\figend—source\VIDEtxt\SSAH-417230-EBABA\'; 
txtFiles = dir(fullfile(folderPath, '*.txt'));

allCoordinates = [];

for i = 1:length(txtFiles)
    filePath = fullfile(folderPath, txtFiles(i).name);
    fileID = fopen(filePath, 'r');
    coordinates = [];
    while ~feof(fileID)
        line = fgetl(fileID);
        if ischar(line) && contains(line, 'mouse:')
            parts = strsplit(line, {' ', ',', ':'});
            x = str2double(parts{2});
            y = str2double(parts{3});
            coordinates = [coordinates; x, y];
        end
    end
    fclose(fileID);
    allCoordinates = [allCoordinates; coordinates];
end

A=allCoordinates;


%%%%%%%%%%---绘制热力图-----%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 提取x和y坐标
% 提取x和y坐标
% 提取x和y坐标
x = A(:, 1);
y = A(:, 2);
x=[x;C(:,1)];
y=[y;C(:,2)];
x=[x;D(:,1)];
y=[y;D(:,2)];

% 从矩阵 B 中提取 x 和 y 坐标
x = A(:, 1);
y = A(:, 2);

% 设定网格大小
% 设置热力图参数
binWidth = 50; % 调整bin的大小以适应您的数据分布
edges = {min(x):binWidth:max(x), min(y):binWidth:max(y)};

% 计算每个bin中的点的数量
histcounts2D = histcounts2(x, y, edges{1}, edges{2});

% 增加点的计数以增强热度
enhancedCounts = histcounts2D .^ 2; 
h = heatmap(edges{1}(1:end-1), edges{2}(1:end-1), enhancedCounts');
h.Colormap = jet; 
h.ColorScaling = 'log'; 

% 设置图形标题和轴标签
title('Enhanced Heatmap of Coordinate Points');
xlabel('X Coordinate');
ylabel('Y Coordinate');




