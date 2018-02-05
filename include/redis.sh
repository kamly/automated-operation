#!/bin/bash                                                                                                                                                  

## 安装包就是文件

pushd $src_dir

[ ! -d $redis_version ] && tar zxf $redis_gz

cp -rf $redis_version $redis_install_dir

cd $redis_install_dir    

make    

[ ! -L /usr/local/bin/redis-server ] && ln -fs ${redis_install_dir}/src/redis-server /usr/local/bin/redis-server # 设置软链

[ ! -L /usr/local/bin/redis-cli ] && ln -fs ${redis_install_dir}/src/redis-cli  /usr/local/bin/redis-cli   # 设置软链

cd -    # 返回到上一次的工作目录  /src

cd ..   # 返回上一层目录 

cp -rf ./init.d/redis /etc/init.d/redis #  复制脚本文件
chmod 755 /etc/init.d/redis
update-rc.d redis defaults 

# 复制配置文件,修改配置文件，后台运行+数据存储的位置+日志存储位置
if [ ! -f /etc/redis/redis.conf ];then
  mkdir $redis_install_dir/etc 
  [ ! -d /data/redis ] && mkdir -p /data/redis 
  [ ! -d /data/logs/redis ] && mkdir -p /data/logs/redis
  mv -f $redis_install_dir/redis.conf  $redis_install_dir/etc/6379.conf
  sed -i 's@daemonize no@daemonize yes@g' $redis_install_dir/etc/6379.conf  # 直接修改读取的文件内容，而不是输出到终端 取代
  sed -i 's@dir ./@dir /data/redis@g' $redis_install_dir/etc/6379.conf 
  sed -i 's@logfile ""@logfile /data/logs/redis/redis.log@g' $redis_install_dir/etc/6379.conf 
fi

# 重启服务，配置服务
if [ $os == "centos" ];then
  chkconfig redis on && chkconfig save
  service redis start
elif [ $os == "ubuntu" ];then
  systemctl daemon-reload  # 刷新脚本内容
  service redis start
fi      

popd

rm -rf $src_dir/$redis_version # 删除
