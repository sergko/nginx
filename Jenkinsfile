pipeline {
  agent any
  stages {
    stage('BuildDeb') {
      steps {
          sh 'test -f "./v0.3.0.tar.gz" || wget https://github.com/simplresty/ngx_devel_kit/archive/v0.3.0.tar.gz'
          sh 'test -f "./v0.10.12.tar.gz" || wget https://github.com/openresty/lua-nginx-module/archive/v0.10.12.tar.gz'
          sh 'test -d "./ngx_devel_kit-0.3.0" || tar -xf v0.3.0.tar.gz'
          sh 'test -d "./lua-nginx-module-0.10.12" || tar -xf v0.10.12.tar.gz'
          sh 'test -f "./configure" || mv ./auto/configure .'
          sh './configure \
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
--add-module=./ngx_devel_kit-0.3.0 \
--add-module=./lua-nginx-module-0.10.12 \
--modules-path=/usr/lib/nginx/modules \
--with-debug \
--with-threads'
          sh 'mv ./docs/html/index.html ./docs/html/index.html_orig'
          sh 'cp ./assets/html/index.html ./docs/html/index.html'
          sh 'mv ./conf/nginx.conf ./conf/nginx.conf_oring'
          sh 'cp ./assets/nginx.conf ./conf/nginx.conf'
          sh 'make'
          sh 'checkinstall -D -y --install=no -d2 \
             --fstrans=yes \
             --maintainer=sergey.kovbyk@gmail.com \
             --pkgname=nginx-opswork \
             --pkgversion=1.14.0 \
             --pkgrelease=${BUILD_NUMBER}'
          sh 'mv -f ./nginx-opswork_1.14.0-${BUILD_NUMBER}_amd64.deb nginx-opswork.deb'
}
    }
    stage('Dokerize') {
      steps {
        sh 'docker build -t opswork/nginx:1.14.0-${BUILD_NUMBER} -t opswork/nginx:latest .'
        sh 'docker kill $(docker ps -aq) || exit 0'
        sh 'docker run -it -d -p 8888:8888 opswork/nginx:latest'
        sh 'sleep 5s'
        sh 'if [ `curl localhost:8888 | grep  -c "by Sergey Kovbyk"` -gt 1 ]; \
            then echo "nginx customized by SergKo" && exit 0; else echo "smth goes wrong :( " && exit 1; fi '
        sh 'docker kill --signal=SIGHUP opswork/nginx:latest || exit 0'
        withCredentials([usernamePassword(credentialsId: 'dockerHub_skovb', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
          sh "docker tag opswork/nginx:latest sergko/opsworks_nginx_luamod:latest"
          sh 'docker push sergko/opsworks_nginx_luamod:latest'
          sh "docker tag opswork/nginx:1.14.0-${BUILD_NUMBER} sergko/opsworks_nginx_luamod:1.14.0-${BUILD_NUMBER}"
          sh 'docker push sergko/opsworks_nginx_luamod:1.14.0-${BUILD_NUMBER}'
        }
      }
    }
    stage('Deploy2AWS') {
      steps {
           sh 'ssh -i "/var/lib/jenkins/.ssh/aws/sergeykovbyktest.pem" -o StrictHostKeyChecking=No \
             -tt ec2-user@ec2-35-176-150-135.eu-west-2.compute.amazonaws.com \
             "docker pull sergko/opsworks_nginx_luamod \
             && sudo service docker restart && docker run -it -d -p 8888:8888 sergko/opsworks_nginx_luamod:latest"'
          sh 'sleep 5s'
          sh 'if [ `curl ec2-user@ec2-35-176-150-135.eu-west-2.compute.amazonaws.com:8888 | grep  -c "by Sergey Kovbyk"` -gt 1 ]; \
             then echo "nginx customized by SergKo" && exit 0; else echo "smth goes wrong :( " && exit 1; fi '
      }
    }
  }
}