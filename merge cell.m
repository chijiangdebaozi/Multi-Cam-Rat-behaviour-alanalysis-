% ָ���ļ���·��
folder = 'D:\MatTest\video\detect\detect\exp5\location_center';

% ��ȡ�ļ����µ������ı��ļ�
fileList = dir(fullfile(folder, '*.txt'));

% ��������ļ�
outputFile = fullfile(folder, '�ϲ��ļ�.txt');
fid = fopen(outputFile, 'w');

% ��������ļ�
for i = 1:numel(fileList)
    % ��ȡ��ǰ�ļ�
    currentFile = fullfile(folder, fileList(i).name);
    fileContent = fileread(currentFile);
    
    % ���ļ�����д������ļ�
    fprintf(fid, '%s\n', fileContent);
end

% �ر�����ļ�
fclose(fid);

disp('�ļ��ϲ���ɡ�');