#!/bin/bash

clear

. include/common.sh # 引入常量文件
. include/public.sh # 引入公用函数

. include/sysinfo.sh # 输出系统信息

reset_mysql_pwd(){

	read -p "Please input Old Mysql root password (default:root) : " mysql_old_pass
	mysql_old_pass=${mysql_old_pass:=root} # 提供默认      

	read -p "Please input New Mysql root password (default:root) : " mysql_root_pass
	mysql_root_pass=${mysql_root_pass:=root} # 提供默认      

	${mysql_install_dir}/bin/mysqladmin -u${mysql_enter_user} -P${mysql_port} -p"${mysql_old_pass}" password "${mysql_root_pass}"

	if [ $? == 0 ]; then
		echo -e "New Mysql server root password is \033[41m $mysql_root_pass \033[0m"	
	else
		echo -e "fail"	
	fi
}
reset_mysql_pwd

