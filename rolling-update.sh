#!/bin/bash
set -e
echo 'Check if Pod has Previously been Deployed'
echo 
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
    echo "$image"
    ~/bin/kubectl apply -f "$WORKSPACE/kubernetes.yml"
	echo 'Restart Pod to Clear Cache'
	~/bin/kubectl rollout status
	echo 'Retrieving New Pod'
	podName = `kubectl get pods --field-selector status.phase=Running`
    echo $podName
fi