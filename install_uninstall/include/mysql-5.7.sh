#!/bin/bash


. ./include/mysql.sh

mysql_install_5.7(){

    before_install_mysql # 校验用户是否存在+安装mysql之前备份数据

    if [[ $os == "centos" ]];then
        if [[ "$mysql_install_wayway" == 1 ]];then
            mysql_install_5.7_bin
        elif [[ "$mysql_install_wayway" == 2 ]];then
            mysql_install_5.7_cmake
        fi
    elif [[ $os == "ubuntu" ]];then
        if [[  "$mysql_install_wayway" == 1 ]];then
            mysql_install_5.7_bin
        elif [[ "$mysql_install_wayway" == 2 ]];then
            mysql_install_5.7_cmake
        fi
    else
        echo -e "Unknow OS,exit..."
        exit
    fi

    mysql_install_boot # 设置权限
}
mysql_install_5.7
