helm delete --purge common-ingress 
helm install stable/nginx-ingress -n common-ingress --namespace ingress-basic  -f internal-ingress.yaml  --set controller.replicaCount=2 --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux  --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux
