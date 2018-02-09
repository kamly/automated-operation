#!/bin/bash

# 检查运行状态
echo -e "${GREEN}---------------------------------------------------------------------"
for i in  nginx mysql php redis pureftp
do
    chk_status=`ps aux | grep $i | grep -v grep | wc -l`
    [ "$chk_status" -ne 0 ] && echo "$i is Running!" || echo "$i is NOT Running!"
    [ "$chk_status" -ne 0 ] && echo "You can use:  service $i start|stop|restart|status|reload"
    echo "---------------------------------------------------------------------"
done


# 打印执行时间
echo -e "\033[0m"
if [[ $sync_time_yn =~ ^[y,Y]$ ]] || [[ $repo_yn =~ ^[y,Y]$ ]] || [[ $install_ngx_yn =~ ^[y,Y]$ ]] || [[ $install_mysql_yn =~ ^[y,Y]$ ]] || [[ $install_php_yn =~ ^[y,Y]$ ]] || [[ $install_redis_yn =~ ^[y,Y]$ ]];then
	time_end=`date +%s`
	((time_use=${time_end}-${time_begin}))
	((time_use_m=${time_use}/60))
	((time_use_s=${time_use}%60))
	echo "Install use ${time_use_m}Min ${time_use_s}Sec "
fi

# 在centos中关闭防火墙
stop_firewall(){
    if [ $os == "centos" ];then
        if [[ `awk -F. '{ print $1 }' /etc/redhat-release | grep 7 | wc -l` -eq 1 ]];then
            systemctl stop firewalld.service
            systemctl disable firewalld.service
        fi
    fi
}
stop_firewall

# 在centos中关闭selinux
close_selinux(){
    if [ "$os" == "centos" ];then
        [ -f /etc/selinux/config ] && sed -i "s#SELINUX=enforcing#SELINUX=disabled#g"  /etc/selinux/config
        setenforce 0
    fi
}
close_selinux