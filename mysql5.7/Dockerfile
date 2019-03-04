FROM paperdev/centos:0.2
LABEL MAINTAINER="paperdev7@gmail.com"

ARG MYSQL_SERVER_PACKAGE=mysql-community-server
ARG MYSQL_SHELL_PACKAGE=mysql-shell
# remove comment to set root password to "password" otherwise a random password will be generated
# ENV MYSQL_ROOT_PASSWORD="password"
# comment it to allow localhost only otherwise allow root remote access set to "%"
# OR change "%" to other host
ENV MYSQL_ROOT_HOST="%"
ENV MYSQL_USER=mysql

RUN yum clean all
# for pwmake command
RUN rpm -ivh http://download-ib01.fedoraproject.org/pub/epel/6/x86_64/Packages/l/libpwquality-1.1.1-1.el6.x86_64.rpm
# for yum-config-manager command
RUN yum install -y yum-utils
RUN yum install -y https://repo.mysql.com/mysql-community-release-el6.rpm
RUN yum-config-manager --enable mysql57-community
RUN yum install -y $MYSQL_SERVER_PACKAGE $MYSQL_SHELL_PACKAGE 
RUN yum clean all 

VOLUME /var/lib/mysql
EXPOSE 3306 33060

COPY my.cnf /etc/my.cnf
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]