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

#  复制 脚本文件, 赋值权限
cp -rf ./init.d/redis /etc/init.d/redis 
chmod 755 /etc/init.d/redis

# 设置 redis 开机自启服务
update-rc.d redis defaults 

# 后台运行 数据存储的位置 日志存储位置
mkdir $redis_install_dir/etc 
mkdir -p /data/redis 
mkdir -p /data/logs/redis
mv -f $redis_install_dir/redis.conf  $redis_install_dir/etc/6379.conf

# 直接修改读取的文件内容，而不是输出到终端 取代
sed -i 's@daemonize no@daemonize yes@g' $redis_install_dir/etc/6379.conf  # 后台运行
sed -i 's@dir ./@dir /data/redis@g' $redis_install_dir/etc/6379.conf # 数据存储的位置
sed -i 's@logfile ""@logfile /data/logs/redis/redis.log@g' $redis_install_dir/etc/6379.conf # 日志存储位置

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
