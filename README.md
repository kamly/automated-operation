# 自动化脚本配置lnmp环境

由于大学期间，折腾服务器的配置环境遇到不少巨坑，所以一直想弄一个自动化脚本。

功能：
1. 安装 `./install.sh`   sync,nginx,php,redis,mysql 
2. 卸载 `./uninstall.sh`  nginx,php,redis,mysql

# 环境配置

目前适用
ubnutu 16.04 

# 软件说明

1. 相关软件版本
 - nginx (1.12)
 - php (5.6.30 7.1.6)
 - redis (4.0.0)
 - mysql (5.6 5.7)
2. 软件安装包存放在云盘，需要先下载到 `./src/` 的目录中


# 安装说明


1.  `/usr/local/xxx` 安装目录
2.  `/data/xxx` 数据目录
3.  `/usr/local/xxx/etc` `/usr/local/xxx/conf/` 配置目录
4.  `/data/logs/xxx` 日志

> `xxx` 指的是安装软件的名字，具体有（nginx,redis,php,mysql）

# 具体操作

## 拉取脚本

```shell
apt-get update # 更新源
apt-get installl -y git # 安装git
# 拉取代码，建议脚本放在`/data/lnmp`
mkdir -p /data
cd /data
git clone https://github.com/kamly/automated-operation.git
```

## 上传资源

软件安装包存放在[云盘](https://pan.baidu.com/s/1jJYgAN0)。

先下载到本地，然后上传到服务器的 `./src/` 目录中

## ./install.sh

执行安装命令 `./install.sh`

1. 是否安装 sync_time 时间同步

选择，执行之后
![](http://ww1.sinaimg.cn/large/8c2e9604gy1fob9txkgqrj21w41iykde.jpg )

2. 是否安装 nginx 

选择
![](http://ww1.sinaimg.cn/large/8c2e9604gy1fob9tx37xmj21w0118gzl.jpg)

执行之后
![](http://ww1.sinaimg.cn/large/8c2e9604gy1fob9tvnci1j21rc0e6wjr.jpg)

3. 是否安装 php

选择
![](http://ww1.sinaimg.cn/large/8c2e9604gy1fob9txsmuwj21qw0omwo8.jpg)

执行之后
![](http://ww1.sinaimg.cn/large/8c2e9604gy1fob9tvopaaj21rg0hon4j.jpg)

4. 是否安装 redis

选择
![](http://ww1.sinaimg.cn/large/8c2e9604gy1fob9tw2xatj21ri0iy0zm.jpg)

执行之后
![](http://ww1.sinaimg.cn/large/8c2e9604gy1fob9tvnkj8j21ro0h6n0o.jpg)

5. 是否安装 mysql

选择
![](http://ww1.sinaimg.cn/large/8c2e9604gy1fob9twvj6pj21rk0tsajf.jpg)

执行之后
![](http://ww1.sinaimg.cn/large/8c2e9604gy1fob9txsejij21re14e4cg.jpg)

6. 是否安装 elasticsearxh

7. 是否安装 kibana

8. 是否安装 filebeat

9. 是否安装 logstash


## ./uninstall.sh

执行卸载命令 `./uninstall.sh`

选择
![](http://ww1.sinaimg.cn/large/8c2e9604gy1foba8kkyl9j21rg0ycahh.jpg)


## ./reset_mysql_pwd.sh

执行重置 mysql 密码命令 `./reset_mysql_pwd.sh`

## ./reset_redis_pwd.sh

执行重置 redis 密码命令 `./reset_redis_pwd.sh`

## ./mysql_back_import.sh

备份命令 `./mysql_backup_import.sh backup` 

导入命令(指定日期) `./mysql_backup_import.sh import 20180211`

## ./redis_back_import.sh

备份命令 `./redis_backup_import.sh backup`  

导入命令(指定日期) `./redis_backup_import.sh import 20180211`


## ./vhost 

添加域名 `./vhost.sh add` 
删除域名 `./vhost.sh del`

## ./is_crontab_on.sh

检查是否有 "xxx"  任务 `./is_crontab_on.sh "30 8 * * * /data/sh/start_daily_check.sh"`

## ./turn_on_crontab.sh 

启动 "xxx" 任务 `./turn_on_crontab.sh "30 8 * * * /data/sh/start_daily_check.sh"` 

## ./turn_off_crontab.sh 

关闭 "xxx" 任务 `./turn_on_crontab.sh "30 8 * * * /data/sh/start_daily_check.sh"` 


## ./vim.sh

安装 vim 插件 Syntastic（语法检测），SimpylFold（折叠）， NERDTree（文件树）， VimAirLine（状态栏），Taglist（函数栏），Theme（主题） `./vim.sh -all`


