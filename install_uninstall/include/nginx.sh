#!/bin/bash                                                                                                                                               

# 安装必要依赖
echo -e "${WHITE}"         
echo -e "OS is ${RED}${os}"
echo -e "${WHITE}"
[ "$os" == "centos" ] && yum  install -y iptables-services mlocate net-tools bzip2 autoconf make cmake  gcc gcc-c++ zlib zlib-devel screen psmisc
[ "$os" == "ubuntu" ] && apt-get update -y  && apt-get install -y -f build-essential mlocate net-tools bzip2 autoconf make cmake  gcc screen psmisc

# 安装zlib
install_zlib(){
    pushd $src_dir # 切换
    tar xmf $zlib_tar && cd $zlib  # tar.xz
    ./configure
    make && make install 
    popd
}
install_zlib


# 安装jemalloc
install_jemalloc(){
    pushd $src_dir
    tar xmjf $jemalloc_tar && cd $jemalloc # tar.bz2
    ./configure --prefix=/usr/local/jemalloc --libdir=/usr/local/lib
    make && make install
    make clean
    popd

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
}
install_jemalloc

# 安装openssl
install_openssl(){
    pushd $src_dir
    tar zmxf $openssl_tar && cd $openssl # tar.gz
    ./config
    make && make install
    popd
}
install_openssl

# 安装 pcre
install_pcre(){
    pushd $src_dir
    tar xjf $pcre_tar &&  cd $pcre # tar.bz2
    ./configure
    make && make install
    popd
}
install_pcre

# 安装 nginx
nginx_install(){
  
    # 校验用户组是否存在
    if [[ `grep www:x /etc/group | wc -l` == 0 ]];then
      groupadd $nginx_group
    fi

    # 校验用户是否存在
    if [[ `grep www:x /etc/passwd | wc -l` == 0 ]];then
      useradd  -M -s /sbin/nologin -g $nginx_group $nginx_user # 创建用户  -M 表示不创建用户主目录  -s 表示指定用户所用的shell , 此处为/sbin/nologin，表示不登录  -g 表示指定用户的组名为$nginx_group, 用户名$nginx_user
    fi
    
    pushd $src_dir
    tar zmxf $nginx_tar &&  cd $nginx # tar.gz
    . ./configure --prefix=$nginx_install_dir \
    --user=$nginx_user \
    --group=$nginx_group \
    --with-http_stub_status_module \
    --with-http_v2_module \
    --with-http_ssl_module \
    --with-http_gzip_static_module \
    --with-http_realip_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-openssl=../$openssl \
    --with-pcre=../$pcre \
    --with-pcre-jit \
    --with-ld-opt='-ljemalloc'
    make && make install && echo -e "$YELLOW Nginx install successful!" || echo -e "$RED Install Nginx failed, Please check error number!!"
    popd
}
nginx_install     


# 设置 nginx 配置                                                                                                                                           
nginx_settings(){
  
    mkdir -p ${nginx_root_dir}/${nginx_default}  $nginx_install_dir/conf/vhost ${nginx_logs} # 创建网站根目录 虚拟目录 日志目录
    chown -R ${nginx_user}:${nginx_group} $nginx_root_dir $nginx_logs # 将档案的拥有者加以改变

    ln -s $nginx_install_dir/sbin/nginx /usr/bin/nginx   # 设置软连接

    cp ./conf/nginx.conf $nginx_install_dir/conf   # 复制配置文件
    # 修改配置文件
    sed -i "s@fastcgi_pass 127.0.0.1:9000;@fastcgi_pass 127.0.0.1:${php_fpm_port};@g" $nginx_install_dir/conf/nginx.conf  # 修改php-fpm端口
    sed -i "s@listen 80;@listen ${nginx_port};@g" $nginx_install_dir/conf/nginx.conf  # 修改server端口

    rm -rf $src_dir/$nginx $src_dir/$zlib $src_dir/$jemalloc  $src_dir/$openssl   $src_dir/$pcre  # 删除刚解压的文件
    
    # 复制 服务脚本,赋值权限，设置 nginx 开机自启服务
    echo -e "$WHITE"
    [ "$os" == "centos" ] && { cp -f ./init.d/nginx-init-centos /etc/init.d/nginx ; chkconfig  --level 2345 nginx on && chkconfig save ; }
    [ "$os" == "ubuntu" ] && { cp -f ./init.d/nginx-init-ubuntu /etc/init.d/nginx && chmod 755 /etc/init.d/nginx; update-rc.d nginx defaults; }

    echo "############################################Nginx works!!!################################" > ${nginx_root_dir}/${nginx_default}/index.html # 将内容输入到index.html页面，我们可以访问测试

    # 添加 tcp 80 端口到Ip列表
    centos_iptables(){
       if [ "$os" == "centos" ];then
        systemctl stop iptables.service
        iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
        systemctl stop firewalld.service 
        systemctl disable firewalld.service 
        systemctl start iptables.service
        service iptables save
        systemctl stop iptables.service
       fi
    }
    centos_iptables

    [ "$os" == "ubuntu" ] && service ufw stop # 防火墙停止

    # 测试配置文件
    `${nginx_install_dir}/sbin/nginx -t -c ${nginx_install_dir}/conf/nginx.conf`
    if [ $? -eq 0 ]; then
      echo "${nginx_install_dir}/conf/nginx.conf success"
    else
      echo "${nginx_install_dir}/conf/nginx.conf faile"
    fi
    
    # 启动
    service nginx start
    if [ $? -eq 0 ]; then
      echo "service nginx restart  success"
    else
      echo "service nginx restart  faile"
    fi  

}
nginx_settings

