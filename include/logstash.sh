#!/bin/bash     

pushd $src_dir # 切换

# 解压
tar -zxvf $logstash_gz

# 移动目录 + 重命名
mv $logstash_version $logstash_install_dir 

popd  # 切换

# 复制配置文件
cp ./conf/logstash.conf $logstash_install_dir/logstash.conf

# 测试  ./bin/logstash -f ./config/logstash.conf  -t
# 启动  ./bin/logstash -f ./config/logstash.conf


