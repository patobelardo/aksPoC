VNETRGNAME=aks-poc-test2
RGNAME=aks-poc3
NODESRGName=aks-poc3-nodes
LOCATION=eastus

az group create -n $RGNAME -l $LOCATION

az group deployment create -n aks-deploy1 -g $VNETRGNAME --template-file vnet-existing.json --parameters @vnet-existing.parameters.json

sed "s/##rgName##/$VNETRGNAME/g" aks-cluster-step2.parameters.json > aks-cluster-step2.parameters.temp.json
sed "s/##nodesRGName##/$NODESRGName/g" aks-cluster-step2.parameters.temp.json > aks-cluster-step2.parameters.temp1.json

az group deployment create -n aks-deploy-cluster -g $RGNAME --template-file aks-cluster-step2.json --parameters @aks-cluster-step2.parameters.temp1.json

rm aks-cluster-step2.parameters.temp*.json