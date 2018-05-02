#build step 1 - build nginx
#configure mini
#print executed folder
#pwd
#--add-module=/usr/src/ngx_devel_kit-0.3.0 \
#--add-module=/usr/src/lua-nginx-module-0.10.12 \
#1.1. configure from source code
#ngrelPATH="nginx-release-1.14.0"
#test -f './release-1.14.0.tar.gz' || wget https://github.com/nginx/nginx/archive/release-1.14.0.tar.gz
#test -d './$ngrelPATH' || tar -xf release-1.14.0.tar.gz
#cd $ngrelPATH
test -d './modules' || mkdir modules
cd modules
test -f './v0.3.0.tar.gz' || wget https://github.com/simplresty/ngx_devel_kit/archive/v0.3.0.tar.gz
test -f './v0.10.12.tar.gz' || wget https://github.com/openresty/lua-nginx-module/archive/v0.10.12.tar.gz
test -d './ngx_devel_kit-0.3.0' || tar -xf v0.3.0.tar.gz
test -d './lua-nginx-module-0.10.12' || tar -xf v0.10.12.tar.gz
cd ..
test -f './configure' || mv ./auto/configure .
make clean
./configure \
--prefix=/etc/nginx                   \
--sbin-path=/usr/sbin/nginx           \
--conf-path=/etc/nginx/nginx.conf     \
--pid-path=/var/run/nginx.pid         \
--lock-path=/var/run/nginx.lock       \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/lib/nginx/client_temp \
--http-proxy-temp-path=/var/lib/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/lib/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/lib/nginx/scgi_temp \
--user=www-data \
--group=www-data \
--add-module=./modules/ngx_devel_kit-0.3.0 \
--add-module=./modules/lua-nginx-module-0.10.12 \
--modules-path=/usr/lib/nginx/modules \
--with-debug \
--with-threads 
#-----------------------------------------------------
#1.2_tune/customize
#customize before build deb
#added /etc/init.d/nginx - not necessary now for docker
#added /etc/nginx/nginx.conf
#added /etc/nginx/html/index.html
#_orig means file from original package


#OWNER="sergko"
#REPO="nginx2docker2AWS_jenkinsfile"
#REF="master"

##/etc/nginx/html/index.html
#PATHgit="assets/html"
#FILEO="index.html"
##FILE="https://api.github.com/repos/$OWNER/$REPO/contents/$PATHgit/$FILEO?ref=$REF"
#FILE="https://api.github.com/repos/$OWNER/$REPO/contents/$PATHgit/$FILEO"
#curl -v --header 'Accept: application/vnd.github.v3.raw' \
#        -o $FILEO \
#        --location $FILE
#chmod -R 0644 $FILEO
#mv ./docs/html/index.html ./docs/html/index.html_orig
#mv index.html ./docs/html/index.html
mv ./docs/html/index.html ./docs/html/index.html_orig
cp ./assets/html/index.html ./docs/html/index.html

##/etc/nginx/nginx.conf
#PATHgit="assets"
#PATHgit="opsworks/nginx/release"
#FILEO="nginx.conf"
#FILE="https://api.github.com/repos/$OWNER/$REPO/contents/$PATHgit/$FILEO"
##FILE="https://api.github.com/repos/$OWNER/$REPO/contents/$PATHgit/$FILEO?ref=$REF"
#curl -v --header 'Accept: application/vnd.github.v3.raw' \
#        -o $FILEO \
#        --location $FILE
#chmod 0644 $FILEO
#mv ./conf/nginx.conf ./conf/nginx.conf_oring
#mv nginx.conf ./conf/nginx.conf
mv ./conf/nginx.conf ./conf/nginx.conf_oring
cp ./assets/nginx.conf ./conf/nginx.conf

#/etc/init.d/nginx
#PATHgit="opsworks/nginx/release"
#FILEO="nginx"
#FILE="https://api.github.com/repos/$OWNER/$REPO/contents/$PATHgit/$FILEO?ref=$REF"
#curl -v --header 'Accept: application/vnd.github.v3.raw' \
#        -o $FILEO \
#        --location $FILE
#chmod 0755 $FILEO

#----------------------------------------------------------------
#1.3 create deb
make
#instead of make install
#-y - approve all by default to prevenet stops
#-d2-debug level of output <0|1|2>
#make -n install does stop make from actually installing the files
checkinstall -D -y --install=no -d2 \
--fstrans=yes \
--maintainer=sergey.kovbyk@gmail.com \
--pkgname=nginx-opswork \
--pkgrelease=${BUILD_NUMBER} 
#make -n install \
#cp nginx-opswork_`date '+%Y%m%d'`-${BUILD_NUMBER}_amd64.deb nginx-opswork.deb
#cp -f nginx-opswork_1.14.0-${BUILD_NUMBER}_amd64.deb nginx-opswork.deb
#cp -f nginx-opswork_1.14.0-${BUILD_NUMBER}_amd64.deb nginx-opswork.deb
#ln -sf nginx-opswork_1.14.0-${BUILD_NUMBER}_amd64.deb /tmp/nginx-opswork.deb
#ln -sf nginx-opswork_1.14.0-${BUILD_NUMBER}_amd64.deb ../nginx-opswork.deb
#cd ..
#cp -f ./$ngrelPATH/nginx-opswork_1.14.0-${BUILD_NUMBER}_amd64.deb nginx-opswork.deb
mv -f ./nginx-opswork_1.14.0-${BUILD_NUMBER}_amd64.deb nginx-opswork.deb
