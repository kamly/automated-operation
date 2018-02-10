#!/bin/bash

# ------------------------
#  卸载规则
#  1. 确认该目录是否存在
#  2. 停止运行
#  3. 删除开机自启服务
#  4. 删除服务脚本
#  5. 删除/bin/ 软连
#  6. 删除/data/xxx 数据目录
#  7. 删除/data/logs/xxx 日志目录
#  8. 删除/usr/local/xxx 软件目录
# ------------------------

clear

. ./include/common.sh

. ./include/sysinfo.sh

# 卸载 Nginx
uninstall_ngx(){
	echo -e "$YELLOW"
	read -p "Please Choose Uninstall nginx or Not! ( y,Y/n,N )" uninstall_ngx
	case $uninstall_ngx in
	y|Y)
		if [ -d $ngx_dir ];then # 确认该目录是否存在
			
			service nginx stop  && sleep 3  # 停止运行
			# ps -eaf | grep nginx | grep master | awk  '{print $2}' | xargs kill -9
			
			# 删除开机自启服务
			if [ "$os" == "centos" ];then
				chkconfig nginx off && chkconfig save
			elif [ "$os" == "ubuntu" ];then
				update-rc.d nginx remove	
			fi

			rm -rf /etc/init.d/nginx  # 删除服务脚本

			# 删除 /bin/ /data/xxx data/logs/xxx /usr/local/xxx
			rm -rf  /usr/bin/nginx  $ngx_root_dir $ngx_logs $ngx_dir 
			
			echo  "Uninstall nginx successful!" 
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



	
# 卸载 Php
uninstall_php(){
	echo -e "$YELLOW"
	read -p "Please Choose Uninstall php or Not! ( y,Y/n,N )" uninstall_php
	case $uninstall_php in
	y|Y)
		# 选择卸载的版本
		while :;do 
			echo -e "$YELLOW"
			echo -e "Please choose PHP version uninstall:
			$RED 1)$WHITE php-5.6.30 $GREEN( Default );
			$RED 2)$WHITE php-7.1.6;"
			read -p "Your select:" php_version_select
			if [[ ! $php_version_select =~ ^[1,2]$ ]];then
				echo -e "\033[0m Please input 1/2 \033[33m"
			else
				break
			fi  
		done

    	if [ -d $php_dir/${php_version[${php_version_select}]} ];then # 确认该目录是否存在
     		
			service php-fpm stop && sleep 3  # 方法1 停止运行
			# ps -ef | grep php-fpm | grep -v grep | awk  '{print $2}' | xargs kill -9 # 方法2 停止运行
			
			# 删除开机自启服务
			if [ "$os" == "centos" ];then
				chkconfig php-fpm off && chkconfig save
			elif [ "$os" == "ubuntu" ];then
				update-rc.d php-fpm remove
			fi        

			rm -rf  /etc/init.d/php-fpm # 删除服务脚本

			# 删除 /bin/ /data/logs/xxx /usr/local/xxx
			rm -rf  /usr/bin/php /data/logs/php $php_dir/${php_version[${php_version_select}]} 
			
			echo  "Uninstall php successful!"
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




# 卸载 Redis
uninstall_redis(){
	echo -e "$YELLOW"
	read -p "Please Choose Uninstall redis or Not! ( y,Y/n,N )" uninstall_redis
	case $uninstall_redis in
	y|Y)
		if [ -d $redis_install_dir ];then # 确认该目录是否存在
			service redis stop && sleep 3  # 停止运行
			# ps aux | grep redis | grep -v grep | awk '{ print $2 }' | xargs kill -9 
			
			# 删除开机自启服务
			if [ $os == "ubuntu" ];then
				update-rc.d -f redis remove
			fi

			rm -rf  /etc/init.d/redis # 删除服务脚本

			# 删除 /bin/ /data/xxx data/logs/xxx /usr/local/xxx
			rm -rf  /usr/local/bin/redis-server /usr/local/bin/redis-cli  /data/redis /data/logs/redis $redis_install_dir 

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





# 卸载 mysql
uninstall_mysql(){

	echo -e "$YELLOW"
	read -p "Please Choose Uninstall mysql or Not! ( y,Y/n,N )" uninstall_mysql
	case $uninstall_mysql in
	y|Y)
		if [ -d $mysql_local ];then  # 确认该目录是否存在
		
			service mysqld stop && sleep 3  # 停止运行
			# ps aux | grep mysql | grep -v grep | awk '{ print $2 }' | xargs kill -9 
			
			# 删除开机自启服务
			if [ $os == "ubuntu" ];then
				update-rc.d -f mysqld remove
			fi

			rm -rf /etc/init.d/mysqld # 删除服务脚本

			# 删除 /data/xxx data/logs/xxx /usr/local/xxx
			rm -rf /data/mysql /data/logs/mysql /usr/local/mysql 

			# 删除命令
			sed -i '/mysql\/bin/'d /etc/profile
			echo "export PATH=~/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin" >> /etc/profile
			source /etc/profile

			# 删除 mysql.sock
			rm -rf /var/lib/mysql

			# 使用ldconfig命令将/usr/local/mysql加入到默认库
			rm -rf /etc/ld.so.conf.d/mysql.conf

			echo "Uninstall mysql successful!"
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
