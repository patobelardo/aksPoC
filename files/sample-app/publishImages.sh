docker tag webapi:latest acrpocpb.azurecr.io/webapi:latest
docker tag frontend:latest acrpocpb.azurecr.io/frontend:latest


docker push acrpocpb.azurecr.io/webapi:latest
docker push acrpocpb.azurecr.io/frontend:latest
