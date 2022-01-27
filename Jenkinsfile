// JENKINSFILE

// Init pipeline
pipeline {
    agent any

    environment {
    //    DOCKER_CREDENTIALS = credentials('hub-docker-credentials')
    }

    options {
        ansiColor('xterm')
    }

    stages {
        stage("build image") {
            steps {
              echo "build"
              //  sh "docker build --tag aramirol/jenkins-custom:x.x.x ."
            }
        }
      
        stage("tag image") {
            steps {
              echo "tag"
              //  sh "docker tag aramirol/jenkins-custom:x.x.x aramirol/jenkins-custom:latest"
            }
        }

        stage("login docker hub") {
            steps {
              echo "login"
              //  sh "docker login -u $DOCKER_CREDENTIALS_USR -p $DOCKER_CREDENTIALS_PSW"
            }
        }

        stage("push image") {
            steps {
              echo "push"
              //  sh "docker push aramirol/jenkins-custom:x.x.x"
            }
        }
    }

    post {
        always {
          echo "logout"
          //  sh "docker logout"
        }
        cleanup {
            cleanWs()
        }
    }
}