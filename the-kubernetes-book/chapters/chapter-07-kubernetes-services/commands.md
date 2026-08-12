# Book Commands

## Hands-on with Services
``` bash
kubectl apply -f deploy.yaml -n kubernetes-book
kubectl get deploy svc-test -n kubernetes-book
```

### Workign with Services imperatively
``` bash
kubectl expose deployment svc-test --type=LoadBalancer -n kubernetes-book
# kubectl get ds -n kube-system
# kubectl describe ds svclb-svc-test-6e102ad8 -n kube-system
# In K3s a DaemonSet is created in order to handle the LoadBalancer connectivity
kubectl get svc -o wide -n kubernetes-book
kubectl describe svc svc-test -n kubernetes-book
kubectl delete svc svc-test -n kubernetes-book
```

### The declarative way
``` bash
kubectl apply -f lb.yaml -n kubernetes-book
kubectl get svc svc-lb -n kubernetes-book
kubectl get endpointslices -n kubernetes-book
kubectl describe endpointslice svc-lb-lbdwh -n kubernetes-book
```

## Clean up
``` bash
kubectl delete -f deploy.yaml -f lb.yaml -n kubernetes-book
```

# Personal Commands

## EndpointSlices with named ports
``` bash
kubectl apply -f ./personal/deploy.yaml -f ./personal/service.yaml -n kubernetes-book
kubectl get endpointslice -l kubernetes.io/service-name=hello-deploy-service -n kubernetes-book
kubectl apply -f ./personal/deploy-new-port.yaml -n kubernetes-book
kubectl get endpointslice -l kubernetes.io/service-name=hello-deploy-service -o wide -n kubernetes-book
# You should see two endpointslices for each port during the rollout process
kubectl delete -f ./personal/deploy-new-port.yaml -f ./personal/service.yaml -n kubernetes-book
```

## DNS inside each Pod
``` bash
kubectl apply -f ./personal/deploy.yaml -n kubernetes-book
kubectl get pods -l app=hello-deploy -n kubernetes-book
kubectl exec hello-deploy-5989bbdb8f-57zfz -n kubernetes-book -- cat /etc/resolv.conf
# The Kubernetes DNS is injected in each container 
# search kubernetes-book.svc.cluster.local svc.cluster.local cluster.local
# nameserver 10.43.0.10
# options ndots:5
kubectl delete -f ./personal/deploy.yaml -n kubernetes-book
```