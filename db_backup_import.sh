#!/bin/bash

. include/common.sh

# 备份
mysql_sql_backup(){
    if [[ ! -d ${data_backup_dir} ]] ; then
        mkdir -p $data_backup_dir
        echo -e " \033[32m Creat $data_backup_dir Successful! \033[0m"
    fi

    if [ `ps aux | grep mysql|grep -v grep|wc -l` -eq "0" ];then
        /etc/init.d/mysqld start
    fi

    $mysql_local/bin/mysqldump -u$mysql_enter_user -p$mysql_root_pass --all-databases > $mysql_data_backup  # 备份数据库
        
    if [[ $? -eq 0  ]];then
        echo -e " \033[32m Backup Mysql Data success! \033[0m"
    else
        echo -e " \033[32m Backup failed, pls check... \033[0m " 
    fi
}

# 导入
mysql_sql_import(){
    $mysql_local/bin/mysql -u$mysql_enter_user -p$mysql_root_pass < $mysql_data_backup
}

# ./db_backup_import.sh backup
# 主菜单
[ ! -d $mysql_local ] && echo -e "${RED} No Mysql Server in your System!!" && exit 1
if [ -z $1 ];then
	echo -e "${WHITE}Usage {$0 backup|import}${WHITE}"
	echo
else
	echo -e "${YELLOW}"
	read -p "Please input Mysql server root password : " mysql_root_pass

	if [ $1 == "backup" ];then
		echo -e "You select backup Mysql Data from $mysql_data"
		mysql_sql_backup
	elif [ $1 == "import" ];then
		echo -e "You select import Mysql Data to $data_backup_dir"
		mysql_sql_import
	else
		echo -e "Usage {$0 backup|import}"
	fi
fi
