// JENKINSFILE

// Init pipeline
pipeline {
    agent any

    options {
        ansiColor('xterm')
    }

    environment {
        // Login credentialsID
        DOCKER_CREDENTIALS = credentials('hub_docker_credentials')
    }

    stages {
      // Login to hub.docker.com with personal credentials
        stage("login docker hub") {
            steps {
              sh {
                "docker login -u $DOCKER_CREDENTIALS_USR -p $DOCKER_CREDENTIALS_PWD"
              }      
            }
        }
    }

//    stages {
//      //Build image locally
//        stage("build tag image") {
//            steps {
//              sh {
//                "docker build --tag aramirol/jenkins-custom:${VAR} ."
//              }      
//            }
//        }
//    }

//    stages {
//      //Build image locally
//        stage("build latest image") {
//            steps {
//              sh {
//                "docker build --tag aramirol/jenkins-custom:latest ."
//              }      
//            }
//        }
//    }

    stages {
      // Logout from hub.docker.com
        stage("logout docker hub") {
            steps {
              sh {
                "docker logout"
              }      
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
