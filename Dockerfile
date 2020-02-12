FROM centos:7.7.1908 as build

ADD nginx-1.16.1.tar.gz openssl-1.1.1.tar.gz pcre-8.43.tar.gz /tmp/
COPY nginx-module-vts/ /tmp/nginx-module-vts
RUN yum update -y && yum install -y gcc gcc-c++ make perl-core zlib-devel \
&& mkdir -p /opt/nginx/logs /opt/nginx/conf /opt/nginx/sbin \
&& cd /tmp/nginx-1.16.1/ && ./configure --prefix=/opt/nginx --sbin-path=/opt/nginx/sbin/nginx \
--conf-path=/opt/nginx/conf/nginx.conf --error-log-path=/opt/nginx/logs/error.log \
--http-log-path=/opt/nginx/logs/access.log --pid-path=/opt/nginx/logs/nginx.pid  \
--with-http_ssl_module --with-http_realip_module --without-http_gzip_module \
--add-module=/tmp/nginx-module-vts \
--with-openssl=/tmp/openssl-1.1.1 \
--with-pcre=/tmp/pcre-8.43 \
&& make && make install


FROM centos:7.7.1908 
COPY --from=build /opt/nginx /opt/nginx
COPY ./nginx/ /opt/nginx/
EXPOSE 8080
CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
