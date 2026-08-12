# Book Commands

## The service registry
```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl get deploy -n kube-system -l k8s-app=kube-dns
kubectl get svc -n kube-system -l k8s-app=kube-dns
```

## Service discovery
```bash
kubectl apply -f ../chapter-07-kubernetes-services/deploy.yaml -n kubernetes-book
kubectl get pods -n kubernetes-book
kubectl exec svc-test-698c6b566f-4r59w -n kubernetes-book -- cat /etc/resolv.conf
kubectl get svc -n kube-system -l k8s-app=kube-dns
kubectl delete -f ../chapter-07-kubernetes-services/deploy.yaml -n kubernetes-book
```

## Service discovery and Namespaces
```bash
kubectl apply -f sd-example.yaml
kubectl get all --namespace dev
kubectl get all --namespace prod
kubectl exec -it jump --namespace dev -- bash
# cat /etc/resolv.conf
# apt-get update && apt-get install curl -y
# curl ent:8080
# curl ent.prod.svc.cluster.local:8080
# exit
```

## Troubleshooting service discovery
```bash
kubectl get deploy -n kube-system -l k8s-app=kube-dns
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl logs coredns-6776cbc4df-tndjl -n kube-system
kubectl get svc kube-dns -n kube-system
kubectl get endpointslice -n kube-system -l k8s-app=kube-dns
kubectl run -it dnsutils --image registry.k8s.io/e2e-test-images/jessie-dnsutils:1.7 -n kubernetes-book
# nslookup kubernetes
# nslookup kubernetes.default.svc.cluster.local
# exit
kubectl get svc kubernetes
kubectl delete pod -n kube-system -l k8s-app=kube-dns
kubectl get pods -n kube-system -l k8s-app=kube-dns
```

## Clean up
```bash
kubectl delete pod dnsutils -n kubernetes-book
kubectl delete -f sd-example.yaml
```
