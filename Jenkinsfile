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
        stage("get tag image") {
            steps {
              script {
                  env.TAG = readFile '.imagetag.cfg'
              }
              echo "${env.TAG}"
            }
        }

      //Build image locally
        stage("build tag image") {
            steps {
              sh "docker build -q --tag aramirol/jenkins-custom:${env.TAG} ."
            }
        }

      //Push image to hub.docker.com
        stage("push tag image") {
            steps {
              sh "docker push -q aramirol/jenkins-custom:${env.TAG}"
            }
        }

      //Build image locally
        stage("build latest image") {
            steps {
              sh "docker build -q --tag aramirol/jenkins-custom:latest ."
            }
        }

      //Push image to hub.docker.com
        stage("push latest image") {
            steps {
              sh "docker push -q aramirol/jenkins-custom:latest"
            }
        }

      // Logout from hub.docker.com
        stage("logout docker hub") {
            steps {
              sh "docker logout"      
            }
        }

      // Prune old images
        stage("prune old images") {
            steps {
              sh """
              docker image prune -a -f
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
