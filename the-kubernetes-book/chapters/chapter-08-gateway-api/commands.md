# Book Commands

## How Gateway API works

### Gateway API resources
``` bash
kubectl api-resources --api-group=gateway.networking.k8s.io
kubectl api-resources --api-group=gateway.envoyproxy.io
```

### GatewayClasses
``` bash
kubectl get gc
kubectl describe gc istio
```

## Hands-on with Gateway API

### Installing Gateway API
``` bash
kubectl get gc

# NGINX Gateway Fabric
kubectl kustomize \
    "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.3.0" \
    | kubectl apply -f -
kubectl api-resources --api-group=gateway.networking.k8s.io
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric \
    --version 2.3.0 \
    --namespace nginx-gateway \
    --create-namespace
kubectl get pods -n nginx-gateway
kubectl get gc

# Cloud Provider for KIND
go install sigs.k8s.io/cloud-provider-kind@latest
sudo install ~/go/bin/cloud-provider-kind /usr/local/bin
sudo cloud-provider-kind --gateway-channel="standard"
kubectl api-resources --api-group=gateway.networking.k8s.io
kubectl get gc
```

### Traffic splitting example
``` bash
kubectl apply -f ./app-canary/app.yaml -n kubernetes-book
kubectl get deployments -n kubernetes-book
kubectl apply -f ./app-canary/gtw.yaml -n kubernetes-book
kubectl get gtw -n kubernetes-book
kubectl describe gtw gtw-prod-1 -n kubernetes-book
kubectl get svc -n kubernetes-book
kubectl describe svc gtw-prod-1-istio -n kubernetes-book
# kubectl get ds -n kube-system
# kubectl describe ds svclb-gtw-prod-1-istio-39424e7a -n kube-system
# In K3s a DaemonSet is created in order to handle the LoadBalancer connectivity
kubectl get deployments -n kubernetes-book
kubectl describe deploy gtw-prod-1-istio -n kubernetes-book
kubectl get endpointslice -l kubernetes.io/service-name=gtw-prod-1-istio -o yaml -n kubernetes-book
# istioctl commands (can only be executed in the cluster node)
# istioctl proxy-config listeners "gtw-prod-1-istio-d46456456-656bk" -n kubernetes-book
# istioctl proxy-config routes "gtw-prod-1-istio-d46456456-656bk" -n kubernetes-book
# istioctl proxy-config clusters "gtw-prod-1-istio-d46456456-656bk" -n kubernetes-book
# istioctl proxy-config endpoints "gtw-prod-1-istio-d46456456-656bk" -n kubernetes-book
kubectl apply -f ./app-canary/route.yaml -n kubernetes-book
kubectl get httproute -n kubernetes-book
kubectl describe httproute route-canary -n kubernetes-book
kubectl delete -f ./app-canary/app.yaml -f ./app-canary/gtw.yaml -f ./app-canary/route.yaml -n kubernetes-book
```

### Multi-tenancy example
``` bash
kubectl apply -f ./app-xnamespace/ns.yaml
kubectl apply -f ./app-xnamespace/gtw.yaml
kubectl get gtw -n ns-infra
kubectl apply -f ./app-xnamespace/shield.yaml
kubectl get all -n ns-shield
kubectl apply -f ./app-xnamespace/hydra.yaml
kubectl get all -n ns-hydra
kubectl delete -f ./app-xnamespace/hydra.yaml -f ./app-xnamespace/shield.yaml -f ./app-xnamespace/gtw.yaml -f ./app-xnamespace/ns.yaml
```