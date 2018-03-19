#!/bin/bash                                                                                                                                               

export PATH=~/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# 获取系统版本，如果是64则赋值x86_64，否则i386
sysbit=`uname -a | grep 64 | wc -l`
[ $sysbit == '1' ] && sys_bit='x86_64' || sys_bit='i386' # -eq等于1,赋值x86_64,短路。如果不是，赋值i386

# # 判断设置db版本，如果是32位则复制i686，否则x86_64
[ $sys_bit == 'i386' ] && db_bit='i686' || db_bit='x86_64'


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
nginx_user='www'
nginx_group='www'

nginx_install_dir='/usr/local/nginx'
nginx_root_dir='/data/www/'
nginx_default='default'
nginx_logs='/data/logs/nginx'
nginx_port=80

# https://github.com/jemalloc/jemalloc/releases/download/3.6.0/jemalloc-3.6.0.tar.bz2  下载地址
jemalloc='jemalloc-3.6.0'
jemalloc_tar='jemalloc-3.6.0.tar.bz2'
jemalloc_download_url='https://github.com/jemalloc/jemalloc/releases/download/3.6.0/jemalloc-3.6.0.tar.bz2'

# http://www.zlib.net/fossils/zlib-1.2.11.tar.gz  下载地址
zlib='zlib-1.2.11'
zlib_tar='zlib-1.2.11.tar.xz' 
zlib_tar_url='http://www.zlib.net/fossils/zlib-1.2.11.tar.gz'

# https://www.openssl.org/source/openssl-1.0.2n.tar.gz  下载地址
openssl='openssl-1.0.2n'
openssl_tar='openssl-1.0.2n.tar.gz'
openssl_download_url='https://www.openssl.org/source/openssl-1.0.2n.tar.gz'

# https://ftp.pcre.org/pub/pcre/pcre-8.39.tar.bz2  下载地址
pcre='pcre-8.39'
pcre_tar='pcre-8.39.tar.bz2'
pcre_download_url='https://ftp.pcre.org/pub/pcre/pcre-8.39.tar.bz2'

# http://nginx.org/download/nginx-1.12.0.tar.gz下载地址
nginx='nginx-1.12.0'
nginx_tar='nginx-1.12.0.tar.gz'
nginx_download_url='http://nginx.org/download/nginx-1.12.0.tar.gz'


# 默认 PHP
php_user='www'
php_group='www'

php_install_dir='/usr/local/php'
php_fpm_port=9000  # 默认端口


php_version[1]='php-5.6.30'
php_version[2]='php-7.1.6'

php_bz[1]="${php_version[1]}.tar.bz2"
php_bz[2]="${php_version[2]}.tar.bz2"

# http://hk1.php.net/get/php-7.1.6.tar.bz2/from/this/mirror  下载地址
# http://mirrors.sohu.com/php/php-7.1.6.tar.bz2 下载地址 使用
php_download_url[1]="http://mirrors.sohu.com/php/${php_bz[1]}"
php_download_url[2]="http://mirrors.sohu.com/php/${php_bz[2]}"

# https://curl.haxx.se/download/curl-7.56.0.tar.bz2  下载地址
curl_version='curl-7.56.0'
curl_version_tar='curl-7.56.0.tar.bz2'
curl_download_url='https://curl.haxx.se/download/curl-7.56.0.tar.bz2'

# http://mcrypt.sourceforge.net/ 下载地址
# https://sourceforge.net/projects/mcrypt/files/Libmcrypt/   下载地址
# ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz 下载地址 使用
libmcrypt='libmcrypt-2.5.7'
libmcrypt_tar='libmcrypt-2.5.7.tar.gz'
libmcrypt_download_url='ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz'

# 默认 redis
redis_install_dir='/usr/local/redis' # 安装路径

# http://download.redis.io/releases/redis-4.0.8.tar.gz 下载地址 
redis_gz='redis-4.0.0.tar.gz'  # 压缩包
redis_version='redis-4.0.0' # 版本
redis_download_url='http://download.redis.io/releases/redis-4.0.8.tar.gz'

redis_port=6379 # 默认端口
redis_data='/data/redis'
redis_log='/data/logs/redis'

# 默认 mysql

mysql_enter_user='root'

mysql_user='mysql'
mysql_group='mysql'

mysql_install_dir='/usr/local/mysql' # 安装路径
mysql_data='/data/mysql' # mysql存储位置
mysql_log='/data/logs/mysql'
mysql_port=3306


# mysql版本
mysql_version[1]='mysql-5.6.38'
mysql_version[2]='mysql-5.7.20'

# 下载地址
mysql_download_url[1]='http://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-5.6'
mysql_download_url[2]='http://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-5.7'

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

mysql_backup="${data_backup_dir}/mysql" #  etc data

redis_backup="${data_backup_dir}/redis" #  etc data

nginx_backup="${data_backup_dir}/nginx/" #  ssl conf data 


# elasticsearch
elasticsearch_user='elasticsearch'
elasticsearch_group='elasticsearch'

elasticsearch_install_dir='/usr/local/elasticsearch'
elasticsearch_port=9200  # 默认端口

# https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.1.tar.gz  下载地址
elasticsearch_gz='elasticsearch-6.2.1.tar.gz'  # 压缩包
elasticsearch_version='elasticsearch-6.2.1' # 版本
elasticsearch_download_url='https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.1.tar.gz'

elasticsearch_data='/data/elasticsearch'
elasticsearch_log='/data/logs/elasticsearch'


# kibana
kibana_install_dir='/usr/local/kibana'
kibana_port=5601  # 默认端口

# https://artifacts.elastic.co/downloads/kibana/kibana-6.2.2-linux-x86_64.tar.gz  下载地址
kibana_gz='kibana-6.2.2-linux-x86_64.tar.gz'  # 压缩包
kibana_version='kibana-6.2.2-linux-x86_64' # 版本
kibana_download_url='https://artifacts.elastic.co/downloads/kibana/kibana-6.2.2-linux-x86_64.tar.gz'

kibana_log='/data/logs/kibana' # 日志

# filebeat
filebeat_install_dir='/usr/local/filebeat'

# https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.2-linux-x86_64.tar.gz  下载地址
filebeat_gz='filebeat-6.2.2-linux-x86_64.tar.gz'  # 压缩包
filebeat_version='filebeat-6.2.2-linux-x86_64' # 版本
filebeat_download_url='https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.2-linux-x86_64.tar.gz'

filebeat_log='/data/logs/filebeat' # 日志

# logstash
logstash_install_dir='/usr/local/logstash'

# https://artifacts.elastic.co/downloads/logstash/logstash-6.2.2.tar.gz  下载地址
logstash_gz='logstash-6.2.2.tar.gz'  # 压缩包
logstash_version='logstash-6.2.2' # 版本
logstash_download_url='https://artifacts.elastic.co/downloads/logstash/logstash-6.2.2.tar.gz'

logstash_log='/data/logs/logstash' # 日志

