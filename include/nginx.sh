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

    # 使用ldconfig命令将/usr/local/lib加入到默认库
    if [[ `sed -n '/\/usr\/local\/lib/p' /etc/ld.so.conf.d/usr_local_lib.conf | wc -l` == 0 ]];then
      echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr_local_lib.conf # 将 /usr/local/lib 输出到 /etc/ld.so.conf.d/usr_local_lib.conf
      ldconfig # 用户安装了一个新的动态链接库时,就需要手工运行这个命令.
    fi
}
install_jemalloc

# 安装openssl
install_openssl(){
    pushd $src_dir
    tar zmxf $openssl_tar && cd $openssl # tar.gz
    ./configure
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

# 安装 ngx
ngx_install(){
  
    # 校验用户组是否存在
    if [[ `grep www:x /etc/group | wc -l` == 0  ]]
      groupadd $ngx_group
    fi

    # 校验用户是否存在
    if [[ `grep www /etc/passwd | wc -l` == 0 ]];then
      useradd  -M -s /sbin/nologin -g $ngx_group $ngx_user # 创建用户  -M 表示不创建用户主目录  -s 表示指定用户所用的shell , 此处为/sbin/nologin，表示不登录  -g 表示指定用户的组名为$ngx_group, 用户名$ngx_user
    fi
    
    pushd $src_dir
    tar zmxf $ngx_tar &&  cd $ngx # tar.gz
    . ./configure --prefix=$ngx_dir \
    --user=$ngx_user \
    --group=$ngx_group \
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
ngx_install     


# 设置 ngx 配置                                                                                                                                           
ngx_settings(){
  
    mkdir -p ${ngx_root_dir}/${ngx_default}  $ngx_dir/vhost ${ngx_logs} # 创建网站根目录 虚拟目录 日志目录
    chown -R ${ngx_user}:${ngx_group} $ngx_root_dir $ngx_dir $ngx_logs # 将档案的拥有者加以改变

    ln -s $ngx_dir/sbin/nginx /usr/bin/nginx   # 设置软连接

    cp ./conf/nginx.conf $ngx_dir/conf   # 复制配置文件

    rm -rf $src_dir/$ngx $src_dir/$zlib $src_dir/$jemalloc  $src_dir/$openssl   $src_dir/$pcre  # 删除刚解压的文件
    
    # 复制 服务脚本,赋值权限，设置 nginx 开机自启服务
    echo -e "$WHITE"
    [ "$os" == "centos" ] && { cp -f ./init.d/nginx-init-centos /etc/init.d/nginx ; chkconfig  --level 2345 nginx on && chkconfig save ; }
    [ "$os" == "ubuntu" ] && { cp -f ./init.d/nginx-init-ubuntu /etc/init.d/nginx && chmod 755 /etc/init.d/nginx; update-rc.d nginx defaults; }

    echo "############################################Nginx works!!!################################" > ${ngx_root_dir}/${ngx_default}/index.html # 将内容输入到index.html页面，我们可以访问测试

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
    `${ngx_dir}/sbin/nginx -t -c ${ngx_dir}/conf/nginx.conf`
    if [ $? -eq 0 ]; then
      echo "${ngx_dir}/conf/nginx.conf success"
    else
      echo "${ngx_dir}/conf/nginx.conf faile"
    fi
    
    # 启动
    `${ngx_dir}/sbin/nginx -c ${ngx_dir}/conf/nginx.conf`
    if [ $? -eq 0 ]; then
      echo "${ngx_dir}/sbin/nginx -c ${ngx_dir}/conf/nginx.conf success"
    else
      echo "${ngx_dir}/sbin/nginx -c ${ngx_dir}/conf/nginx.conf faile"
    fi


    nginx -s reload 
    if [ $? -eq 0 ]; then
      echo "nginx -s reload  success"
    else
      echo "nginx -s reload  faile"
    fi  

    service nginx restart
    if [ $? -eq 0 ]; then
      echo "service nginx restart  success"
    else
      echo "service nginx restart  faile"
    fi  

}
ngx_settings

