# AKS PoC - Step 1 - Deployment

## Template - ARM

For this deployment, we created an 2 templates:
- vnet.json
- aks-cluster.json

### [vnet.json](deploy/armtemplates/vnet.json)

This template includes 2 subnets and parameters to define the address space of each, and also the subnet names

### [aks-cluster.json](deploy/armtemplates/aks-cluster.json)

This template includes the following characteristics (as parameters):

- Linux and Windows agent pools (optional)
- Kubenet or CNI
- Existing VNET / Subnet parameters
- Autoscaling

## Deployment

### Service Principal Creation

To create a cluster, we should create a Service Principal to be used during the creation of Azure Resources, and also when some command at Kubernetes level, needs to access to Azure Resources (NSG or Load Balancer Rule, creation of VMs during autoscaling, etc).
To create this service principal we should execute this (you can reference [this](https://docs.microsoft.com/en-us/azure/aks/kubernetes-service-principal#manually-create-a-service-principal) article)

````bash
az ad sp create-for-rbac --skip-assignment --name <uniquename>
````

The output will show something like this

````json
{
  "appId": "559513bd-0c19-4c1a-87cd-xxxxxxxxx",
  "displayName": "uniquename",
  "name": "http://uniquename",
  "password": "e763725a-5eee-40e8-a466-yyyyyyyyy",
  "tenant": "72f988bf-86f1-41af-91ab-xxxxxxxxxx"
}
````

With this information, you should save the appID and password(secret) that will be used as parameter in the parameters file.


````powershell
./deploy.ps1 -rgName <ResourceGroupName> -location <location>
````
