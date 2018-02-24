# ./is_crontab_on.sh "30 8 * * * /home/kamly/lnmp/start_daily_check.sh" 

echo "任务开始"

dir="$( cd "$( dirname $0  )" && pwd  )"
echo "[is_crontab_on.sh的路径]: {$dir}"


crontab_file="${dir}/crontab.cur" # 暂时存储 crontab 所有命令文件
echo "[暂时存储所有定时命令的文件存放在]: {$crontab_file}"


crontab_command_raw=${1} # 执行定时任务  
echo "[命令预览]: ${crontab_command_raw}" # 打印 执行任务的命令


crontab_command=$(echo "${crontab_command_raw}" | sed -e 's/*/\\*/g; s/\//\\\//g;')
echo "[命令转义]: ${crontab_command}"


crontab -l -u root > "${crontab_file}"
echo "[所有定时命令打印到]: {$crontab_file}"


if grep -q "${crontab_command}" "${crontab_file}"
then
    if grep -q "#\+${crontab_command}" "${crontab_file}"
    then
        echo "----命令已经取消"
    else
        echo "----命令正在执行"
    fi
else
    echo "命令没有发现在 ${crontab_file}"
fi

rm -rf $crontab_file # 删除 暂时存储

echo "任务结束"


