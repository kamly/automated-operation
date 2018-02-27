#!/bin/bash     

pushd $src_dir # 切换

# 解压
tar -zxvf $kibana_gz

# 移动目录 + 重命名
mv $kibana_version $kibana_install_dir 

# 修改配置文件
sed -i "s@#server.port: 5601@server.port: ${kibana_port}@g" $kibana_install_dir/config/kibana.yml  
sed -i "s@#server.host: "localhost"@#server.host: "0.0.0.0"@g" $kibana_install_dir/config/kibana.yml   


popd  # 切换

# 需要自己切换到 kibana 用户进行测试


