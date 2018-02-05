#!/bin/bash

clear

. ./include/common.sh

. ./include/sysinfo.sh

# Uninstall Nginx
uninstall_ngx(){
	echo -e "$YELLOW"
	read -p "Please Choose Uninstall nginx or Not! ( y,Y/n,N )" uninstall_ngx

	case $uninstall_ngx in
	y|Y)
		if [ -d $ngx_dir ];then
			service nginx stop  # 停止
			if [ "$os" == "centos" ];then
				chkconfig nginx off && chkconfig save
			elif [ "$os" == "ubuntu" ];then
				update-rc.d nginx remove	# 移除服务 
			fi
			rm -rf /etc/init.d/nginx  # 移除服务脚本
			rm -rf /usr/local/nginx /usr/bin/nginx && echo  "Uninstall nginx successful!" # 删除 软链 和 文件
		else
			echo
			echo "No nginx installed in your system!!"
		fi
	;;
	n|N)
		echo
		echo  "You select not uninstall nginx!"
	;;
	*)
		echo
		echo  "Input error to uninstall nginx!"
	;;
	esac
}
uninstall_ngx



	
#Uninstall Php
uninstall_php(){
	echo -e "$YELLOW"
	read -p "Please Choose Uninstall php or Not! ( y,Y/n,N )" uninstall_php

	case $uninstall_php in
	y|Y)
		while :;do 
			echo -e "$YELLOW"
			echo -e "Please choose PHP version:
			$RED 1)$WHITE php-5.6.30 $GREEN( Default );
			$RED 2)$WHITE php-7.1.6;"
			read -p "Your select:" php_version_select
		if [[ ! $php_version_select =~ ^[1,2]$ ]];then
			echo -e "\033[0m Please input 1/2 \033[33m"
		else
			break
		fi  
		done

    	if [ -d $php_dir/${php_version[${php_version_select}]} ];then
     		service php-fpm stop 
			ps -ef | grep php-fpm | grep -v grep | awk  '{print $2}' | xargs kill -9 
			if [ "$os" == "centos" ];then
				chkconfig php-fpm off && chkconfig save
			elif [ "$os" == "ubuntu" ];then
				update-rc.d php-fpm remove
			fi        
			rm -rf  /etc/init.d/php-fpm
			rm -rf  $php_dir/${php_version[${php_version_select}]} /usr/bin/php && echo  "Uninstall php successful!"
    	else
     	 echo "No php installed in your system!!"
    	fi 
	;;
	n|N)
			echo
			echo "You select not uninstall php!"
	;;
	*)
			echo
			echo  "Input error to uninstall php! "
	;;
	esac
}
uninstall_php




#Uninstall Redis
uninstall_redis(){
	echo -e "$YELLOW"
	read -p "Please Choose Uninstall redis or Not! ( y,Y/n,N )" uninstall_redis

	case $uninstall_redis in
	y|Y)
		if [ -d $redis_install_dir ];then
			service redis stop 
			ps aux | grep redis | grep -v grep | awk '{ print $2 }' | xargs kill -9 
			if [ $os == "ubuntu" ];then
				apt-get remove redis -f 
				update-rc.d -f redis remove
			fi
			rm -rf $redis_install_dir   /etc/init.d/redis /usr/local/bin/redis-server /usr/local/bin/redis-cli
			echo "Uninstall redis successful!"
		else
			echo "No redis installed in your system!"
		fi
	;;
	n|N)
		echo "You select not uninstall redis!"
	;;
	*)
		echo  "Input error to uninstall redis! "
	;;
	esac
}
uninstall_redis





#Uninstall mysql
uninstall_mysql(){

	echo -e "$YELLOW"
	read -p "Please Choose Uninstall mysql or Not! ( y,Y/n,N )" uninstall_mysql

	case $uninstall_mysql in
	y|Y)
		if [ -d $mysql_local ];then

			if [ `ps aux | grep mysql | grep -v grep|wc -l` != "0" ];then
				service mysqld start
			fi

			read -p "Enter old mysql password for Backup:" mysql_root_pass
			$mysql_local/bin/mysqldump -u$mysql_enter_user -p$mysql_root_pass --all-databases > $mysql_data_backup  # 备份数据库
			service mysqld stop
			sleep 3

			[ -d /var/lib/mysql ] && rm -rf /var/lib/mysql

			[ -f "/etc/init.d/mysqld" ] && rm -rf /etc/init.d/mysqld

			# 备份配置文件+数据
			[ ! -d /data/backup ] && mkdir -p /data/backup

			[ -f "/etc/my.cnf" ] && cp -f /etc/my.cnf $data_backup_dir/my.cnf_`date +%Y%m%d%H%M`

			[ -d "/data/mysql" ] && mv -f /data/mysql $data_backup_dir/mysql_`date +%Y%m%d%H%M`

			service mysqld stop
			
			ps aux | grep mysql | grep -v grep | awk '{ print $2 }' | xargs kill -9 
			
			rm -rf /usr/local/mysql /usr/bin/mysql /data/logs/mysql

			[ `ps aux | grep mysql | grep -v grep|wc -l` == "0" ] && [ ! -d $mysql_local ] && echo  "Uninstall mysql successful!"
			
			cp -f /etc/profile /etc/profile_bk &&  sed -i '/mysql\/bin/'d /etc/profile && sed -i '/export PATH=\/bin/'d /etc/profile
			
			echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:" >> /etc/profile
			
		else
			echo
			echo -e "No Mysql Server installed in your system!!"
		fi
		
	;;
	n|N)
			echo
			echo  "You select not uninstall Mysql!"
	;;
	*)
			echo
			echo  "Input error to uninstall Mysql!!! "
	;;
	esac
}
uninstall_mysql
