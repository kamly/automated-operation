#!/bin/bash                                                                                                                                                  

## 安装包就是文件

pushd $src_dir

# 解压
tar zxf $redis_gz

# 复制目录+改名目录
cp -rf $redis_version $redis_install_dir

# 进入目录
cd $redis_install_dir    

make    

ln -fs ${redis_install_dir}/src/redis-server /usr/local/bin/redis-server # 设置软链

ln -fs ${redis_install_dir}/src/redis-cli  /usr/local/bin/redis-cli   # 设置软链

cd -    # 返回到上一次的工作目录  /src

cd ..   # 返回上一层目录 

#  复制 脚本文件, 赋值权限, 修改脚本文件,启动的配置文件依据端口号启动
cp -rf ./init.d/redis /etc/init.d/redis 
chmod 755 /etc/init.d/redis
sed -i "s@REDISPORT=6379@REDISPORT=${redis_port}@g" /etc/init.d/redis  

# 后台运行 数据存储的位置 日志存储位置
mkdir $redis_install_dir/etc 
mkdir -p /data/redis 
mkdir -p /data/logs/redis
mv -f $redis_install_dir/redis.conf  $redis_install_dir/etc/${redis_port}.conf

# 直接修改读取的文件内容,修改配置文件
sed -i 's@daemonize no@daemonize yes@g' $redis_install_dir/etc/${redis_port}.conf  # 后台运行
sed -i 's@dir ./@dir /data/redis@g' $redis_install_dir/etc/${redis_port}.conf # 数据存储的位置
sed -i 's@logfile ""@logfile /data/logs/redis/redis.log@g' $redis_install_dir/etc/${redis_port}.conf # 日志存储位置
sed -i "s@# requirepass foobared@requirepass ${redis_root_pass}@g" $redis_install_dir/etc/${redis_port}.conf # 登录密码
sed -i "s@port 6379@port ${redis_port}@g" $redis_install_dir/etc/${redis_port}.conf # 端口

# 设置 redis 开机自启服务
update-rc.d redis defaults 

# 刷新 脚本内容，开启服务
if [ $os == "centos" ];then
  chkconfig redis on && chkconfig save
  service redis start
elif [ $os == "ubuntu" ];then
  systemctl daemon-reload  # 刷新 脚本内容
  service redis start
fi      

popd

rm -rf $src_dir/$redis_version # 删除
