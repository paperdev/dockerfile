# dockerfile


docker hub url : https://hub.docker.com/r/paperdev/centos


run jenkins with docker
1. $cd jenkins
2. $docker build -t centos_jenkins . (DOT NOT FORGET DOT)
3. $docker run -itd -p 8080:8080 --name jenkins centos_jenkins


run mysql with docker
1. $cd mysql
2. $docker build -t centos_mysql . (DOT NOT FORGET DOT)
3. $docker run -itd -p 3306:3306 --name mysql centos_mysql
