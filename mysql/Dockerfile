FROM paperdev/centos:0.2
LABEL MAINTAINER="paperdev7@gmail.com"

ARG MYSQL_SERVER_PACKAGE=mysql-community-server
ARG MYSQL_SHELL_PACKAGE=mysql-shell

RUN yum clean all
# for pwmake command
RUN rpm -ivh http://download-ib01.fedoraproject.org/pub/epel/6/x86_64/Packages/l/libpwquality-1.1.1-1.el6.x86_64.rpm
# for yum-config-manager command
RUN yum install -y yum-utils
RUN yum install -y https://repo.mysql.com/mysql-community-release-el6.rpm
RUN yum-config-manager --enable mysql57-community
RUN yum install -y $MYSQL_SERVER_PACKAGE $MYSQL_SHELL_PACKAGE 
RUN yum clean all 
RUN mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

# can not run as root user
RUN echo "user=mysql" >> /etc/my.cnf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 3306 33060
CMD ["mysqld"]


# change mysql root password before using msyql
# password can find in log file 
# $ docker exec -it mysql mysql -u root -p

# change root password to 12345678
# mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY '12345678';

# allow root remote access by password 12345678
# mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '12345678' WITH GRANT OPTION;
# mysql> FLUSH PRIVILEGES;