FROM centos:latest
MAINTAINER Reynier Perez <reynierpm@gmail.com>
RUN \
  yum update -y && \
  yum install -y epel-release && \
  yum install -y iproute python-setuptools hostname inotify-tools yum-utils which jq && \
  yum clean all && \
  easy_install supervisor
COPY container-files /
RUN chmod +x /config/bootstrap.sh
ENTRYPOINT ["/config/bootstrap.sh"]
