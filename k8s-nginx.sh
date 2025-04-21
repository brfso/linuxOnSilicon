#!/bin/bash
# Script to configure ntp and timezone for brasil
# Fernando Oliveira
# Created at: 2025-05-20

echo "*****************************************"
echo " Starting script: ${0}"
echo " Confgure PODs NGINX"
echo " Executing commands in: ${HOME}"
echo "*****************************************"

kubectl apply -f https://k8s.io/examples/application/deployment.yaml
kubectl describe deployment nginx-deployment
kubectl get pods -l app=nginx
