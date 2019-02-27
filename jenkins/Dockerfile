FROM paperdev/centos:0.2
LABEL MAINTAINER="paperdev7@gmail.com"

RUN yum -y install curl java-1.8.0-openjdk
RUN yum clean all

# jdk env
RUN echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64' >> /etc/profile
RUN echo 'export JRE_HOME=/usr/lib/jvm/jre' >> /etc/profile
RUN source /etc/profile

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_DOWNLOAD_DIR=/usr/share/jenkins

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_DOWNLOAD_DIR /usr/share/jenkins
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}

RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user} \
    && chown -R ${user} "$JENKINS_HOME"

VOLUME /var/jenkins_home
RUN mkdir -p ${JENKINS_DOWNLOAD_DIR}

# jenkins version being bundled in this docker image
ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.60.3}

# jenkins.war checksum, download will be validated using it
ARG JENKINS_SHA=2d71b8f87c8417f9303a73d52901a59678ee6c0eefcf7325efed6035ff39372a

# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum 
# see https://github.com/docker/docker/issues/8331
# RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
#   && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c -

RUN curl -fsSL ${JENKINS_URL} -o ${JENKINS_DOWNLOAD_DIR}/jenkins.war \
  && echo "${JENKINS_SHA}  ${JENKINS_DOWNLOAD_DIR}/jenkins.war" | sha256sum -c -

# ENV JENKINS_UC https://updates.jenkins.io
# ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental

EXPOSE ${http_port}
EXPOSE ${agent_port}


USER ${user}
COPY jenkins.sh /usr/local/bin/jenkins.sh

USER root
RUN chmod +x /usr/local/bin/jenkins.sh

USER ${user}
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]