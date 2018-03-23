# 自动化脚本配置lnmp环境

由于大学期间，折腾服务器的配置环境遇到不少巨坑，所以一直想弄一个自动化脚本。


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


# 软件安装目录说明


1.  `/usr/local/xxx` 安装目录
2.  `/data/xxx` 数据目录
3.  `/usr/local/xxx/etc` `/usr/local/xxx/conf/` 配置目录
4.  `/data/logs/xxx` 日志

> `xxx` 指的是安装软件的名字，具体有（nginx,redis,php,mysql...）

# 具体操作

## 1. 拉取脚本

```shell
apt-get update # 更新源
apt-get install -y git # 安装git
# 拉取代码，建议脚本放在`/data/lnmp`
mkdir -p /data
cd /data
git clone https://github.com/kamly/automated-operation.git
# 进入目录，新建文件
cd automated-operation
mkdir install_uninstall/src logs 
```

## 2. 软件安装包

1. 方法：

    软件安装包存放在[云盘](https://pan.baidu.com/s/1jJYgAN0)。

    先下载到本地，然后上传到服务器的 `./install_uninstall/src/` 目录中

2. 方法：

    脚本提供在线下载安装包

## 3. 各脚本使用方法

参考[automated-operation wiki](https://github.com/kamly/automated-operation/wiki)

