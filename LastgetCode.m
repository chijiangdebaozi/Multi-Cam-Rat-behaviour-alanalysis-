% ָ���ļ�·��
filePath = 'D:\MatTest\NewCode\xy2.txt';

% ���ļ����ж�ȡ
fileID = fopen(filePath, 'r');

% ��ȡ�ļ��е�����
data = textscan(fileID, '%f %*c %f');

% �ر��ļ�
fclose(fileID);

% ����ȡ�����ݷֱ�洢Ϊx��y����
x = data{1};
y = data{2};

% ��ӡǰ�������ݽ��м��

binWidth = 50; % ����bin�Ĵ�С����Ӧ�������ݷֲ�
edges = {min(x):binWidth:max(x), min(y):binWidth:max(y)};

% ����ÿ��bin�еĵ������
histcounts2D = histcounts2(x, y, edges{1}, edges{2});

% ���ӵ�ļ�������ǿ�ȶ�
enhancedCounts = histcounts2D .^ 2; 
h = heatmap(edges{1}(1:end-1), edges{2}(1:end-1), enhancedCounts');
h.Colormap = jet; 
h.ColorScaling = 'log'; 

% ����ͼ�α�������ǩ
title('Enhanced Heatmap of Coordinate Points');
xlabel('X Coordinate');
ylabel('Y Coordinate');






% �趨���εķ�Χ
% �趨���εķ�Χ
x_min = 0;
x_max = 8000;
y_min = 0;
y_max = 6000;

% ͨ���߼�����ɾ�����ھ��η�Χ�ڵĵ�
indices = (x >= x_min) & (x <= x_max) & (y >= y_min) & (y <= y_max);
x = x(indices);
y = y(indices);

