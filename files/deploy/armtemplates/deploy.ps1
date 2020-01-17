PARAM(
    $rgName = "aks-poc-test", 
    $location = "eastus"
)
az group create -n $rgName -l $location

az group deployment create -n aks-deploy -g $rgName --template-file vnet.json  --parameters '@vnet.parameters.json'

az group deployment create -n aks-deploy-cluster -g $rgName --template-file aks-cluster.json --parameter @aks-cluster.parameters.json
