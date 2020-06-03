#!/bin/bash
set -e
echo 'Check if Pod has Previously been Deployed'

podName=`~/bin/kubectl get pods --field-selector status.phase=Running`
echo $podName
if [ -z "$podName" ]
then
    #statements
    echo 'No Pod Found, Deploying Now'
    `kubernetesDeploy(kubeconfigId:'kubeconfig',configs:'kubernetes.yml',enableConfigSubstitution:true)`
    echo 'Getting Pod Name and Hash'
    podName = `kubectl get pods --field-selector status.phase=Running`
    echo $podName
else
    #statements
    echo 'pods already deployed'
    sh "~/bin/kubectl apply -f kubernetes.yml
	sh "echo 'Restart Pod to Clear Cache'"
	sh "~/bin/kubectl rollout status"
	sh "echo 'Retrieving New Pod'"
	podName = `kubectl get pods --field-selector status.phase=Running`
    echo $podName
fi