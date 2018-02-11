#!/bin/bash

. include/common.sh # 引入常量文件
. include/public.sh # 引入公用函数

. include/sysinfo.sh # 输出系统信息

reset_redis_pwd(){

	read -p "Please input New Redis root password (default:root) : " redis_root_pass
	redis_root_pass=${redis_root_pass:=root} # 提供默认      

    # 修改密码
    sed -i "s@requirepass@requirepass ${redis_root_pass}@g" $redis_install_dir/etc/${redis_port}.conf

	service redis restart
    
    if [ $? == 0 ]; then
		echo -e "New Redis server root password is \033[41m $redis_root_pass \033[0m"		
	else
		echo -e "fail"	
	fi
}
reset_redis_pwd
