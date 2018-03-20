#!/bin/bash  

# 检查有没有备份目录  移走
check_backup_dir(){
    if [[ ! -d ${data_backup_dir} ]] ; then
        mkdir -p $data_backup_dir
        echo -e " \033[32m Creat $data_backup_dir Successful! \033[0m"
    fi
}