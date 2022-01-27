// JENKINSFILE

// Defining AWS Credentials
def credentialsForTestWrapper(block) {
    withCredentials([
        [
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: "aws_test",
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            //secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ],
        [
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: "aws_test",
            //accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ],
    ])
    {
        block.call()
    }
}

// Init pipeline
pipeline{
    agent any

    options {
        ansiColor('xterm')
    }

    stages {
        stage("build image") {
            steps {
              credentialsForTestWrapper {
                  sh """
                  docker build --tag aramirol/jenkins-custom:x.x.x .
                  """
              }
            }
        }
      

        stage("tag image") {
            steps {
              credentialsForTestWrapper {
                  sh """
                  docker tag aramirol/jenkins-custom:x.x.x aramirol/jenkins-custom:latest
                  """
              }
            }
        }

        stage("login docker hub") {
            steps {
              credentialsForTestWrapper {
                  sh """
                  docker login -u <<username>> -p <<password>>
                  """
              }
            }
        }

        stage("push image") {
            steps {
              credentialsForTestWrapper {
                  sh """
                  docker push aramirol/jenkins-custom:x.x.x
                  docker push aramirol/jenkins-custom:latest
                  """
              }
            }
        }

    }

    post {
        always {
            credentialsForTestWrapper {
              sh """
              docker logout
              """
            }
        }
        cleanup {
            cleanWs()
        }
    }
}