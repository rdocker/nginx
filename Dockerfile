FROM centos:6.7
MAINTAINER ronnie <comdeng@live.com>

ENV TZ "Asia/Shanghai"

RUN curl http://mirrors.aliyun.com/repo/Centos-6.repo -o /etc/yum.repos.d/CentOS-Base.repo &&\
    curl http://tengine.taobao.org/download/tengine-2.1.2.tar.gz -L -o /root/tengine-2.1.2.tar.gz &&\
    yum -y install tar&&\
    cd /root/ && tar xvfz tengine-2.1.2.tar.gz &&\
    curl -L https://github.com/kali/nginx-operationid/archive/master.zip -o /root/nginx.operationid.zip &&\
    cd /root && yum -y install unzip && unzip nginx.operationid.zip &&\
    curl -L https://github.com/openresty/echo-nginx-module/archive/master.zip -o /root/echo-nginx-module.zip &&\
    cd /root && unzip echo-nginx-module.zip &&\
    yum -y install gcc pcre-devel openssl-devel &&\
    cd /root/tengine-2.1.2 &&\
    groupadd nginx &&\
    mkdir /data/ &&\
    useradd nginx -M -s /bin/nologin -g nginx &&\
    ./configure \
    --prefix=/opt/nginx \
    --add-module=../echo-nginx-module-master/ \
    --with-http_realip_module \
    --add-module=../nginx-operationid-master/ \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_stub_status_module \
    --with-http_v2_module &&\
    make install &&\
    rm -rf /root/tengine-2.1.2* &&\
    rm -rf /root/nginx.operationid* &&\
    rm -rf /root/echo-nginx-module* &&\
    yum -y erase tar unzip gcc pcre-devel openssl-devel &&\
    yum clean all &&\
    mkdir /opt/nginx/conf/vhost


COPY nginx.conf /opt/nginx/conf/nginx.conf
COPY default.conf /opt/nginx/conf/vhost/default.conf

EXPOSE 80
ENTRYPOINT ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
