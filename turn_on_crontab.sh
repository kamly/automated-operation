
# ./turn_on_crontab.sh "30 8 * * * /home/kamly/lnmp/start_daily_check.sh" >> /home/kamly/lnmp/turn_on_crontab.log 
# 这个脚本的内容输出到 turn_on_crontab.log 
# 日志可以查看之前写的爬虫

#  crontab -l -u root  需要加上 -u root

dir="$( cd "$( dirname $0  )" && pwd  )"
echo "[turn_on_crontab.sh的路径]: {$dir}"

crontab_file="${dir}/crontab.cur"  # 暂时存储 crontab 所有命令文件
echo "[暂时存储所有定时命令的文件存放在]: {$crontab_file}"

crontab_command_raw=${1} # 执行定时任务
echo "[命令预览]: ${crontab_command_raw}" # 打印 执行任务的命令

crontab_command=$(echo "${crontab_command_raw}" | sed -e 's/*/\\*/g; s/\//\\\//g;') # 对传进来的指令做特殊字符转义
echo "[命令转义]: ${crontab_command}" # 打印 转义后的命令

crontab -l -u root > "${crontab_file}" # 输出定时任务
echo "[所有定时命令打印到]: ${crontab_file}"

if grep -q "${crontab_command}" ${crontab_file}
then
    echo "发现要添加的命令在  ${crontab_file}"
    sed_str="sed -i /\"${crontab_command}\"/s/^#*// ${crontab_file}"
    echo "${sed_str}" # 打印要执行的命令
    eval "${sed_str}" # 执行命令
else
    echo "要添加的命令不存在 ${crontab_file}"
    echo "${crontab_command_raw}" >> ${crontab_file} # 添加
fi

echo "[执行到crontab,开始]"
crontab "${crontab_file}"
echo "[执行到crontab,结束]"

echo "[打印所有定时命令]"
crontab -l -u root
