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
              sh "echo $DOCKER_CREDENTIALS_PWD"
            }
        }

//    stages {
//      //Build image locally
//        stage("build tag image") {
//            steps {
//              sh "docker build --tag aramirol/jenkins-custom:${VAR} ."
//            }
//        }
//    }

//    stages {
//      //Build image locally
//        stage("build latest image") {
//            steps {
//              sh "docker build --tag aramirol/jenkins-custom:latest ."
//            }
//        }
//    }

      // Logout from hub.docker.com
        stage("logout docker hub") {
            steps {
              sh "echo adios"      
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
