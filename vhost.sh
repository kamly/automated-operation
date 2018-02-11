#!/bin/bash

. include/common.sh

# 添加 vhost, 缺少检查
vhost_add(){
	echo -e "$YELLOW"
    read -p "Please input your domain name as your htdoc! (example: yunweijilu.com)  " domain_name

    mkdir -p ${ngx_root_dir}/${domain_name} # 创建目录

    chown -R $ngx_user:$ngx_group ${ngx_root_dir}/${domain_name} # 改变权限

    cp -f ./conf/nginx_vhost.conf  ${ngx_install_dir}/conf/vhost/${domain_name}.conf # 复制配置文件

    sed -i "s/domain/${domain_name}/g" ${ngx_install_dir}/conf/vhost/${domain_name}.conf # 替换domain词语

	nginx -s reload # 重启

    echo -e "$GREEN"
    [ -d ${ngx_root_dir}/${domain_name} ] && echo -e "Created ${ngx_root_dir}/${domain_name} success!"

    [ -f ${ngx_install_dir}/conf/vhost/${domain_name}.conf ] && echo -e "Created ${ngx_install_dir}/conf/vhost/${domain_name}.conf success!"
}

# 减少 vhost , 缺少检查
vhost_del(){
	echo -e "${YELLOW}"
	read -p "Please input your domain name which you want delete! (example: yunweijilu.com)  " domain_name

	if [  -z "$domain_name" ];then

		echo
		echo -e "${WHITE}You did not intput anything."

	elif [  -f ${ngx_install_dir}/conf/vhost/${domain_name}.conf ];then

		[ ! -d  ${data_backup_dir} ] && mkdir -p ${data_backup_dir}

		mv ${ngx_root_dir}/${domain_name} ${data_backup_dir}/${domain_name}_`date +%m%d%H%M` # 移动目录

		mv ${ngx_install_dir}/conf/vhost/${domain_name}.conf ${data_backup_dir}/${domain_name}.conf_`date +%m%d%H%M` # 移动配置文件
		
        nginx -s reload
		
        echo -e "$GREEN"
		[ ! -d ${ngx_root_dir}/${domain_name} ] && echo -e "Delete ${ngx_root_dir}/${domain_name} success!"
		[ ! -f ${ngx_install_dir}/conf/vhost/${domain_name}.conf ] && echo -e "Delete ${ngx_install_dir}/conf/vhost/${domain_name}.conf success!"

	else

		echo
		echo  -e "${RED}You input a incroccet domain name,Please check it..."

	fi
}



# ./vhost.sh add
# 主菜单
nginx -v
if [  $? == 0 ];then
	echo -e "${RED}Please check if you had installed Nginx!!"
else
	if	[[ "$1" == "add" && -z $2 ]];then
		echo
		vhost_add
	elif	[[ "$1" == "del"  && -z $2 ]];then
		echo
		echo -e "${WHITE}You select delete vhost for nginx, your website data backup in $data_backup_dir"
		vhost_del
	else
		echo
		echo -e "${WHITE}Usage: $0 {add|del}"
	fi
fi

