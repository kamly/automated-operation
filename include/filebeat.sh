#!/bin/bash     

pushd $src_dir # 切换

# 解压
tar -zxvf $filebeat_gz

# 移动目录 + 重命名
mv $filebeat_version $filebeat_install_dir 

popd  # 切换

# 复制配置文件
cp ./conf/filebeat.yml $filebeat_install_dir/filebeat.yml

# 新建日志目录
mkdir $filebeat_log

# 测试  /usr/local/filebeat/filebeat -c /usr/local/filebeat/filebeat.yml -configtest
# 启动  /usr/local/filebeat/filebeat -c /usr/local/filebeat/filebeat.yml-e
# 挂起  nohup /usr/local/filebeat/filebeat -e -c /usr/local/filebeat/filebeat.yml >> /data/logs/filebeat/`date -d "now" +%Y-%m-%d`.log 2>&1 &

