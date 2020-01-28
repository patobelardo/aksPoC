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

Keep the appID and password(secret). It will be used as parameter in the parameters file.

### Parameters File

- Get the sample files from [here](deploy/armtemplates/) and create a copy with the name *aks-cluster.parameters.json* and *vnet.parameters.json*
- Change values based on your preferences. Here are some comments:
  - Use previous saved values for aksServicePrincipalAppId and aksServicePrincipalClientSecret
  - sshRSAPublicKey: we are using a sample rsa file for this sample, but one per environment should be created. Reference: [https://www.ssh.com/ssh/putty/windows/puttygen]
  - aksDnsPrefix: should be unique or you will receive an error during the deployment/validation
  - aksServiceCIDR: Address space for services inside the cluster (Cluster IPs)
  - aksDnsServiceIP: IP Address for the DNS Service. Should be inside the ServiceCIDR 
  - aksDockerBridgeCIDR: Docker Bridge CIDR. Internal address space for pods (not used with CNI = networkPlugin:azure)
  - windowsPool: boolean to determine if an Windows agent pool will be included. If false: only linux agent pool will be created. 
  - vmssMaxInstances: For autoscaling purposes


````powershell
./deploy.ps1 -rgName <ResourceGroupName> -location <location>
````
