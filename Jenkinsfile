pipeline {
  agent any
  stages {
    stage('Deploy2AWS') {
      steps {
           sh 'ssh -i "/var/lib/jenkins/.ssh/aws/sergeykovbyktest.pem" -o StrictHostKeyChecking=No \
             -tt ec2-user@ec2-35-176-150-135.eu-west-2.compute.amazonaws.com \
             "docker pull sergko/opsworks_nginx_luamod \
             && docker run -it -d -p 8888:8888 sergko/opsworks_nginx_luamod:latest"'
          sh 'sleep 5s'
          sh 'if [ `curl ec2-user@ec2-35-176-150-135.eu-west-2.compute.amazonaws.com:8888 | grep  -c "by Sergey Kovbyk"` -gt 1 ]; \
             then echo "nginx customized by SergKo" && exit 0; else echo "smth goes wrong :( " && exit 1; fi '
      }
    }
  }
}