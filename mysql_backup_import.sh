#!/bin/bash

. include/common.sh # 引入常量文件
. include/public.sh # 引入公用函数

. include/sysinfo.sh # 输出系统信息

# 备份
mysql_sql_backup(){

    check_backup_dir

    if [[ `ps aux | grep mysql|grep -v grep|wc -l` == 0 ]];then
        service mysqld start # 启动mysql
    fi

    $mysql_install_dir/bin/mysqldump -u$mysql_enter_user -P$mysql_port -p$mysql_root_pass --all-databases > $mysql_data_backup  # 备份
        
    if [[ $? == 0 ]];then
        echo -e " \033[32m Backup Mysql Data success! \033[0m"
    else
        echo -e " \033[32m Backup failed, pls check... \033[0m " 
    fi
}

# 导入
mysql_sql_import(){
    $mysql_install_dir/bin/mysql -u$mysql_enter_user -P$mysql_port -p$mysql_root_pass < ${data_backup_dir}/mysql_$date_name.sql
}


# 备份命令 ./mysql_backup_import.sh backup  
# 导入命令(指定日期) ./mysql_backup_import.sh import 20180211

if [ ! -d $mysql_install_dir ];then
    # 没有安装mysql
    echo -e "${RED} No Mysql Server in your System!!"
else
    if [ -z $1 ];then
        # 没有输入参数
        echo -e "${WHITE} Usage {$0 backup|import}${WHITE}"
        echo
    else
        echo -e "${YELLOW}"
        read -p "Please input Mysql server root password (default:root) : " mysql_root_pass
        mysql_root_pass=${mysql_root_pass:=root} # 提供默认

        if [ $1 == "backup" ];then
            echo -e "You select backup Mysql Data from $mysql_data"
            mysql_sql_backup
        elif [ $1 == "import" ];then
            if [ -z $2 ];then
                echo -e "${WHITE} no input date name ${WHITE}"
            else
                echo -e "You select import Mysql Data to $data_backup_dir"
                $date_name=$2
                mysql_sql_import
            fi
        else
            echo -e "Usage {$0 backup|import}"
        fi
    fi
fi