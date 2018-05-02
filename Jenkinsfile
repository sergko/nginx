pipeline {
  agent any
  stages {
    stage('BuildDeb') {
      steps {
        sh './step1_build.sh'
      }
    }
    stage('Dokerize') {
      steps {
        sh 'docker build -t opswork/nginx:1.14.0-${BUILD_NUMBER} -t opswork/nginx:latest .'
        withCredentials([usernamePassword(credentialsId: 'dockerHub_skovb', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
          sh "docker tag opswork/nginx:latest sergko/opsworks_nginx_luamod"
          sh 'docker push sergko/opsworks_nginx_luamod'
        }
      }
    }
    stage('Deploy2AWS') {
      steps {
          sh 'ssh -i "/var/lib/jenkins/.ssh/aws/sergeykovbyktest.pem" \
-t ec2-user@ec2-35-176-150-135.eu-west-2.compute.amazonaws.com \
"docker pull sergko/opsworks_nginx_luamod \
&& docker run -it -p 8888:8888 sergko/opsworks_nginx_luamod:latest" &'
sh 'sleep 5s'
sh 'if [ `curl ec2-user@ec2-35-176-150-135.eu-west-2.compute.amazonaws.com:8888 | grep  -c "by Sergey Kovbyk"` -gt 1 ]; \
then echo "nginx customized by SergKo"; else echo "smth goes wrong :( "; fi '
      }
    }
  }
}