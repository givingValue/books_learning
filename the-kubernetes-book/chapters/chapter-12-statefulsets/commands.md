# Book Commands

## Hands-on with StatefulSets

### Deploy the StorageClass
```bash
kubectl get sc
```

### Create a governing headless Service
```bash
kubectl apply -f headless-svc.yaml -n kubernetes-book
kubectl get svc -n kubernetes-book
kubectl describe svc dullahan -n kubernetes-book
```

### Deploy the StatefulSet
```bash
kubectl apply -f sts.yaml -n kubernetes-book
kubectl get sts --watch -n kubernetes-book
kubectl get pvc -n kubernetes-book
```

### Testing peer discovery
```bash
kubectl apply -f jump-pod.yaml -n kubernetes-book
kubectl exec -it jump-pod -n kubernetes-book -- bash
# nslookup dullahan.kubernetes-book.svc.cluster.local
# nslookup tkb-sts-0.dullahan.kubernetes-book.svc.cluster.local
# nslookup tkb-sts-1.dullahan.kubernetes-book.svc.cluster.local
# nslookup tkb-sts-2.dullahan.kubernetes-book.svc.cluster.local
# nslookup -q=srv dullahan.kubernetes-book.svc.cluster.local
# nslookup -q=srv _web._tcp.dullahan.kubernetes-book.svc.cluster.local
# dig SRV dullahan.kubernetes-book.svc.cluster.local
# exit
```

### Scaling StatefulSets
```bash
kubectl scale sts tkb-sts --replicas 2 -n kubernetes-book
kubectl get pods -n kubernetes-book
kubectl get pvc -n kubernetes-book
kubectl describe pvc webroot-tkb-sts-0 -n kubernetes-book
kubectl describe pvc webroot-tkb-sts-2 -n kubernetes-book
kubectl scale sts tkb-sts --replicas 3 -n kubernetes-book
kubectl get sts tkb-sts -n kubernetes-book
kubectl get pods -n kubernetes-book
kubectl describe pvc webroot-tkb-sts-2 -n kubernetes-book
kubectl describe pod tkb-sts-2 -n kubernetes-book | grep ClaimName
```

### Rollouts
```bash
kubectl apply -f sts-v2.yaml -n kubernetes-book
kubectl rollout status sts tkb-sts -n kubernetes-book
kubectl describe sts tkb-sts -n kubernetes-book
kubectl get pods -n kubernetes-book -o wide
kubectl explain sts.spec.updateStrategy
```

### Test a Pod failure
```bash
kubectl get pods -n kubernetes-book
kubectl delete pod tkb-sts-0 -n kubernetes-book
kubectl get pods -n kubernetes-book --watch
kubectl describe pod tkb-sts-0 -n kubernetes-book | grep ClaimName
```

### Deleting StatefulSets
```bash
kubectl scale sts tkb-sts --replicas 0 -n kubernetes-book
kubectl get sts tkb-sts -n kubernetes-book
kubectl delete sts tkb-sts -n kubernetes-book
kubectl exec -it jump-pod -n kubernetes-book -- bash
# nslookup dullahan.kubernetes-book.svc.cluster.local
# nslookup tkb-sts-0.dullahan.kubernetes-book.svc.cluster.local
# nslookup -q=srv _web._tcp.dullahan.kubernetes-book.svc.cluster.local
# dig SRV dullahan.kubernetes-book.svc.cluster.local
# exit
```

### Clean up
```bash
kubectl delete pod jump-pod -n kubernetes-book
kubectl delete svc dullahan -n kubernetes-book
kubectl delete pvc webroot-tkb-sts-0 webroot-tkb-sts-1 webroot-tkb-sts-2 -n kubernetes-book
```