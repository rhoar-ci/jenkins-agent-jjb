FROM openshift/jenkins-slave-base-centos7:latest
MAINTAINER Ladislav Thon <lthon@redhat.com>

USER root

COPY patches /tmp/patches/

RUN yum -y install epel-release && \
    yum -y install jq xmlstarlet patch python-pip && \
    yum -y clean all && \
    rm -rf /var/cache/yum && \
    # force python-jenkins to 0.4.15, because later versions migrate to a different HTTP client library,
    # which is much harder to patch for supporting Bearer token auth
    #
    # also force jenkins-job-builder to 2.0.10, because even though the patch might apply in the future,
    # it's better to verify manually
    pip install --upgrade pip six 'python-jenkins==0.4.15' 'jenkins-job-builder==2.0.10' && \
    for P in /tmp/patches/*.patch ; do patch --directory / --strip 0 < $P ; done && \
    rm -rf /tmp/patches

COPY jenkins_jobs.ini /etc/jenkins_jobs/
COPY jjb /usr/local/bin/

USER 1001
