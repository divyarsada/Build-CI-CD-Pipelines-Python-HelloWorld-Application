// Global Variable for Retaining a Constant Build ID
def buildID = ""
def dockerImageID = ""
def registry = "sampletest19/helloworldpipeline"
def repoName = "helloworld-deployment-rolling-update"
def serviceName = "helloworld-service"
def podHash = ""
def podName = ""
def serviceAddress = ""
def registryCredential = 'docker_hub_login'
def dockerImage = 'sampletest19/helloworldpipeline'
def appName=
pipeline {
  agent any
  stages {
	stage('Build') {
        steps {
            sh 'make install'
        }
    }
	stage('Lint Test') {
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

	stage('Push Image to Docker hub') {
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
	stage('Deploy Kubernetes Cluster') {
		steps {
			script {
				sh "echo 'Check if Pod has Previously been Deployed'"
				script {
					podName = sh(script: "~/bin/kubectl get pods")
				}
				if (podName.isEmpty()) {
					sh "echo 'No Pod Found, Deploying Now'"
					~/bin/kubectl apply -f "$WORKSPACE/kubernetes.yml"
					#sh "~/bin/kubectl run `echo $repoName` --image=`echo $dockerImage`:`echo $BUILD_NUMBER` --replicas=2 --port=8000"
					script {
						sh "echo 'Getting Pod Name and Hash'"
						podName = sh(script: "~/bin/kubectl get pods --output=json | jq -r '.items[0] | select(.metadata.labels.run == \"$appName*\").metadata.name'", returnStdout: true).trim()
						podHash = sh(script: "~/bin/kubectl get pods --output=json | jq -r '.items[0] | select(.metadata.labels.run == \"$appName\").metadata.labels.\"pod-template-hash\"'", returnStdout: true).trim()
					}
				} else {
					sh "echo 'Pod Already Deployed, Updating Image'"
					sh "~/bin/kubectl set image deployment/`echo $repoName` `echo $repoName`=`echo $dockerImage`:`echo $BUILD_NUMBER`"
					sh "echo 'Restart Pod to Clear Cache'"
					sh "~/bin/kubectl rollout restart deployment/$repoName"
					sh "echo 'Retrieving New Pod Name and Hash'"
					script {
						podName = sh(script: "~/bin/kubectl get pods --output=json | jq '[.items[] | select(.status.phase != \"Terminating\") ] | max_by(.metadata.creationTimestamp).metadata.name'", returnStdout: true).trim()
						podHash = sh(script: "~/bin/kubectl get pods --output=json | jq '[.items[] | select(.status.phase != \"Terminating\") ] | max_by(.metadata.creationTimestamp).metadata.labels.\"pod-template-hash\"'", returnStdout: true).trim()
					}
				} 
				sh "echo 'Deployment Complete!'"
				sh "echo 'View Page Here (Please Allow a Minute for Services to Refresh): http://$serviceAddress:8080'"
			}
		}
	}
  }
}