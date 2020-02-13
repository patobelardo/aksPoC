# AKS PoC - Step 2


  - Setting  RBAC roles with AAD (k8 roles binding with aad groups)
  - Dashboard Overview		
  - Network Policies for namespaces
    - Restricting access between namespaces
  - Key Store
    - Using azure vault or hashicorp vault
- Integrating ACR with AKS
  - Deploying images stored in azure container registry

## AAD Integration

### Creation of AAD Application

Follow the steps described [here](https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration), until "Deploy the AKS cluster"

### ARM Template changes

To deploy an Azure AD integrated cluster, you need to redeploy. 
To have this in place, we will create a copy of the aks-cluster file. In this case will be called [aks-cluster-step2.json](deploy/armtemplates/aks-cluster-step2.json)


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

## Deployment - ARM

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

> For Windows Agent nodes you should enable the preview features mentioned [here](https://aka.ms/aks/previews). Add aks-preview and ContainerServices features.

````powershell
./deploy.ps1 -rgName <ResourceGroupName> -location <location>
````

### Persistent Storage

Reference: [Persistent Storage - AKS](https://docs.microsoft.com/en-us/azure/aks/azure-disks-dynamic-pv)


### How to connect to the cluster

Once is created you will be able to list the cluster

````bash
az login
az aks list -o table
````

You should see an output as here

````bash
Name      Location    ResourceGroup     KubernetesVersion    ProvisioningState    Fqdn
--------  ----------  ----------------  -------------------  -------------------  --------------------------------------
akspocpb  eastus      aks-poc-test      1.15.7               Succeeded            akspocpb-f479139e.hcp.eastus.azmk8s.io
````
To install kubectl cli
````bash
az aks install-cli
````
After that, you can get credentials, to be used by kubectl
````bash
az aks get-credentials -n clustername -g groupname
````

After that, you will be able to connect to your cluster and get the information as shown here:
````bash
kubectl get nodes

NAME                                STATUS   ROLES   AGE   VERSION
aks-agentpool-27322822-vmss000000   Ready    agent   23m   v1.15.7
akswpool000000                      Ready    agent   15m   v1.15.7
````

## Template - Terraform

For terraform, we created the following files:
- [aks-cluster.tf](deploy/terraform/aks-cluster.tf)
- [variables.tf](deploy/terraform/variables.tf)

## Deployment - Terraform

We can create a file with variable values (parameters). For example: variables.tfvars

````terraform
prefix = "yourprefix"
location = "eastus"
kubernetes_client_id = "servicePrincipalID"
kubernetes_client_secret = "servicePrincipalSecret"
public_ssh_key = "ssh-rsa ......."
include_windows = true
````
> include_windows will help to choose 1 Linux Agent Pool option or 1 Linux + 1 Windows agent pools

Note: Other variable values can be included here.

For the execution, you should include the -var-file parameter:

````bash
terraform apply -var-file="variables.tfvars"
````
