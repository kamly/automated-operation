#!/bin/bash

. ../include/common.sh # 引入常量文件
. ../include/public.sh # 引入公用函数
. ../include/sysinfo.sh # 输出系统信息

. ./include/public.sh

# 备份
redis_backup(){

    check_backup_dir

    if [[ `ps aux | grep redis|grep -v grep|wc -l` == 0 ]];then
        service redis start # redis
    fi

    mkdir $redis_backup
    ${redis_install_dir}/src/redis-cli -h 127.0.0.1 -p ${redis_port} -a "${redis_root_pass}" SAVE # data
    mv ${redis_data}/dump.rdb  ${redis_backup}/redis_`date +%Y%m%d`.rdb # data
    cp -R ${redis_install_dir}/etc ${redis_backup} # etc
        
    if [[ $? == 0 ]];then
        echo -e " ${RED} Backup redis Data success! "
    else
        echo -e " ${RED} Backup failed, pls check... " 
    fi
}

# 导入
redis_import(){
    cp ${redis_backup}/redis_${backup_name}.rdb ${redis_data}/dump.rdb 

    if [[ $? == 0 ]];then
        echo -e " ${RED} import redis Data success! "
    else
        echo -e " ${RED} import failed, pls check... " 
    fi
}


# 备份命令 ./redis_backup_import.sh backup  
# 导入命令(指定日期) ./redis_backup_import.sh import 20180211

if [ ! -d ${redis_install_dir} ];then
    # 没有安装redis
    echo -e "${RED} No Redis Server in your System!!"
else
    if [ -z $1 ];then
        # 没有输入参数
        echo -e "${WHITE} Usage {$0 backup|import}${WHITE}"
        echo
    else
        echo -e "${YELLOW}"
        read -p "Please input Redis server root password (default:root) : " redis_root_pass
        redis_root_pass=${redis_root_pass:=root} # 提供默认

        if [ $1 == "backup" ];then
            echo -e "You select backup Redis Data from ${redis_data}"
            redis_backup
        elif [ $1 == "import" ];then
            if [ -z $2 ];then
                echo -e "${WHITE} Usage { $0 backup|import 20180211 }${WHITE}"
            else
                echo -e "You select import Redis Data to ${data_backup_dir}"
                backup_name=$2
                redis_import
            fi
        else
            echo -e "Usage {$0 backup|import}"
        fi
    fi
fi