# Book Commands

## Dynamic provisioning with Storage Classes
```bash
kubectl api-resources --api-group=storage.k8s.io
```

## Hands-on

### Use an existing Storage Class
```bash
# This will be a mix between book and personal commands in order to follow the exercise
kubectl get sc
kubectl describe sc local-path
kubectl get pv
kubectl get pvc -A
kubectl apply -f local-sc-immediate.yaml
kubectl apply -f local-pvc-test.yaml -n kubernetes-book
kubectl get pvc -n kubernetes-book
kubectl describe pvc pvc-test -n kubernetes-book
kubectl get pv
kubectl delete pvc pvc-test -n kubernetes-book
kubectl get pvc -n kubernetes-book
kubectl get pv 
```

### Create and use a new StorageClass
```bash
# This will be a mix between book and personal commands in order to follow the exercise
kubectl apply -f local-sc-wait-keep.yaml
kubectl get sc
kubectl apply -f local-pvc-wait-keep.yaml -n kubernetes-book
kubectl get pvc -n kubernetes-book
kubectl get pv
kubectl apply -f app.yaml -n kubernetes-book
kubectl get pvc -n kubernetes-book
kubectl get pv
kubectl describe pod volpod -n kubernetes-book
kubectl exec pod/volpod -n kubernetes-book -- ls /
```

## Clean up
```bash
kubectl delete pod volpod -n kubernetes-book
kubectl delete pvc pvc-wait-keep -n kubernetes-book
kubectl delete pv pvc-e5171660-ec3b-4ca0-8e5b-822971079626
rm -rf pvc-e5171660-ec3b-4ca0-8e5b-822971079626_kubernetes-book_pvc-wait-keep
kubectl delete sc local-path-wffc-retain
```

# Personal Commands

## RWO Access mode
```bash
kubectl apply -f ./personal/pvc.yaml -f ./personal/postgres-deploy.yaml -f ./personal/busybox-deploy.yaml
kubectl get deployments -n kubernetes-book
kubectl get pods -n kubernetes-book
kubectl exec deployment/postgres-rwo -n kubernetes-book -- ls /var/lib/postgresql/data
kubectl exec deployment/busybox-rwo -n kubernetes-book -- ls /shared
# You will see the same files and folders in both responses 
# This happens because we are using the same PVC and therefore the same PV
# The mount paths are different, but they point to the same underlying filesystem
kubectl exec deployment/postgres-rwo -n kubernetes-book -- cat /var/lib/postgresql/data/busybox.txt
kubectl exec deployment/postgres-rwo -n kubernetes-book -- sh -c 'echo "Written by the PostgreSQL Pod" > /var/lib/postgresql/data/postgres.txt'
kubectl exec deployment/busybox-rwo -n kubernetes-book -- cat /shared/postgres.txt
kubectl delete -f ./personal/pvc.yaml -f ./personal/postgres-deploy.yaml -f ./personal/busybox-deploy.yaml
```