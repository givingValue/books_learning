# Book Commands

## The API server
```bash
kubectl cluster-info
```

### Hands-on
```bash
kubectl proxy --port 9000 &
curl -X GET http://localhost:9000/api/v1/namespaces/shield/pods
curl -X GET http://localhost:9000/api/v1/namespaces
curl -v -X GET http://localhost:9000/api/v1/namespaces/shield/pods
```

### A word on CRUD
```bash
curl -X POST -H "Content-Type: application/json" \
    --data-binary @ns.json http://localhost:9000/api/v1/namespaces
kubectl get ns
curl -X DELETE -H "Content-Type: application/json" \
    http://localhost:9000/api/v1/namespaces/shield
```

## The API

### The core API group
```bash
kubectl api-resources --api-group=""
```

### Inspecting the API
```bash
kubectl api-resources
kubectl api-versions
for kind in `kubectl api-resources | tail +2 | awk '{ print $1 }'`; \
    do kubectl explain $kind; done | grep -e "KIND:" -e "VERSION:"
curl http://localhost:9000/api
curl http://localhost:9000/apis
curl http://localhost:9000/api/v1/namespaces
```

### Extending the API
```bash
kubectl apply -f crd.yaml
curl http://localhost:9000/apis/nigelpoulton.com/v1
curl http://localhost:9000/apis/nigelpoulton.com/v1/books
kubectl api-resources | grep books
kubectl explain book
kubectl apply -f book.yaml
kubectl get bk
curl http://localhost:9000/apis/nigelpoulton.com/v1/books/ai
```

## Clean up
```bash
ps | grep kubectl
kill -9 3728720
kubectl delete book ai
kubectl delete crd books.nigelpoulton.com
```