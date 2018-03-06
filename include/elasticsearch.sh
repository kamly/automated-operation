#!/bin/bash     

# 安装 java环境
apt-get update -y && apt-get -y install openjdk-8-jdk-headless


# 校验用户组是否存在
if [[ `grep elasticsearch /etc/group | wc -l` == 0 ]];then
    groupadd $elasticsearch_group
fi

# 校验用户是否存在
if [[ `grep elasticsearch /etc/passwd | wc -l` == 0 ]];then
    useradd $elasticsearch_user -g $elasticsearch_group
fi

pushd $src_dir # 切换

# 解压
tar -zxvf $elasticsearch_gz

# 移动目录 + 重命名
mv $elasticsearch_version $elasticsearch_install_dir 


# 修改配置文件
sed -i "s@#path.data: /path/to/data@path.data: ${elasticsearch_data}@g" $elasticsearch_install_dir/config/elasticsearch.yml  # 路径
sed -i "s@#path.logs: /path/to/logs@path.logs: ${elasticsearch_log}@g" $elasticsearch_install_dir/config/elasticsearch.yml  # 日志
sed -i "s@#bootstrap.memory_lock: true@bootstrap.memory_lock: true@g" $elasticsearch_install_dir/config/elasticsearch.yml  # 关闭swap
sed -i "s@#http.port: 9200@http.port: ${elasticsearch_port}@g" $elasticsearch_install_dir/config/elasticsearch.yml  # 端口

sed -i "s@-Xms1g@-Xms128M@g" $elasticsearch_install_dir/config/jvm.options # 内存
sed -i "s@-Xmx1g@-Xmx128M@g" $elasticsearch_install_dir/config/jvm.options # 内存


# 创建目录
mkdir $elasticsearch_data  $elasticsearch_log

# 赋值权限
chown -R $elasticsearch_user:$elasticsearch_group  $elasticsearch_install_dir $elasticsearch_data  $elasticsearch_log

popd  # 切换

# 需要自己切换到 elasticsearch 用户进行测试
# 启动 /usr/local/elasticsearch/bin/elasticsearch -d

