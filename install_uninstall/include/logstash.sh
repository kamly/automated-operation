#!/bin/bash     

pushd $src_dir # 切换

# 解压
tar -zxvf $logstash_gz

# 移动目录 + 重命名
mv $logstash_version $logstash_install_dir 

# 新建日志目录
mkdir $logstash_log

popd  # 切换

# 复制配置文件
cp ./conf/logstash.conf $logstash_install_dir/config/logstash.conf

# 测试  ./bin/logstash -f ./config/logstash.conf  -t
# 启动  ./bin/logstash -f ./config/logstash.conf
# 挂起  nohup /usr/local/logstash/bin/logstash -f /usr/local/logstash/config/logstash.conf &>> /data/logs/logstash/nohup.log &

