FROM centos:6
MAINTAINER billie@purplebooth.co.uk

RUN yum -y install ruby ruby-devel gem rubygems unzip gcc rpm-build wget

RUN gem install fpm
COPY run.sh /run.sh
RUN chmod a+x /run.sh
COPY rpmbuild /root/rpmbuild
COPY ords.3.0.0.121.10.23.zip /root/rpmbuild/ords.3.0.0.121.10.23.zip
RUN mkdir /rpmbuild

WORKDIR /root

ENTRYPOINT /run.sh
