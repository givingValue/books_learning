# Book Commands

## Hands-on with Pods

### Deploying Pods from a manifest file
``` bash
kubectl apply -f pod.yaml -n kubernetes-book
kubectl get pods -n kubernetes-book
```

### Introspecting Pods
``` bash
kubectl get pods -n kubernetes-book -o wide
kubectl get pods -n kubernetes-book -o yaml
kubectl get pods hello-pod -n kubernetes-book -o yaml
kubectl describe pod hello-pod -n kubernetes-book
kubectl logs hello-pod -n kubernetes-book
kubectl logs hello-pod --container hello-ctr -n kubernetes-book
```

### kubectl exec
``` bash
kubectl exec hello-pod -n kubernetes-book -- ps
kubectl exec hello-pod --container hello-ctr -n kubernetes-book -- ps
kubectl exec -it hello-pod -n kubernetes-book -- sh
kubectl exec -it hello-pod --container hello-ctr -n kubernetes-book -- sh
kubectl exec -it hello-pod --container hello-ctr -n kubernetes-book -- apk add curl | curl localhost:8080
```

### Pod hostnames
``` bash
kubectl exec hello-pod -n kubernetes-book -- env
```

### Check Pod immutability
``` bash
kubectl edit pod hello-pod -n kubernetes-book
```

### Multi-container Pod example - init container
``` bash
kubectl apply -f initpod.yaml -n kubernetes-book
kubectl get pods initpod -n kubernetes-book --watch
kubectl describe pod initpod -n kubernetes-book
kubectl logs initpod --container init-ctr -n kubernetes-book
kubectl apply -f initsvc.yaml -n kubernetes-book
kubectl get pods initpod -n kubernetes-book --watch
kubectl describe pod initpod -n kubernetes-book
```

### Multi-container Pod example - sidecar container
``` bash
kubectl apply -f initsidecar.yaml -n kubernetes-book
kubectl get pod git-sync -n kubernetes-book
kubectl describe pod git-sync -n kubernetes-book
kubectl get svc svc-sidecar -n kubernetes-book
curl localhost:30666
```

## Cleanup
``` bash
kubectl delete pod hello-pod initpod git-sync -n kubernetes-book
kubectl delete svc k8sbook svc-sidecar -n kubernetes-book
kubectl delete -f initsidecar.yaml -f initpod.yaml -f pod.yaml -f initsvc.yaml
```

# Personal Commands

## Kubernetes DNS configuration
``` bash
kubectl get configmap cluster-dns -n kube-system -o yaml
kubectl get configmap coredns -n kube-system -o yaml
kubectl logs deployment/coredns -n kube-system
kubectl apply -f ./personal/coredns-custom.yaml
kubectl rollout restart deployment coredns -n kube-system
kubectl rollout status deployment coredns -n kube-system
kubectl get configmap coredns-custom -n kube-system -o yaml
kubectl delete configmap coredns-custom -n kube-system
kubectl rollout restart deployment coredns -n kube-system
kubectl rollout status deployment coredns -n kube-system
```

## Kubernetes communication
``` bash
kubectl port-forward service/k8sbook 8080:80 -n kubernetes-book
kubectl get pods -n kubernetes-book
kubectl port-forward pod/git-sync 8080:80 -n kubernetes-book
kubectl port-forward deployment/simple-api 8080:8080 -n kubernetes-book
sudo ufw allow 8080/tcp
kubectl port-forward service/k8sbook 8080:80 --address=0.0.0.0 -n kubernetes-book
kubectl get pod -n kubernetes-book -o wide
kubectl exec -it hello-pod -n kubernetes-book -- curl http://10.42.0.116:80
kubectl apply -f ./personal/nodeport-svc.yaml -n kubernetes-book
kubectl get nodes -o wide
kubectl apply -f ./personal/loadbalancer-svc.yaml -n kubernetes-book
kubectl get service -n kubernetes-book
kubectl proxy --port=8080
curl http://localhost:8080/api/v1/namespaces/kubernetes-book/services/http:k8sbook:80/proxy/
curl http://localhost:8080/api/v1/namespaces/kubernetes-book/services/k8sbook
kubectl delete -f ./personal/nodeport-svc.yaml -f ./personal/loadbalancer-svc.yaml -n kubernetes-book
```