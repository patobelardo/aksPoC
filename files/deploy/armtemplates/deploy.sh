VNETRGNAME=aks-poc-test2
RGNAME=aks-poc-test2-aks
NODESRGName=aks-poc-test2-newaks2
LOCATION=eastus

az group create -n $RGNAME -l $LOCATION

az group deployment create -n aks-deploy1 -g $VNETRGNAME --template-file vnet-existing.json --parameters @vnet-existing.parameters.json

sed "s/##rgName##/$VNETRGNAME/g" aks-cluster.parameters.json > aks-cluster.parameters.temp.json
sed "s/##nodesRGName##/$NODESRGName/g" aks-cluster.parameters.temp.json > aks-cluster.parameters.temp1.json

az group deployment create -n aks-deploy-cluster1 -g $RGNAME --template-file aks-cluster.json --parameters @aks-cluster.parameters.temp1.json

rm aks-cluster.parameters.temp*.json