# Book Commands

## Hands-on with ConfigMaps

### Creating ConfigMaps imperatively
```bash
kubectl create configmap testmap1 --from-literal shortname=SAFC --from-literal longname="Sunderland Association Football Club" -n kubernetes-book
kubectl describe cm testmap1 -n kubernetes-book
kubectl create configmap testmap2 --from-file cmfile.txt -n kubernetes-book
```

### Inspecting ConfigMaps
```bash
kubectl get cm -n kubernetes-book
kubectl describe cm testmap2 -n kubernetes-book
kubectl get cm testmap2 -o yaml -n kubernetes-book
```

### Creating ConfigMap declaratively
```bash
kubectl apply -f fullname.yaml -n kubernetes-book
kubectl describe cm multimap -n kubernetes-book
kubectl apply -f singlemap.yaml -n kubernetes-book
kubectl describe cm test-config -n kubernetes-book
```

### Injecting ConfigMap data into Pods and containers
```bash
# ConfigMaps and environment variables
kubectl apply -f podenv.yaml -n kubernetes-book
kubectl exec envpod -n kubernetes-book -- env | grep NAME

# ConfigMaps and container startup commands
kubectl apply -f podstartup.yaml -n kubernetes-book
kubectl logs startup-pod -n kubernetes-book
kubectl describe pod startup-pod -n kubernetes-book
kubectl delete pod startup-pod -n kubernetes-book

# ConfigMaps and volumes
kubectl apply -f podvol.yaml -n kubernetes-book
kubectl exec cmvol -n kubernetes-book -- ls /etc/name
kubectl exec cmvol -n kubernetes-book -- cat /etc/name/firstname
kubectl exec cmvol -n kubernetes-book -- cat /etc/name/lastname
kubectl apply -f fullname-v2.yaml -n kubernetes-book
kubectl describe cm multimap -n kubernetes-book
kubectl exec cmvol -n kubernetes-book -- ls /etc/name
kubectl exec cmvol -n kubernetes-book -- cat /etc/name/city
kubectl exec cmvol -n kubernetes-book -- cat /etc/name/country
# A container using a ConfigMap as a subPath volume mount will not receive updates when the ConfigMap changes.
# https://kubernetes.io/docs/concepts/storage/volumes/#configmap
```

## Hands-on with Secrets

### Creating Secrets
```bash
kubectl create secret generic creds --from-literal user=nigelpoulton --from-literal pwd=Password123 -n kubernetes-book
kubectl get secret creds -o yaml -n kubernetes-book
# echo UGFzc3dvcmQxMjM= | base64 -d
kubectl apply -f tkb-secret.yaml -n kubernetes-book
kubectl get secret tkb-secret -n kubernetes-book
kubectl describe secret tkb-secret -n kubernetes-book
```

### Using Secrets in Pods
```bash
kubectl apply -f secretpod.yaml -n kubernetes-book
kubectl exec secret-pod -n kubernetes-book -- ls /etc/tkb
kubectl exec secret-pod -n kubernetes-book -- cat /etc/tkb/username
kubectl exec secret-pod -n kubernetes-book -- cat /etc/tkb/password
```

## Clean up
```bash
kubectl get pods -n kubernetes-book
kubectl get cm -n kubernetes-book
kubectl get secrets -n kubernetes-book
kubectl delete pods cmvol envpod secret-pod -n kubernetes-book
kubectl delete cm multimap test-config testmap1 testmap2 -n kubernetes-book
kubectl delete secrets creds tkb-secret -n kubernetes-book
```