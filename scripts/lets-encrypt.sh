
#!/usr/bin/env bash


echo '''
Followed:
    https://kosyfrances.com/ingress-gce-letsencrypt/
    https://cloud.google.com/community/tutorials/nginx-ingress-gke
Prerequisites: 
    1. Installed NGINX Ingress Controller on Google Kubernetes Engine
    2. Setup A record for domain (jijivi.net, *.jijivi.net) pointing to NGINX_INGRESS_IP
'''


kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.crds.yaml

helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install \
    cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --version v1.6.1
kubectl get pods --namespace cert-manager


echo '''
Create Let’s Encrypt Cluster Issuer:
This represent a certificate authority (CA) from which signed x509 certificates can be obtained.
'''

kubectl apply -f clusterissuer-letsencrypt-prod.yaml
echo "Sleeping 5 secs..."
sleep 5
kubectl describe ClusterIssuer/letsencrypt-prod 

echo '''
Create a Ingress resource which will make the certificate request

'''
kubectl apply -f ingress-example.yaml

kubectl get ingress/hello-app-ingress certificate/hello-app-ingress secret/hello-app-tls



echo '''
For cleanup:
    kubectl delete -f clusterissuer-letsencrypt-prod.yaml
    kubectl delete -f ingress-example.yaml
    helm delete cert-manager -n cert-manager
    kubectl delete namespace cert-manager
    kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.crds.yaml
    echo | gcloud compute addresses delete jijivi --global
'''
