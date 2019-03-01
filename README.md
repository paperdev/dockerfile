# dockerfile


docker hub url : https://hub.docker.com/r/paperdev/centos


run jenkins with docker
1. $cd jenkins
2. $docker build -t paperdev/centos:jenkins . (DOT NOT FORGET DOT)
3. $docker run -itd -p 8080:8080 --name jenkins paperdev/centos:jenkins


run mysql with docker
1. $cd mysql
2. $docker build -t paperdev/centos:mysql . (DOT NOT FORGET DOT)
3. $docker run -itd -p 3306:3306 --name mysql paperdev/centos:mysql
