#!/bin/bash                                                                                                                                               

# 记录开始时间，时间戳
time_begin=$(date +%s)   

# 获取ip
get_ip(){
    ip=$(ip addr | grep "scope global" | awk  '{ print $2 }' | cut -d"/" -f 1)
    echo "IP :$ip"       
}

# 获取CPU
cpu_info(){
    cpu_info=`cat /proc/cpuinfo  | grep "model name" | uniq | awk -F: '{print $2}'`
    echo "CPU:$cpu_info" 
}


# 获取内存大小
mem_info(){
    mem_total=`free -m | grep "Mem" | awk '{print $2}'`
    echo "Memory:$mem_total MB"
}


# 获取系统类型+多少位
chk_os(){
    if [ -f /etc/redhat-release ];then
        os_cat=`cut -d'.' -f1,2 /etc/redhat-release`
        echo "OS : $os_cat"
        [ `grep -i cent /etc/redhat-release | wc -l` -eq "1" ]  && os=centos
    elif [ -f /etc/issue ];then
        os_cat=`cut -d'.' -f1,2 /etc/issue | tr -d '\n'`
        echo "OS : $os_cat"
        [ `grep -i ubuntu /etc/issue | wc -l` -eq "1" -o `grep -i debian /etc/issue | wc -l` -eq "1" ] && os=ubuntu
    else
        echo "Unknow OS"
        exit
    fi
    sysbit=`uname -a | grep 64 | wc -l`
    [ $sysbit -eq "1" ] && echo "Sysbit: 64bit" || echo "Sysbit: 32bit"
}


# 获取硬盘
chk_disk(){
    disk_free=`df -h | grep /dev | grep \/$ |awk '{print $4}'`
    echo "Disk free size: $disk_free"
}

# 获取时间
chk_date(){
    echo "Date:`date`"
}


# 输出系统信息
sysinfo(){
    echo -e "$RED"
    echo "--------------------------------------------------------------------"
    get_ip # 获取ip
    cpu_info # 获取CPU
    mem_info # 获取内存大小
    chk_os # 获取系统类型+多少位
    chk_disk # 获取硬盘
    chk_date
    echo "--------------------------------------------------------------------"
}

# 执行
sysinfo





