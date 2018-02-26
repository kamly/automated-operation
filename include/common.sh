#!/bin/bash                                                                                                                                               

export PATH=~/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# 获取系统版本，如果是64则赋值x86_64，否则i386
sysbit=`uname -a | grep 64 | wc -l`
[ $sysbit -eq "1" ] && sys_bit="x86_64" || sys_bit="i386" # -eq等于1,赋值x86_64,短路。如果不是，赋值i386

# # 判断设置db版本，如果是32位则复制i686，否则x86_64
[ $sys_bit == "i386" ] && db_bit="i686" || db_bit="x86_64"


# 设置颜色
BLUE='\033[0;34m'
RED='\033[0;31m'         
GREEN='\033[0;32m'       
YELLOW='\033[0;33m'
WHITE='\033[0;0m'        
WARN='\033[41,37m'

# 检查权限
[ $(id -u) != 0 ] && { echo -e "$RED You need root privileges to run it!" ; exit 1;}


#------------------------------
# /data/  文件存储
# /usr/local  安装路径
# /etc/  配置文件  redis
# /data/log/  日志
# /usr/local/bin/ 执行
# 检测安装 使用 -d /usr/local/xx  xx
# 判断符号用 ==
# ${src_dir}
# 日志，创建目录，权限，删除，设置  mysql配置  php配置  /etc/ /conf/  add_vhost  先下载后使用/直接download
#------------------------------

# 设置软件包文件夹       
src_dir=`pwd`/src        

# 默认 nginx 
# http://nginx.org/download/ 下载地址
ngx_user="www"
ngx_group="www"

ngx_install_dir="/usr/local/nginx"
ngx_root_dir="/data/www/"
ngx_default="default"
ngx_logs="/data/logs/nginx"
ngx_port=80

jemalloc='jemalloc-3.6.0'
jemalloc_tar='jemalloc-3.6.0.tar.bz2'

zlib="zlib-1.2.11"
zlib_tar="zlib-1.2.11.tar.xz"

openssl='openssl-1.0.1t'
openssl_tar='openssl-1.0.1t.tar.gz'

pcre='pcre-8.39'
pcre_tar='pcre-8.39.tar.bz2'

ngx="nginx-1.12.0"
ngx_tar="nginx-1.12.0.tar.gz"


# 默认 PHP
# http://mirrors.sohu.com/php/php-5.6.30.tar.bz2 下载地址
php_user="www"
php_group="www"

php_install_dir="/usr/local/php"
php_fpm_port=9000  # 默认端口

php_version[1]="php-5.6.30"
php_version[2]="php-7.1.6"

php_bz[1]="${php_version[1]}.tar.bz2"
php_bz[2]="${php_version[2]}.tar.bz2"

curl_version="curl-7.56.0"
curl_version_tar="curl-7.56.0.tar.bz2"

libmcrypt="libmcrypt-2.5.7"
libmcrypt_tar="libmcrypt-2.5.7.tar.gz"



# 默认 redis
redis_install_dir="/usr/local/redis" # 安装路径

redis_gz="redis-4.0.0.tar.gz"  # 压缩包
redis_version="redis-4.0.0" # 版本

redis_port=6379 # 默认端口
redis_data=/data/redis

# 默认 mysql

mysql_enter_user="root"

mysql_user="mysql"
mysql_group="mysql"

mysql_install_dir="/usr/local/mysql" # 安装路径
mysql_data="/data/mysql" # mysql存储位置
mysql_log="/data/logs/mysql"
mysql_port=3306


# mysql版本
mysql_version[1]="mysql-5.6.38"
mysql_version[2]="mysql-5.7.20"

# 下载地址
mysql_down_url[1]="http://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-5.6"
mysql_down_url[2]="http://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-5.7"

# 二进制
mysql_bin[1]="${mysql_version[1]}-linux-glibc2.12-${db_bit}"
mysql_bin_tar[1]="${mysql_version[1]}-linux-glibc2.12-${db_bit}.tar.gz"


mysql_bin[2]="${mysql_version[2]}-linux-glibc2.12-${db_bit}"
mysql_bin_tar[2]="${mysql_version[2]}-linux-glibc2.12-${db_bit}.tar.gz"


# 源文件
mysql_sou[1]="${mysql_version[1]}"
mysql_sou_tar[1]="${mysql_version[1]}.tar.gz"


mysql_sou[2]="${mysql_version[2]}"
mysql_sou_tar[2]="${mysql_version[2]}.tar.gz"


# mysql-boost
boost_version="boost_1_59_0"
boost_version_tar="${boost_version}.tar.gz"



# 数据备份 update的时候使用
data_backup_dir="/data/backup" # 备份目录

mysql_data_backup="${data_backup_dir}/mysql_`date +%Y%m%d`.sql" # 旧的mysql的数据 

redis_data_backup="${data_backup_dir}/redis_`date +%Y%m%d`.rdb" # 旧的redis的数据 



# elasticsearch
# https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.1.tar.gz  下载地址

elasticsearch_user="elasticsearch"
elasticsearch_group="elasticsearch"

elasticsearch_install_dir="/usr/local/elasticsearch"
elasticsearch_port=9200  # 默认端口


elasticsearch_gz="elasticsearch-6.2.1.tar.gz"  # 压缩包
elasticsearch_version="elasticsearch-6.2.1" # 版本

elasticsearch_data="/data/elasticsearch"
elasticsearch_log="/data/logs/elasticsearch"




