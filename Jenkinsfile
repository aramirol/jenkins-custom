// JENKINSFILE

// Init pipeline
pipeline {
    agent any

    options {
        ansiColor('xterm')
    }

    stages {
      // Login to hub.docker.com with personal credentials
        stage("login docker hub") {
            environment {
              // Login credentialsID
              DOCKER_CREDENTIALS = credentials('hub_docker_credentials')
            }
            steps {
              sh "docker login --username $DOCKER_CREDENTIALS_USR --password ${DOCKER_CREDENTIALS_PSW}"
            }
        }

      //Build image locally
        stage("build tag image") {
            steps {
              sh "docker build --tag aramirol/jenkins-custom:${VAR} ."
            }
        }

      //Push image to hub.docker.com
        stage("push tag image") {
            steps {
              sh "docker push aramirol/jenkins-custom:${VAR}"
            }
        }

      // Logout from hub.docker.com
        stage("logout docker hub") {
            steps {
              sh "docker logout"      
            }
        }

      //Build image locally
        stage("build latest image") {
            input{
              message "Do you want tag this image as latest?"
            }
            steps {
              sh "docker build --tag aramirol/jenkins-custom:latest ."
            }
        }

      // Login to hub.docker.com with personal credentials
        stage("login docker hub again") {
            environment {
              // Login credentialsID
              DOCKER_CREDENTIALS = credentials('hub_docker_credentials')
            }
            steps {
              sh "docker login --username $DOCKER_CREDENTIALS_USR --password ${DOCKER_CREDENTIALS_PSW}"
            }
        }

      //Push image to hub.docker.com
        stage("push latest image") {
            steps {
              sh "docker push aramirol/jenkins-custom:latest"
            }
        }

      // Logout from hub.docker.com
        stage("logout docker hub again") {
            steps {
              sh "docker logout"      
            }
        }
    }

    post {
        cleanup {
          // Clean current Workspace
            cleanWs()
        }
    }
}
