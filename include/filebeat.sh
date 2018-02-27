#!/bin/bash     

pushd $src_dir # 切换

# 解压
tar -zxvf $filebeat_gz

# 移动目录 + 重命名
mv $filebeat_version $filebeat_install_dir 

popd  # 切换

# 复制配置文件
cp ./conf/filebeat.yml $filebeat_install_dir/filebeat.yml

# 测试  ./filebeat -c ./filebeat.yml -configtest
# 启动  ./filebeat -c ./filebeat.yml -e

