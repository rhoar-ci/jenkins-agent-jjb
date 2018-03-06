FROM openshift/jenkins-slave-base-centos7:latest
MAINTAINER Ladislav Thon <lthon@redhat.com>

USER root

COPY patches /tmp/patches/

RUN yum -y install epel-release && \
    yum -y install python-pip patch && \
    yum clean all -y && \
    pip install --upgrade pip six 'jenkins-job-builder>=2.0.0' && \
    for P in /tmp/patches/*.patch ; do patch --directory / --strip 0 < $P ; done && \
    rm -rf /tmp/patches

COPY jenkins_jobs.ini /etc/jenkins_jobs/
COPY jjb /usr/local/bin/

USER 1001
