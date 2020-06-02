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
                sh '''#!/bin/bash
                    echo "$whoami"
                    echo "$pwd"
                    sh "cd /home/ec2-user/"
                    echo "Hello from bash"
                    echo "Who I'm $SHELL"
                    echo 'Check if Pod has Previously been Deployed'
                    podName=`kubectl get pods --field-selector status.phase=Running`
                    echo $podName
                    if [ -z "$podName" ]
                    then
                        echo 'No Pod Found, Deploying Now'
                        input 'Deploy to Cluster?'
                        milestone(1)
                        kubernetesDeploy(
                            kubeconfigId: 'kubeconfig',
                            configs: 'kubernetes.yml',
                            enableConfigSubstitution: true
                        )
                    else
                        echo 'pods alreay deployed"
                    fi
                '''
            }
            
        }
        
    } 
}
