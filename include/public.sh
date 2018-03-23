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

# 下载
check_dir_exist() {
     if [[ ! -d $* ]] ; then
        mkdir -p $*
        echo -e " \033[32m Creat $* Successful! \033[0m"
    fi
}