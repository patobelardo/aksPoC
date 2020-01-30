RGNAME=aks-poc-test2
NODESRGName=nodes-newaks2
LOCATION=eastus

az group create -n $RGNAME -l $LOCATION

az group deployment create -n aks-deploy -g $RGNAME --template-file vnet.json --parameters @vnet.parameters.json

sed "s/##rgName##/$RGNAME/g" aks-cluster.parameters.json > aks-cluster.parameters.temp.json
sed "s/##nodesRGName##/$NODESRGName/g" aks-cluster.parameters.temp.json > aks-cluster.parameters.temp1.json

az group deployment create -n aks-deploy-cluster -g $RGNAME --template-file aks-cluster.json --parameters @aks-cluster.parameters.temp1.json

#rm aks-cluster.parameters.temp*.json