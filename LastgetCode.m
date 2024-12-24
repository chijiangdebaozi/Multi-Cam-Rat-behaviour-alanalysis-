% 指定文件路径
filePath = 'D:\MatTest\NewCode\xy2.txt';

% 打开文件进行读取
fileID = fopen(filePath, 'r');

% 读取文件中的数据
data = textscan(fileID, '%f %*c %f');

% 关闭文件
fclose(fileID);

% 将读取的数据分别存储为x和y向量
x = data{1};
y = data{2};

% 打印前几行数据进行检查

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






% 设定矩形的范围
% 设定矩形的范围
x_min = 0;
x_max = 8000;
y_min = 0;
y_max = 6000;

% 通过逻辑条件删除不在矩形范围内的点
indices = (x >= x_min) & (x <= x_max) & (y >= y_min) & (y <= y_max);
x = x(indices);
y = y(indices);

