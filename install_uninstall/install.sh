#!/bin/bash                                                                                                                                                  

clear

. ../include/common.sh # 引入常量文件
. ../include/public.sh # 引入公用函数
. ../include/sysinfo.sh  # 输出系统信息

# lnmp 主要进程          
install() { 

    # 程序开始
    cmd_begin

    echo -e "$GREEN
    #####################################################################
    #               Nginx + PHP + MySQL + Redis + ELKF                  #
    #####################################################################"
    
    # 检查src目录是否存在
    if [ ! -d "./src" ]; then
      mkdir ./src
    fi

    . ./include/install_menu.sh    # 执行菜单脚本

    # 打印执行时间
    cmd_end

    . ./include/check_install.sh  # 检查安装状态
}


select_way=$1 # 参数
select_software=$@ # 全部参数
install 2>&1 | tee ../logs/install.log # 执行 lnmp 且 记录日志

echo -e "$WHITE"

source /etc/profile



