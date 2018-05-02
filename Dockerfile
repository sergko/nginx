FROM ubuntu:18.04
MAINTAINER Sergey Kovbyk <kovbyk@gmail.com>
# a few minor docker-specific tweaks
COPY nginx-opswork.deb /opt
RUN set -xe \
&& apt update \
&& apt install -yq --no-install-recommends *liblua5.1* \
&& dpkg -i /opt/nginx-opswork.deb \
&& rm -f /tmp/nginx-opswork.deb
#probably unnecessary for docker to use daemon )
#COPY nginx /etc/init.d/nginx
# forward request and error logs to docker log collector
RUN mkdir /var/lib/nginx; mkdir /var/log/nginx \
&& ln -sf /dev/stdout /var/log/nginx/access.log \
&& ln -sf /dev/stderr /var/log/nginx/error.log
EXPOSE 8888
# overwrite this with 'CMD []' in a dependent Dockerfile
CMD ["nginx", "-g", "daemon off;"]
