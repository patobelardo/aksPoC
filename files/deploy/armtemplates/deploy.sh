RGNAME=aks-poc-test
LOCATION=eastus

az group create -n $RGNAME -l $LOCATION

az group deployment create -n aks-deploy -g $RGNAME --template-file vnet.json 

az group deployment create -n aks-deploy-cluster -g $RGNAME --template-file aks-cluster.json --parameters @aks-cluster.parameters.json
