FROM centos:centos7
ARG VERSION=latest
ARG MONGODB_HOST=127.0.0.1
ARG MONGODB_PORT=27017

LABEL maintainer="Alexander Yanchin <ayanchin85@gmail.com>"

RUN yum -y install wget &&\
    yum -y install java-11-openjdk &&\
    wget --no-check-certificate -O msm2-application-community.tar.gz https://mastermindcms.co/cdn/msm2-application-$VERSION-community.tar.gz &&\
    tar -xf msm2-application-community.tar.gz -C / &&\
    rm msm2-application-community.tar.gz &&\
    sed -i -e "s/spring.data.mongodb.host=127.0.0.1/spring.data.mongodb.host=$MONGODB_HOST/g" -e "s/spring.data.mongodb.port=27017/spring.data.mongodb.port=$MONGODB_PORT/g" /MSM2/config/common-production.properties &&\
    cd /MSM2/bin &&\
    sed -i -e 's/\r$//' createSystemUser.sh &&\
    sed -i -e 's/\r$//' startupServer.sh &&\
    chmod +x ./createSystemUser.sh ./startupServer.sh &&\
    ./createSystemUser.sh &&\
    chown mastermind:dreamcloud -R /MSM2/

USER mastermind

EXPOSE 5000

CMD "/MSM2/bin/startupServer.sh"