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
                    def appImage = docker.build registry + ":$BUILD_NUMBER"
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
                        appImage.push()
                        appImage.push('latest')
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
                script{
                    def image_id = registry + ":$BUILD_NUMBER"
                    echo "$image_id"
                    sh "pwd"
                    sh "whoami"
                    sh 'chmod +x ./rolling-update.sh'
                    sh './rolling-update.sh'
                }
            }
        }
        
    } 
}