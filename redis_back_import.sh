#!/bin/bash

. include/common.sh # 引入常量文件
. include/public.sh # 引入公用函数

. include/sysinfo.sh # 输出系统信息

# 备份
redis_backup(){

    if [[ ! -d ${data_backup_dir} ]] ; then
        mkdir -p $data_backup_dir
        echo -e " \033[32m Creat $data_backup_dir Successful! \033[0m"
    fi

    if [[ `ps aux | grep redis|grep -v grep|wc -l` == 0 ]];then
        service redis start # redis
    fi

    $redis_install_dir/src/redis-cli -h 127.0.0.1 -p ${redis_port} -a "${redis_root_pass}" SAVE # 备份
    mv $redis_data/dump.rdb  $redis_data_backup
        
    if [[ $? == 0 ]];then
        echo -e " \033[32m Backup redis Data success! \033[0m"
    else
        echo -e " \033[32m Backup failed, pls check... \033[0m " 
    fi
}

# 导入
redis_import(){
    mv $data_backup_dir/redis_/$backup_name.rdb $redis_data/dump.rdb 
}


# 备份命令 ./redis_backup_import.sh backup  
# 导入命令(指定日期) ./redis_backup_import.sh import 20180211

if [ ! -d $redis_install_dir ];then
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
            echo -e "You select backup Redis Data from $redis_data"
            redis_backup
        elif [ $1 == "import" ];then
            if [ -z $2 ];then
                echo -e "${WHITE} Usage { $0 backup|import 20180211 }${WHITE}"
            else
                echo -e "You select import Redis Data to $data_backup_dir"
                backup_name=$2
                redis_import
            fi
        else
            echo -e "Usage {$0 backup|import}"
        fi
    fi
fi