% 指定文件夹路径
folder = 'D:\MatTest\video\detect\detect\exp5\location_center';

% 获取文件夹下的所有文本文件
fileList = dir(fullfile(folder, '*.txt'));

% 创建输出文件
outputFile = fullfile(folder, '合并文件.txt');
fid = fopen(outputFile, 'w');

% 逐个处理文件
for i = 1:numel(fileList)
    % 读取当前文件
    currentFile = fullfile(folder, fileList(i).name);
    fileContent = fileread(currentFile);
    
    % 将文件内容写入输出文件
    fprintf(fid, '%s\n', fileContent);
end

% 关闭输出文件
fclose(fid);

disp('文件合并完成。');