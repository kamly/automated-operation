grant all privileges on *.* to root@'%' identified by "mysql_pwd" with grant option;
grant all privileges on *.* to root@'localhost' identified by "mysql_pwd" with grant option;
grant all privileges on *.* to root@'127.0.0.1' identified by "mysql_pwd" with grant option;
drop database if exists test;
use mysql;
delete from user where not (user='root');
delete from db where user='';
delete from user where authentication_string='';
update mysql.user set authentication_string=password('mysql_pwd') where user='root' AND host='127.0.0.1' OR host='%' OR host='localhost';
flush privileges;
select user,authentication_string,host from user;
exit

