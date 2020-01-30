PARAM(
    $rgName = "aks-poc-test", 
    $nodesRGName = "aks-poc-test-nodes",
    $location = "eastus"
)
az group create -n $rgName -l $location

az group deployment create -n aks-deploy -g $rgName --template-file vnet.json  --parameters '@vnet.parameters.json'

(Get-Content ./aks-cluster.parameters.json) -replace "##rgName##", $rgName > aks-cluster.parameters.tempps.json
(Get-Content ./aks-cluster.parameters.tempps.json) -replace "##nodesRGName##", $nodesRGName > aks-cluster.parameters.tempps.json


az group deployment create -n aks-deploy-cluster -g $rgName --template-file aks-cluster.json --parameter '@aks-cluster.parameters.tempps.json'

Remove-Item aks-cluster.parameters.tempps.json
