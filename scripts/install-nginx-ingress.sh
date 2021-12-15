#!/usr/bin/env bash

# https://cloud.google.com/community/tutorials/nginx-ingress-gke
echo "1. Add the nginx-stable Helm repository"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

echo "2. Deploy an NGINX controller Deployment and Service"
helm install nginx-ingress ingress-nginx/ingress-nginx

echo "3. Verify that the nginx-ingress-controller Deployment and Service are deployed"
kubectl get deployment nginx-ingress-ingress-nginx-controller
kubectl get service nginx-ingress-ingress-nginx-controller

echo "4. Wait a few moments while the Google Cloud L4 load balancer gets deployed, and then confirm that the nginx-ingress-nginx-ingress Service has been deployed and that you have an external IP address associated with the service:"
echo sleeping for 60 secs...
sleep 60
kubectl get service nginx-ingress-ingress-nginx-controller

echo "5. Export the EXTERNAL-IP of the NGINX ingress controller in a variable"
export NGINX_INGRESS_IP=$(kubectl get service nginx-ingress-ingress-nginx-controller -ojson | jq -r '.status.loadBalancer.ingress[].ip')
[ -z "$NGINX_INGRESS_IP" ] && echo "NGINX_INGRESS_IP is empty" && exit 1 || true


echo '''
Update DNS A-record for jijivi.net and *.jijivi.net to ${NGINX_INGRESS_IP}
'''
gcloud beta dns --project=jijivi record-sets delete 'jijivi.net' --type="A" --zone="jijivi-net" || true
gcloud beta dns --project=jijivi record-sets delete '*.jijivi.net' --type="A" --zone="jijivi-net" || true

gcloud beta dns --project=jijivi record-sets transaction start --zone="jijivi-net" && \
gcloud beta dns --project=jijivi record-sets transaction add $NGINX_INGRESS_IP --name="jijivi.net." --ttl="300" --type="A" --zone="jijivi-net" && \
gcloud beta dns --project=jijivi record-sets transaction execute --zone="jijivi-net"

gcloud beta dns --project=jijivi record-sets transaction start --zone="jijivi-net" && \
gcloud beta dns --project=jijivi record-sets transaction add $NGINX_INGRESS_IP --name="*.jijivi.net." --ttl="300" --type="A" --zone="jijivi-net" && \
gcloud beta dns --project=jijivi record-sets transaction execute --zone="jijivi-net"


exit 0

echo "6. Create a sample deployment and svc"
kubectl create deployment hello-app --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment hello-app --port=8080 --target-port=8080


echo "7. Create a simple Ingress Resource YAML file that uses the NGINX Ingress Controller and has one path rule defined:"
cat <<EOF > ingress-resource.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
    name: ingress-resource
    annotations:
        kubernetes.io/ingress.class: "nginx"
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
    rules:
    - 
        host: "jijivi.net"
        http:
            paths:
                -
                    pathType: Prefix
                    path: "/hello"
                    backend:
                        service:
                            name: hello-app
                            port:
                                number: 8080
EOF
kubectl apply -f ingress-resource.yaml
kubectl get ingress ingress-resource
curl http://jijivi.net/hello
