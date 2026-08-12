# Book Commands

## Elevation of privilege

### PSA examples
```bash
kubectl create ns psa-test
kubectl label --overwrite ns psa-test pod-security.kubernetes.io/enforce=baseline
kubectl describe ns psa-test
kubectl apply -f psa-pod.yaml
kubectl apply -f psa-pod-baseline.yaml
kubectl label --dry-run=server --overwrite ns psa-test pod-security.kubernetes.io/enforce=restricted
kubectl label --overwrite ns psa-test pod-security.kubernetes.io/enforce=restricted
kubectl get pods --namespace psa-test
kubectl apply -f psa-pod-restricted.yaml
kubectl get pods --namespace psa-test
kubectl label --overwrite ns psa-test \
    pod-security.kubernetes.io/enforce=baseline \
    pod-security.kubernetes.io/warn=restricted \
    pod-security.kubernetes.io/audit=restricted
kubectl describe ns psa-test
kubectl delete -f psa-pod-baseline.yaml
kubectl apply -f psa-pod-baseline.yaml
```

## Clean up
```bash
kubectl delete ns psa-test
```