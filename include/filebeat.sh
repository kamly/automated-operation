#!/bin/bash     

pushd $src_dir # 切换

# 解压
tar -zxvf $filebeat_gz

# 移动目录 + 重命名
mv $filebeat_version $filebeat_install_dir 

# 只进行安装，配置文件自行配置
