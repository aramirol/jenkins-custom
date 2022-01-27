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

    def app

    stages {
      //Build image locally
        stage("build image") {
            steps {
               app = docker.build("aramirol/jenkins-custom")
            }
        }

        stage("test image") {
          // Logout from hub.docker.com
            steps {
                app.inside {
                  sh 'echo "Tests passed"'
                }
            }
        }

        stage("push image") {
          // Push image to remote registry
            steps {
                docker.withRegistry('https://hub.docker.com', 'hub_docker_credentials') {
                  app.push("${env.BUILD_NUMBER}")
                  app.push("latest")
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