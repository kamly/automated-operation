#!/bin/bash                                                                                                                                               

#  显示菜单，先问完安不安装再执行安装
menu(){ 

########## 是否安装 时间同步

    echo  -e "$YELLOW"
    while :;do echo
        read -p "Do you want sync Beijing time?(y/n)" sync_time_yn
        if [[ ! $sync_time_yn =~ ^[y,Y,n,N]$ ]];then
            echo -e "\033[0m Please input y/Y or n/N \033[33m"
        else
            break
        fi
    done

    # 时间同步
    sync_time(){
        case $sync_time_yn in
        y|Y)
            . ./include/sync_time.sh
            ;;
        *)
            echo -e "\033[0m you select not install for sync time! \033[33m"
            ;;
        esac
    }
    sync_time

########### 是否安装 nginx

    while :;do echo      
        read -p "Do you want Install Nginx?(y/n)" install_nginx_yn
        if [[ ! $install_nginx_yn =~ ^[y,Y,n,N]$ ]];then
            echo -e "\033[0m Please input y/Y or n/N \033[33m"
        else
            break        
        fi
    done

    # nginx
    if [[ "$install_nginx_yn" == "y" || "$install_nginx_yn" == "Y" ]];then
      if [[ -d "/usr/local/nginx" ]];then
        echo -e "$RED You had installed nginx!"
        echo -e "$YELLOW"
      else
        # 选择在线安装还是已经上传
        while :;do echo      
            read -p "Do you want Install Nginx Online?(y/n)" install_nginx_online
            if [[ ! $install_nginx_online =~ ^[y,Y,n,N]$ ]];then
                echo -e "\033[0m Please input y/Y or n/N \033[33m"
            else
                break        
            fi
        done
        if [[ ${install_nginx_online}  == "y" ]];then
          pushd $src_dir
          down_url ${jemalloc_download_url} # jemalloc
          down_url ${zlib_download_url} # zlib
          down_url ${openssl_download_url} # openssl
          down_url ${pcre_download_url} # pcre
          down_url ${nginx_download_url} # nginx   http://nginx.org/download/
          popd
        fi
         . ./include/nginx.sh  
      fi
    else
       echo "Not install or input wrong value for Nginx!"
    fi


########### 是否安装 php

    while :;do echo -e "$YELLOW"
      read -p "Do you want Install PHP?(y/n)" install_php_yn
      if [[ ! $install_php_yn =~ ^[y,Y,n,N]$ ]];then
        echo -e "\033[0m Please input y/Y or n/N \033[33m"
      else
        break
      fi  
    done

    # 安装php
    if [[  $install_php_yn == "y" || $install_php_yn == "Y" ]];then

        while :;do 
          echo -e "$YELLOW"
          echo -e "Please choose PHP version:
          $RED 1)$WHITE php-5.6.30 $GREEN( Default );
          $RED 2)$WHITE php-7.1.6;"
          read -p "Your select:" php_version_select
        if [[ ! $php_version_select =~ ^[1,2]$ ]];then
          echo -e "\033[0m Please input 1/2 \033[33m"
        else
          break
        fi  
        done

        if [[ -d $php_install_dir/${php_version[${php_version_select}]} ]];then
          echo -e "$RED You had installed PHP!"
          echo -e "$YELLOW"
        else
          echo "You select install ${php_bz[${php_version_select}]}"

          # 选择在线安装还是已经上传
          while :;do echo      
              read -p "Do you want Install PHP Online?(y/n)" install_php_online
              if [[ ! $install_php_online =~ ^[y,Y,n,N]$ ]];then
                  echo -e "\033[0m Please input y/Y or n/N \033[33m"
              else
                  break        
              fi
          done
          if [[ ${install_php_online}  == "y" ]];then
            pushd $src_dir
              down_url ${curl_download_url} 
              down_url ${libmcrypt_download_url} 
              down_url ${php_download_url[${php_version_select}]} 
            popd
          fi
          . ./include/php.sh
        fi
    else
        echo "Not install or input wrong value for Php!"
    fi


########### 是否安装 redis

   while :;do echo
      read -p "Do you want Install Redis?(y/n)" install_redis_yn
      if [[ ! $install_redis_yn =~ ^[y,Y,n,N]$ ]];then
        echo -e "\033[0mPlease input y or n\033[33m"
      else
        break
      fi                                                                                                                                                     
    done

    # 安装 redis
    if [ "$install_redis_yn" == "y" -o "$install_redis_yn" == "Y" ];then
       if [ -d "/usr/local/redis"  ];then
        echo -e "${RED}You had installed Redis Server!$YELLOW"  
      else
        #  密码
        echo
        read -p "redis server root password (default:root): " redis_root_pass
        redis_root_pass=${redis_root_pass:=root} # 提供默认
        echo  -e "redis root password: ${redis_root_pass}"
        echo  -e "$WHITE"
        echo "You select install Redis."

        # 选择在线安装还是已经上传
          while :;do echo      
              read -p "Do you want Install Redis Online?(y/n)" install_redis_online
              if [[ ! $install_redis_online =~ ^[y,Y,n,N]$ ]];then
                  echo -e "\033[0m Please input y/Y or n/N \033[33m"
              else
                  break        
              fi
          done
          if [[ ${install_redis_online}  == "y" ]];then
            pushd $src_dir
              down_url ${redis_download_url}
            popd
          fi

        . ./include/redis.sh
      fi
    else
        echo "Not install or input wrong value for Redis!"
    fi

########### 是否安装 mysql

    while :;do echo
      read -p "Do you want Install Mysql?(y/n)" install_mysql_yn
      if [[ ! $install_mysql_yn =~ ^[y,Y,n,N]$ ]];then
        echo -e "\033[0mPlease input y or n\033[33m"
      else
        break
      fi  
    done

    # 是否选择安装，选择版本，安装方式
    if [[ "$install_mysql_yn" == "y" || "$install_mysql_yn" == "Y" ]];then

      if [ -d "/usr/local/mysql"  ];then
        echo -e "${RED}You had installed Mysql Server!$YELLOW"  
      else
        # 安装版本
        echo -e "Please choose MYSQL version:
        $RED 1)$WHITE ${mysql_version[1]} $GREEN( Default );
        $RED 2)$WHITE ${mysql_version[2]} $GREEN( RAM size must large than 2 GB! );"
        echo -e "$WHITE"
        read -p "Please input the number of your choose: " mysql_version_select

        mysql_version_select=${mysql_version_select:=1} # 提供默认        
        if [[ "$mysql_version_select" == 1 || "$mysql_version_select" == 2 ]];then
          # 安装方式
          echo
          echo  -e "${YELLOW}How to install Mysql Server? :
              $RED 1)$WHITE Use Binary File;(Default) 
              $RED 2)$WHITE Use Build Source Code;(Need more time);"  # 1 二进制 2 构建源码
          echo
          read -p "You select the number to install mysql:  " mysql_install_wayway
          mysql_install_wayway=${mysql_install_wayway:=1} # 提供默认        
        
          #  密码
          echo
          read -p "mysql server root password (default:root): " mysql_root_pass
          mysql_root_pass=${mysql_root_pass:=root} # 提供默认
          echo  -e "Mysql root password: ${mysql_root_pass}"
          echo  -e "$WHITE"

          # 安装 mysql
          if [ "$mysql_version_select" == 1 ];then
              echo "You select install ${mysql_version[1]}"
              . ./include/mysql-5.6.sh
          elif  [ "$mysql_version_select" == 2 ];then
              echo "You select install ${mysql_version[2]}"
              . ./include/mysql-5.7.sh
          fi 
        fi
      fi
    else
      echo "Not install or input wrong value for Mysql!"
    fi

    
     
  
########### 是否安装 elasticsearch

  while :;do echo
      read -p "Do you want Install Elasticsearch?(y/n)" install_elasticsearch_yn
      if [[ ! $install_elasticsearch_yn =~ ^[y,Y,n,N]$ ]];then
        echo -e "\033[0mPlease input y/Y or n/N\033[33m"
      else
        break
      fi  
  done


  if [[ "$install_elasticsearch_yn" == "y" || "$install_elasticsearch_yn" == "Y" ]];then
    if [[ -d "/usr/local/elasticsearch" ]];then
      echo -e "$RED You had installed elasticsearch!"
      echo -e "$YELLOW"
    else
        # 选择在线安装还是已经上传
        while :;do echo      
            read -p "Do you want Install Elasticsearch Online?(y/n)" install_elasticsearch_online
            if [[ ! $install_elasticsearch_online =~ ^[y,Y,n,N]$ ]];then
                echo -e "\033[0m Please input y/Y or n/N \033[33m"
            else
                break        
            fi
        done
        if [[ ${install_elasticsearch_online}  == "y" ]];then
          pushd $src_dir
            down_url ${elasticsearch_download_url}
          popd
        fi
        . ./include/elasticsearch.sh  
    fi
  else
      echo "Not install or input wrong value for Elasticsearch!"
  fi

  
########### 是否安装 kibana

  while :;do echo
      read -p "Do you want Install Kibana?(y/n)" install_kibana_yn
      if [[ ! $install_kibana_yn =~ ^[y,Y,n,N]$ ]];then
        echo -e "\033[0mPlease input y/Y or n/N\033[33m"
      else
        break
      fi  
  done


  if [[ "$install_kibana_yn" == "y" || "$install_kibana_yn" == "Y" ]];then
    if [[ -d "/usr/local/kibana" ]];then
      echo -e "$RED You had installed kibana!"
      echo -e "$YELLOW"
    else
        # 选择在线安装还是已经上传
        while :;do echo      
            read -p "Do you want Install Kibana Online?(y/n)" install_kibana_online
            if [[ ! $install_kibana_online =~ ^[y,Y,n,N]$ ]];then
                echo -e "\033[0m Please input y/Y or n/N \033[33m"
            else
                break        
            fi
        done
        if [[ ${install_kibana_online}  == "y" ]];then
          pushd $src_dir
            down_url ${kibana_download_url}
          popd
        fi
        . ./include/kibana.sh  
    fi
  else
      echo "Not install or input wrong value for Kibana!"
  fi

    
########### 是否安装 filebeat

  while :;do echo
      read -p "Do you want Install Filebeat?(y/n)" install_filebeat_yn
      if [[ ! $install_filebeat_yn =~ ^[y,Y,n,N]$ ]];then
        echo -e "\033[0mPlease input y/Y or n/N\033[33m"
      else
        break
      fi  
  done


  if [[ "$install_filebeat_yn" == "y" || "$install_filebeat_yn" == "Y" ]];then
    if [[ -d "/usr/local/filebeat" ]];then
      echo -e "$RED You had installed filebeat!"
      echo -e "$YELLOW"
    else
        # 选择在线安装还是已经上传
        while :;do echo      
            read -p "Do you want Install Filebeat Online?(y/n)" install_filebeat_online
            if [[ ! $install_filebeat_online =~ ^[y,Y,n,N]$ ]];then
                echo -e "\033[0m Please input y/Y or n/N \033[33m"
            else
                break        
            fi
        done
        if [[ ${install_filebeat_online}  == "y" ]];then
          pushd $src_dir
            down_url ${filebeat_download_url}
          popd
        fi
        . ./include/filebeat.sh  
    fi
  else
      echo "Not install or input wrong value for Filebeat!"
  fi

########### 是否安装 logstash

  while :;do echo
      read -p "Do you want Install Logstash?(y/n)" install_logstash_yn
      if [[ ! $install_logstash_yn =~ ^[y,Y,n,N]$ ]];then
        echo -e "\033[0mPlease input y/Y or n/N\033[33m"
      else
        break
      fi  
  done


  if [[ "$install_logstash_yn" == "y" || "$install_logstash_yn" == "Y" ]];then
    if [[ -d "/usr/local/logstash" ]];then
      echo -e "$RED You had installed logstash!"
      echo -e "$YELLOW"
    else
        # 选择在线安装还是已经上传
        while :;do echo      
            read -p "Do you want Install Logstash Online?(y/n)" install_logstash_online
            if [[ ! $install_logstash_online =~ ^[y,Y,n,N]$ ]];then
                echo -e "\033[0m Please input y/Y or n/N \033[33m"
            else
                break        
            fi
        done
        if [[ ${install_logstash_online}  == "y" ]];then
          pushd $src_dir
            down_url ${logstash_download_url}
          popd
        fi
        . ./include/logstash.sh  
    fi
  else
      echo "Not install or input wrong value for Logstash!"
  fi

}
menu