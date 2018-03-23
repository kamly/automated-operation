#!/bin/bash

. ../include/common.sh # 引入常量文件
. ../include/public.sh # 引入公用函数
. ../include/sysinfo.sh # 输出系统信息

. ./include/public.sh

# 备份
nginx_backup(){

    check_dir_exist ${data_backup_dir}

    if [[ `ps aux | grep nginx|grep -v grep|wc -l` == 0 ]];then
        service nginx start # 
    fi

    mv  /data/www /data/www_backup # www 只是移动目录
    check_dir_exist ${nginx_backup}
    cp -R ${nginx_install_dir}/ssl ${nginx_backup} # ssl
    cp -R ${nginx_install_dir}/conf ${nginx_backup} # conf
        
    if [[ $? == 0 ]];then
        echo -e " \033[32m Backup nginx Data success! \033[0m"
    else
        echo -e " \033[32m Backup failed, pls check... \033[0m " 
    fi
}



# 备份命令 ./nginx_backup_import.sh backup  

if [ ! -d ${nginx_install_dir} ];then
    # 没有安装nginx
    echo -e "${RED} No Nginx Server in your System!!"
else
    if [ -z $1 ];then
        # 没有输入参数
        echo -e "${WHITE} Usage {$0 backup|import}${WHITE}"
        echo
    else
        if [ $1 == "backup" ];then
            nginx_backup
        else
            echo -e "Usage {$0 backup|import}"
        fi
    fi
fi