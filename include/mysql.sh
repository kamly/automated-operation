#!/bin/bash


# 校验用户是否存在+安装mysql之前备份数据
before_install_mysql(){

    # 校验用户是否存在
    if [[ `grep mysql /etc/passwd | wc -l` == 0 ]];then
        groupadd $mysql_group
        useradd -r -g $mysql_group -s /bin/false $mysql_user
    fi

    # 备份数据库 编码文件 整个数据库
    if [ -d $mysql_local ];then
        /etc/init.d/mysqld start  # 开启数据库
        $mysql_local/bin/mysqldump -u$mysql_enter_user -p$mysql_root_pass --all-databases > $mysql_data_backup  # 备份数据库
        /etc/init.d/mysqld stop && echo "Now is stoping mysql..." # 停止数据库

        mv -f $mysql_local $mysql_old_dir # 移动旧的数据库编码文件 （其实无用）

        [ -d $mysql_data ] && mv -f $mysql_data $data_backup_dir/mysql_`date +%Y%m%d%H%M` # 移动数据库
    fi
}


# mysql二进制安装需要errmsg.sys  （有问题）
# cp_errmsg(){ 
#     [ ! -d /usr/share/mysql ] && mkdir -p /usr/share/mysql # 创建目录
#     if [ ! -f /usr/share/mysql/errmsg.sys ];then
#         cp $mysql_local/share/english/errmsg.sys /usr/share/mysql/
#     fi
# }


# 二进制安装 5.6 二进制
mysql_install_5.6_bin(){

    if [ $os == "centos" ];then
         yum install -y wget autoconf libaio  numactl.x86_64 
    elif [ $os == "ubuntu" ];then
        apt-cache search libaio && apt-get install -y libaio1 libaio-dev
    fi

    pushd $src_dir

    down_url ${mysql_down_url[1]}/${mysql_bin_tar[1]}
    if [ $? != 0 ];then  # 执行失败!=0
        echo "Download ${mysql_bin_tar[1]} failed,please contact author!"
        exit
    fi
    
    tar zmxf ${mysql_bin_tar[1]} && rm -rf ${mysql_bin_tar[1]} 

    mv -f ${mysql_bin[1]} $mysql_local

    cp_errmsg # mysql二进制安装需要errmsg.sys

    popd
}


# 编译安装 5.6 构建源码
mysql_install_5.6_cmake(){
    
    if [ $os == "centos" ];then
        yum -y install make gcc-c++ cmake bison-devel  ncurses-devel
    elif [ $os == "ubuntu" ];then
        apt-get update -y
        apt-get install -y -f build-essential mlocate net-tools bzip2 autoconf make cmake  gcc screen psmisc
        apt-get install -y libncurses5-dev
    fi

    pushd $src_dir 


    down_url ${mysql_down_url[1]}/${mysql_sou_tar[1]}
    if [ $? != 0 ];then  # 执行失败!=0
        echo "Download ${mysql_sou_tar[1]} failed,please contact author!"
        exit
    fi
    
    tar  zmxf ${mysql_sou_tar[1]} 
    
    cd ${mysql_sou[1]}
    
    # 编译安装
    cmake . -DCMAKE_INSTALL_PREFIX=$mysql_local \
    -DMYSQL_DATADIR=$mysql_data \
    -DSYSCONFDIR=/etc \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_MEMORY_STORAGE_ENGINE=1 \
    -DWITH_READLINE=1 \
    -DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock \
    -DMYSQL_TCP_PORT=3306 \
    -DENABLED_LOCAL_INFILE=1 \
    -DWITH_PARTITION_STORAGE_ENGINE=1 \
    -DEXTRA_CHARSETS=all \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci
    
    make -j `grep processor /proc/cpuinfo | wc -l` && make install
    
    rm -rf ${mysql_sou[1]} ${mysql_sou_tar[1]}
    
    popd
}

# 二进制安装 5.7 二进制
mysql_install_5.7_bin(){

    pushd $src_dir

    if [[ $os == "centos" ]];then
         yum install -y wget autoconf libaio  numactl.x86_64 
    elif [[ $os == "ubuntu" ]];then
        apt-cache search libaio && apt-get install -y libaio1 libaio-dev
    fi
    
    down_url ${mysql_down_url[2]}/${mysql_bin_tar[2]}
    if [ $? -ne 0 ];then
        echo "Download ${mysql_bin_tar[2]} failed,please contact author!"
    fi
 
    tar zmxf ${mysql_bin_tar[2]} && rm -rf ${mysql_bin_tar[2]} 

    mv -f ${mysql_bin[2]} $mysql_local

    mkdir ${mysql_local}/mysql-files

    chmod 755 ${mysql_local}/mysql-files

    # cp_errmsg

    popd
}

# 编译安装 5.7 构建源码
mysql_install_5.7_cmake(){

    if [ $os == "centos" ];then
        yum install -y gcc gcc-c++ ncurses ncurses-devel cmake libaio
    else
        apt-get update -y
        apt-get install -y -f build-essential mlocate net-tools bzip2 autoconf make cmake  gcc screen psmisc
        apt-get install -y libncurses5-dev
    fi

    pushd $src_dir

    down_url ${mysql_down_url[2]}/${mysql_sou_tar[2]}
    if [ $? -ne 0 ];then
        echo "Donwload ${mysql_sou_tar[2]} failed,please contact author!"
        exit
    fi
    
    tar zmxf ${mysql_sou_tar[2]}

    tar zmxf ${boost_version_tar}

    cd ${mysql_sou[2]}
    cmake . -DCMAKE_INSTALL_PREFIX=$mysql_local \
    -DMYSQL_DATADIR=$mysql_data \
    -DDOWNLOAD_BOOST=1 \
    -DWITH_BOOST=$src_dir/$boost_version \   
    -DSYSCONFDIR=/etc \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_PARTITION_STORAGE_ENGINE=1 \
    -DWITH_FEDERATED_STORAGE_ENGINE=1 \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DENABLED_LOCAL_INFILE=1 \
    -DENABLE_DTRACE=0 \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DWITH_EMBEDDED_SERVER=1

    make -j `grep processor /proc/cpuinfo | wc -l`  && make install

    rm -rf ${mysql_sou_tar[2]} ${mysql_sou[2]} ${mysql_boost_version_tar} ${mysql_boost_version}

    popd
}



# 设置权限 创建数据库 设置服务 bin添加mysql 开启Mysql 设置密码
mysql_install_boot(){
    
    cd $mysql_local

    chown -R $mysql_user:$mysql_group $mysql_local && chmod 755 $mysql_local/bin/* # 赋值用户组和用户 赋值权限

    cp -rf ${mysql_local}/support-files/mysql.server /etc/init.d/mysqld && chmod 755 /etc/init.d/mysqld

    sed -i "s:^basedir=.*:basedir=$mysql_local:g" /etc/init.d/mysqld # 更换目录位置
    sed -i "s:^datadir=.*:datadir=$mysql_data:g" /etc/init.d/mysqld # 更换存储位置

    [ ! -d $mysql_data  ] && mkdir -p $mysql_data  && chown -R $mysql_user:$mysql_group $mysql_data 

    [ ! -d $mysql_log  ] && mkdir -p $mysql_log  && chown -R $mysql_user:$mysql_group $mysql_log 

    [ -d /var/lib/mysql ] && rm -rf /var/lib/mysql # 删除之前的mysql

    cd -

    # 初始化mysql
    mkdir /usr/local/mysql/etc
    if [ $mysql_version_select == 1 ];then
        cp -rf ./conf/my56.cnf /usr/local/mysql/etc/my.cnf
        $mysql_local/scripts/mysql_install_db --basedir=$mysql_local --datadir=$mysql_data --user=$mysql_user
    elif [ $mysql_version_select == 2 ];then
        cp -rf ./conf/my57.cnf /usr/local/mysql/etc/my.cnf
        $mysql_local/bin/mysqld --initialize-insecure --user=$mysql_user --basedir=$mysql_local --datadir=$mysql_data
    fi

    # 删除默认的配置文件
    rm -rf /etc/mysql
   
    # 设置服务
    if [[ $os == "centos" ]];then
        chkconfig mysqld on && chkconfig save
    elif [[ $os == "ubuntu" ]];then
        update-rc.d mysqld defaults
    fi


    # 添加Mysql路径 
    if [[ `sed -n '/export PATH=*.*\/mysql\/bin/p' /etc/profile | wc -l` > 1 ]];then # 避免重复设置
        sed -i '/export PATH=*.*\/mysql\/bin/d' /etc/profile
        echo "export PATH=~/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin " >> /etc/profile
    else
        echo "export PATH=~/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin " >> /etc/profile
    fi
    source /etc/profile

    # 开启mysql
    /etc/init.d/mysqld start

    # 修改密码 
    mysql_grant(){

        $mysql_local/bin/mysqladmin -u$mysql_enter_user password "${mysql_root_pass}"
        
        if [ $mysql_version_select == 1 ];then
            cp -f ./conf/grant56.sql ./conf/grant56.bak
            sed -i 's@mysql_pwd@'"${mysql_root_pass}"'@g' ./conf/grant56.sql
            cat ./conf/grant56.sql | $mysql_local/bin/mysql -u$mysql_enter_user -p${mysql_root_pass}
            mv -f ./conf/grant56.bak ./conf/grant56.sql
        elif [ $mysql_version_select == 2 ];then
            cp -f ./conf/grant57.sql ./conf/grant57.bak
            sed -i 's@mysql_pwd@'"${mysql_root_pass}"'@g' ./conf/grant57.sql
            cat ./conf/grant57.sql | $mysql_local/bin/mysql -u$mysql_enter_user -p${mysql_root_pass}
            mv -f ./conf/grant57.bak ./conf/grant57.sql
        fi

        # 导入备份数据
        [ -f $mysql_data_backup ] && $mysql_local/bin/mysql -u$mysql_enter_user -p$mysql_root_pass < $mysql_data_backup
    }
    mysql_grant # 修改密码 

    # 添加服务
    if [ $os == "ubuntu" ];then
        echo "/usr/local/mysql" > /etc/ld.so.conf.d/mysql.conf
        ldconfig # 安装了一个新的动态链接库时，就需要手工运行这个命令
    fi

}




