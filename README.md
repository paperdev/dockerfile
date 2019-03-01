# dockerfile


docker hub url : https://hub.docker.com/r/paperdev/centos


run jenkins with docker
1. $cd jenkins
2. $docker build -t paperdev/centos:jenkins . 
OR $docker docker pull paperdev/centos:jenkins
3. $docker run -itd -p 8080:8080 --name centosjk paperdev/centos:jenkins
