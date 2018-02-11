#!/bin/bash          


# 安装 php 依赖
pre_install_php(){

    # 校验用户组是否存在
    if [[ `grep www:x /etc/group | wc -l` == 0 ]];then
        groupadd $php_group
    fi

    # 校验用户是否存在
    if [[ `grep www:x /etc/passwd | wc -l` == 0 ]];then
        useradd  -M -s /sbin/nologin -g $php_group $php_user 
    fi

    # install_curl       
    install_curl(){      
        pushd ${src_dir}
        tar xjf {$curl_version_tar} && cd {$curl_version} 
        ./configure --prefix=/usr/local/curl
        make && make install      
        popd
        rm -rf $src_dir/$curl_version
    }
    install_curl  # 安装curl  

    # 安装依赖
    if [ $os == "centos" ];then
        yum install -y gcc gcc-c++ libxml2 libxml2-devel libjpeg-devel libpng-devel freetype-devel openssl-devel libcurl-devel libmcrypt libmcrypt-devel libicu-devel libxslt-devel   
    elif [ $os == "ubuntu" ];then
        apt-get update  -y 
        apt-get install  libxml2  libxml2-dev -y
        apt-get install  openssl libssl-dev -y
        apt-get install  curl libcurl4-gnutls-dev -y
        apt-get install libjpeg-dev libpng12-dev   libxpm-dev libfreetype6-dev  libmcrypt-dev  libmysql++-dev  libxslt1-dev  libicu-dev  -y
        ln -sf /usr/lib/${sys_bit}-linux-gnu/libssl.so  /usr/lib # 设置软链
    fi
}
pre_install_php

   

# 安装 libmcrypt
install_libmcrypt(){
    pushd $src_dir
    tar xzf ${libmcrypt_tar} && cd $libmcrypt
    ./configure
    make && make install
    popd
    rm -rf $src_dir/$libmcrypt
}
install_libmcrypt


# 安装 PHP
install_php(){
 
     # 使用ldconfig命令将/usr/local/mysql加入到默认库
    if [[ -d /etc/ld.so.conf.d/usr_local_lib.conf ]];then
        if [[ `sed -n '/\/usr\/local\/lib/p' /etc/ld.so.conf.d/usr_local_lib.conf | wc -l` == 0 ]];then
          echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr_local_lib.conf # 将 /usr/local/lib 输出到 /etc/ld.so.conf.d/usr_local_lib.conf
          ldconfig # 用户安装了一个新的动态链接库时,就需要手工运行这个命令.
        fi
    else
        echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr_local_lib.conf # 将 /usr/local/lib 输出到 /etc/ld.so.conf.d/usr_local_lib.conf
        ldconfig # 用户安装了一个新的动态链接库时,就需要手工运行这个命令.
    fi

    pushd $src_dir # 跳转到指定目录，输出堆栈

    php_install_dir_use="${php_install_dir}/${php_version[${php_version_select}]}" # php 安装目录

    tar xjvf ${php_bz[${php_version_select}]} && cd ${php_version[${php_version_select}]} # 解压

    # 安装 php
    config_php(){
        ./configure --prefix=${php_install_dir_use} --with-config-file-path=${php_install_dir_use}/etc \
        --with-config-file-scan-dir=${php_install_dir_use}/etc/php.d \
        --with-fpm-user=www --with-fpm-group=www --enable-fpm --enable-opcache --disable-fileinfo \
        --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
        --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib \
        --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-exif \
        --enable-sysvsem --enable-inline-optimization --with-curl=/usr/local/curl --enable-mbregex \
        --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl \
        --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-ftp --enable-intl --with-xsl \
        --with-gettext --enable-zip --enable-soap --disable-debug
        make ZEND_EXTRA_LIBS='-liconv'
        make
        ln -fs /usr/local/lib/libiconv.so.2 /usr/lib64/ 
        ln -fs /usr/local/lib/libiconv.so.2 /usr/lib/ 
        make install

        if [[ -e ${php_install_dir_use}/bin/phpize ]];then
            echo -e "php install successful!"
        else
            echo -e "${RED}php install failed, Please contact author.${WHITE}"
            exit || kill -9 $$
        fi

        # 复制 php.ini
        cp -f php.ini-production ${php_install_dir_use}/etc/php.ini 

        # 复制 服务脚本,赋值权限
        cp -f sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && chmod 755 /etc/init.d/php-fpm
    }
    config_php 

    
    add_php_boot(){
        # 设置 php 开机自启服务
        if [[ $os == "centos" ]];then
            chkconfig  php-fpm on  && chkconfig save
        elif  [[ $os == "ubuntu" ]];then
            update-rc.d php-fpm defaults
        fi

        # 设置软连
        ln -fs ${php_install_dir_use}/bin/php /usr/bin/php
    }
    add_php_boot # 添加php服务

    popd

    # 复制php-fpm
    copy_php_fpm(){

        cp -f ./conf/php-fpm.conf ${php_install_dir_use}/etc #  复制 php-fpm.conf 配置文件
        # 修改配置文件
        sed -i "s@listen = 127.0.0.1:9000@listen = 127.0.0.1:${php_fpm_port}@g" ${php_install_dir_use}/etc/php-fpm.conf  # 修改端口

        # 日志
        mkdir -p /data/logs/php
        chown -R $php_user:$php_group /data/logs/php

        # 重启服务
        service php-fpm restart
        
        # 删除文件
        rm -rf $src_dir/${php_version[$php_version_select]}
    }
    copy_php_fpm

}
install_php  
