// JENKINSFILE

// Init pipeline
pipeline{
    agent any

    environment {
        DOCKER_CREDENTIALS = crendetials('hub-docker-credentials')
    }

    options {
        ansiColor('xterm')
    }

    stages {
        stage("build image") {
            steps {
                sh """
                docker build --tag aramirol/jenkins-custom:x.x.x .
                """
            }
        }
      
        stage("tag image") {
            steps {
                sh """
                docker tag aramirol/jenkins-custom:x.x.x aramirol/jenkins-custom:latest
                """
            }
        }

        stage("login docker hub") {
            steps {
                sh """
                docker login -u $DOCKER_CREDENTIALS_USR -p $DOCKER_CREDENTIALS_PSW
                """
            }
        }

        stage("push image") {
            steps {
                sh """
                docker push aramirol/jenkins-custom:x.x.x
                """
            }
        }
    }

    post {
        always {
            sh """
            docker logout
            """
        }
        cleanup {
            cleanWs()
        }
    }
}