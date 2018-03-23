#!/bin/bash


# 安装 ntpdate
sync_time(){
    check_ntpdate=`which ntpdate|grep ntpdate |wc -l`
    if [[ "$os" == "centos" ]];then
        [ "$check_ntpdate" != "1" ] && yum install -y ntp
    elif [[ "$os" == "ubuntu" ]];then
        [ "$check_ntpdate" != "1" ] && apt-get update -y && apt-get install -y ntpdate  # 更新源包 安装ntpdate 
    fi
    ntpdate asia.pool.ntp.org  # 同步asia命令
    hwclock -w # 将系统时钟同步到硬件时钟
}
sync_time


# 调整时间 
sync_zone(){
    zone=`date -R | grep '+0800'|wc -l` # 输出date,匹配+0800,统计行数
    # 0!=1 no /etc/localtime   1==1 rm -rf /etc/localtime  && 前的命令执行成功了就继续执行后面的命令
    test $zone != 1 &&  echo "no /etc/localtime" || rm -rf /etc/localtime  && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    echo "Now timezone is `date +"%Z %z"`"
}
sync_zone
