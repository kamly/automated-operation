# ./turn_off_crontab.sh "30 8 * * * /home/kamly/lnmp/start_daily_check.sh"

dir="$( cd "$( dirname $0  )" && pwd  )"
echo "[获取turn_on_crontab.sh的路径]: {$dir}"

crontab_file="${dir}/crontab.cur" # crontab.cur 暂时存储 crontab 所有命令文件
echo "[暂时存储所有定时命令的文件存放在]: {$crontab_file}"

crontab_command_raw=${1}
echo "[取消命令预览]: ${crontab_command_raw}" # 取消执行定时任务 

crontab_command=$(echo "${crontab_command_raw}" | sed -e 's/*/\\*/g; s/\//\\\//g;')
echo "[取消命令转义]: ${crontab_command}"

crontab -l -u root > "${crontab_file}" # 输出定时任务
echo "[所有定时命令打印到]: ${crontab_file}"

if grep -q "${crontab_command}" ${crontab_file}
then
    echo "发现要取消的命令在 ${crontab_file}"
    sed_str="sed -i /\"${crontab_command}\"/d ${crontab_file}"
    echo "${sed_str}" # 打印要执行的命令
    eval "${sed_str}" # 执行命令
else
    echo "要取消的命令不存在 ${crontab_file}" 
fi

echo "[执行到crontab,开始]"
crontab "${crontab_file}"
echo "[执行到crontab,结束]"

rm -rf ${crontab_file} # 删除 暂时存储

echo "[打印所有定时命令]"
crontab -l -u root
