grant all privileges on *.* to root@'%' identified by "mysql_pwd" with grant option;
grant all privileges on *.* to root@'localhost' identified by "mysql_pwd" with grant option;
grant all privileges on *.* to root@'127.0.0.1' identified by "mysql_pwd" with grant option;
drop database if exists test;
use mysql;
delete from user where not (user='root');
delete from db where user='';
UPDATE user SET password=PASSWORD('mysql_pwd') WHERE user='root' AND host='127.0.0.1' OR host='%' OR host='localhost';
delete from user where password='';
flush privileges;
select user,password,host from user;
exit
