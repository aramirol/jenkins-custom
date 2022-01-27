// JENKINSFILE

// Init pipeline
pipeline {
    agent any

    environment {
        // Login credentialsID
        DOCKER_CREDENTIALS = credentials('hub_docker_credentials')
    }

    options {
        ansiColor('xterm')
    }

    stages {
      //Build image locally
        stage("build image") {
            steps {
               sh "docker build --tag aramirol/jenkins-custom:x.x.x ."
            }
        }
      
        stage("tag image") {
          // Tag image locally
            steps {
                sh "docker tag aramirol/jenkins-custom:x.x.x aramirol/jenkins-custom:latest"
            }
        }

        stage("login docker hub") {
          // Login to hub.docker.com (registry as default)
            steps {
                sh "docker login -u $DOCKER_CREDENTIALS_USR -p $DOCKER_CREDENTIALS_PSW"
            }
        }

        stage("push image") {
          // Push image to remote registry
            steps {
                sh """
                docker push aramirol/jenkins-custom:x.x.x
                """
            }
        }

        stage("logout docker hub") {
          // Logout from hub.docker.com
            steps {
                sh "docker logout"
            }
        }

        stage("delete images") {
          // Delete temporal images
            steps {
                sh """
                chmod 700 rmi.sh
                ./rmi.sh
                chmod 644 rmi.sh
                """
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