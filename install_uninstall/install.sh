#!/bin/bash                                                                                                                                                  

clear

. ../include/common.sh # 引入常量文件
. ../include/public.sh # 引入公用函数
. ../include/sysinfo.sh  # 输出系统信息

# lnmp 主要进程          
lnmp(){ 

    # 程序开始
    cmd_begin

    echo -e "$GREEN
    #####################################################################
    #               Nginx + PHP + MySQL + Redis + ELKF                  #
    #####################################################################"
    
    . ./include/menu.sh    # 执行菜单脚本

    # 打印执行时间
    cmd_end

    . ./include/check_install.sh  # 检查安装状态
}


select_way=$1 # 参数
select_software=$@ # 全部参数
lnmp  # 执行 lnmp

echo -e "$WHITE"

source /etc/profile



