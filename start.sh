#!/bin/bash
kind create cluster --name sandbox --config sandbox-cluster.yaml

#use worker3 ingress only
kubectl taint nodes sandbox-worker3 node-role.kubernetes.io/ingress="":NoSchedule

# GW API crd-s
git clone --depth 1 --branch "v0.4.0" https://github.com/kubernetes-sigs/gateway-api.git
cd gateway-api
kubectl kustomize config/crd | kubectl apply -f -
rm -rf gateway-api
cd ..

#Jaeger tracer
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
  --create-namespace \
  --namespace jaeger \

helm repo update
helm install jaeger jaegertracing/jaeger \

#Traefik
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install traefik traefik/traefik \
  --create-namespace \
  --namespace traefik \
  --values traefik-values.yml

# metrics server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm install metrics-server metrics-server/metrics-server \
  --create-namespace \
  --namespace metrics-server \
  --set "args={--kubelet-insecure-tls}"

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus \
  --create-namespace \
  --namespace prometheus

kubectl apply -k default
