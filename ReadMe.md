```
kind delete cluster

kind create cluster --config kind-config.yaml

kind load docker-image docker.io/library/nginx:latest

kind load docker-image registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.5.0

kind load docker-image registry.k8s.io/ingress-nginx/controller:v1.12.0

kind load docker-image docker.io/hashicorp/http-echo:latest

k apply -f static-website-cm.yaml

kubectl label node kind-control-plane ingress-ready=true
```
>  https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

k apply -f deploy.yaml

k apply -f backend-service.yaml

>  Wait for Pods being Up

k apply -f nginx-cdn.yaml
