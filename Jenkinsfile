pipeline {
  agent any
  stages {
    stage('Deploy2AWS') {
      steps {
          sh 'ssh -i "/var/lib/jenkins/.ssh/aws/sergeykovbyktest.pem" \
             -tt ec2-user@ec2-35-176-150-135.eu-west-2.compute.amazonaws.com \
             "docker run -it -d -p 8888:8888 sergko/opsworks_nginx_luamod:latest"'
          sh 'sleep 5s'
          sh 'if [ `curl ec2-35-176-150-135.eu-west-2.compute.amazonaws.com:8888 | grep  -c "by Sergey Kovbyk"` -gt 1 ]; \
             then echo "nginx customized by SergKo"; else echo "smth goes wrong :( "; fi '
      }
    }
  }
}