#!/bin/bash  


# 程序开始
cmd_begin(){
    # 记录开始时间，时间戳
    time_begin=$(date +%s)   
}

cmd_end(){
    echo -e "\033[0m"
    time_end=`date +%s`
	((time_use=${time_end}-${time_begin}))
	((time_use_m=${time_use}/60))
	((time_use_s=${time_use}%60))
	echo "Install use ${time_use_m}Min ${time_use_s}Sec "
}


# 下载
down_url(){
    wget -c --no-check-certificate $*
}

# 检查有没有备份目录  移走
check_backup_dir(){
    if [[ ! -d ${data_backup_dir} ]] ; then
        mkdir -p $data_backup_dir
        echo -e " \033[32m Creat $data_backup_dir Successful! \033[0m"
    fi
}