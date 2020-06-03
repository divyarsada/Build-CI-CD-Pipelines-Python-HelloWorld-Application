pipeline {
    agent any
    environment {
        registry = "sampletest19/helloworldpipeline"
        registryCredential = 'docker_hub_login'
        dockerImage = 'sampletest19/helloworldpipeline'
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
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
                    dockerImage.push()
                    }
                }
            }
        }
        stage('Set current kubectl context') {
            steps {
               sh 'export KUBECONFIG=~/.kube/config'
            }
        }
            
        stage('DeployToKubernetesCluster') {
            when {
                branch 'master'
            }
            steps {
                sh './rolling-update.sh'
            }
            
        }
        
    } 
}
