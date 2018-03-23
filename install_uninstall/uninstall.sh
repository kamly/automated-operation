#!/bin/bash

# ------------------------
#  卸载规则
#  1. 确认该目录是否存在
#  2. 停止运行
#  3. 删除开机自启服务
#  4. 删除服务脚本
#  5. 删除/bin/ 软连
#  6. 删除/data/xxx 数据目录
#  7. 删除/data/logs/xxx 日志目录
#  8. 删除/usr/local/xxx 软件目录
# ------------------------

clear

. ../include/common.sh # 引入常量文件
. ../include/public.sh # 引入公用函数
. ../include/sysinfo.sh # 输出系统信息



# lnmp 主要进程          
uninstall(){ 

    # 程序开始
    cmd_begin

    echo -e "$GREEN
    #####################################################################
    #               Nginx + PHP + MySQL + Redis + ELKF                  #
    #####################################################################"
    
    . ./include/uninstall_menu.sh    # 执行菜单脚本

    # 打印执行时间
    cmd_end

    . ./include/check_install.sh  # 检查安装状态
}


select_way=$1 # 参数
select_software=$@ # 全部参数
uninstall 2>&1 | tee ../logs/uninstall.log # 执行 lnmp 且 记录日志

echo -e "$WHITE"

source /etc/profile














