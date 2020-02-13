RGNAME=aks-poc-test
NODESRGName=aks-poc-test-nodes
LOCATION=eastus

az group create -n $RGNAME -l $LOCATION

az group deployment create -n aks-deploy -g $RGNAME --template-file vnet.json --parameters @vnet.parameters.json

sed "s/##rgName##/$RGNAME/g" aks-cluster-step2.parameters.json > aks-cluster-step2.parameters.temp.json
sed "s/##nodesRGName##/$NODESRGName/g" aks-cluster-step2.parameters.temp.json > aks-cluster-step2.parameters.temp1.json

az group deployment create -n aks-deploy-cluster -g $RGNAME --template-file aks-cluster-step2.json --parameters @aks-cluster-step2.parameters.temp1.json

rm aks-cluster-step2.parameters.temp*.json