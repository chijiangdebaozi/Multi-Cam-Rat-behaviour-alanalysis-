import os
import re
import shutil

# 源文件夹路径

match_num='01'
src_dir = 'D:/0001'

# 目标文件夹路径
dst_dir = 'D:/0001/0002'

# 匹配文件夹名字中间数字是123的正则表达式
pattern = r'^(\d+_' + match_num + r'_\d+_\d+)$'

# 遍历源文件夹中的所有文件和子文件夹
for filename in os.listdir(src_dir):
    filepath = os.path.join(src_dir, filename)

    # 如果是文件夹，且文件夹名字中间数字是123，则复制到目标文件夹中
    if os.path.isdir(filepath):
        match = re.search(pattern, filename)
        if match:
            dst_path = os.path.join(dst_dir, filename)
            shutil.copytree(filepath, dst_path)
