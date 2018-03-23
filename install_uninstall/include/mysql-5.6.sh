#!/bin/bash

. ./include/mysql.sh

install_mysql_5.6(){
  
    before_install_mysql # 校验用户是否存在+安装mysql之前备份数据
  
    if [ $os == "centos" ];then
      if [[ "$mysql_install_wayway" == 1 ]];then
        mysql_install_5.6_bin
      elif [[ "$mysql_install_wayway" == 2 ]];then
        mysql_install_5.6_cmake
      fi
    elif [ $os == "ubuntu" ];then
      if [[ $mysql_install_wayway == 1 ]];then
        mysql_install_5.6_bin
      elif [[ $mysql_install_wayway == 2 ]];then
        mysql_install_5.6_cmake
      fi
    else
      echo -e "Unknow OS,exit..."
      exit
    fi
  
    mysql_install_boot # 设置权限

}
install_mysql_5.6    


