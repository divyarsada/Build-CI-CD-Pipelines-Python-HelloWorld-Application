pipeline {
     agent any
     environment {
        // Docker Hub username
        DOCKER_IMAGE_NAME = "sampletest19/helloworldpipeline"
    }
     stages {
         stage('Build') {
             steps {
                 sh 'make install'
             }
         }
         stage('Test') {
             steps {
                 sh 'make lint'
             }
         }
         stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                    app.inside {
                        sh 'echo Hello, World!'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
    } 
}