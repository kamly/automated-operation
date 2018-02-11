#!/bin/bash

. include/common.sh # 引入常量文件
. include/public.sh # 引入公用函数

. include/sysinfo.sh # 输出系统信息

reset_redis_pwd(){

    read -p "Please input Old Redis root password (default:root) : " redis_old_pass
	redis_old_pass=${redis_old_pass:=root} # 提供默认   

	read -p "Please input New Redis root password (default:root) : " redis_root_pass
	redis_root_pass=${redis_root_pass:=root} # 提供默认        

    # 在内部进行修改
    $redis_install_dir/src/redis-cli -h 127.0.0.1 -p ${redis_port} -a "${redis_old_pass}" config set requirepass ${redis_root_pass}

    # 在外部修改
    service redis stop # 停止服务

    sed -i "s/^requirepass.*$/requirepass ${redis_root_pass}/g" $redis_install_dir/etc/${redis_port}.conf  # 登录密码 配置文件
    sed -i "s/^PASSWORD.*$/PASSWORD=${redis_root_pass}/g" /etc/init.d/redis  # 登录密码 脚本服务
    systemctl daemon-reload

	service redis start # 启动服务
    if [ $? == 0 ]; then
		echo -e "New Redis server root password is \033[41m $redis_root_pass \033[0m"		
	else
		echo -e "fail"	
	fi
}
reset_redis_pwd
