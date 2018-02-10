#!/bin/bash                                                                                                                                                  

clear

. include/common.sh # 引入常量文件
. include/public.sh # 引入公用函数

# lnmp 主要进程          
lnmp(){ 

echo -e "$GREEN
#####################################################################
#                       Nginx + PHP + MySQL                         #
#####################################################################"
    . include/sysinfo.sh  # 输出系统信息
    . include/menu.sh    # 执行菜单脚本
    . include/check_install.sh  # 检查安装状态
}

# 执行 lnmp 并且输入 lnmp.log
mkdir log
lnmp 2>&1 | tee ./log/lnmp.log

echo -e "$WHITE"

. /etc/profile



