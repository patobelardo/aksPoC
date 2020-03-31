# AKS PoC for Sleep Number

Features to include

[Step 1](files/step1.md)

- Deployment
  - ARM Template
  - Terraform
- Deploy AKS with the following requirements:
  - Deploying AKS within our ACF.   
  
    >ACF have azure polices that prevent the following network types from being created. (public ip’s, vnet’s, etc)

	- Automation with ARM and terraform   
	- Azure CNI networking.
    - Multiple cluster deployment with same subnet    
    - Autoscaling
  - Persistent storage for AKS and pods
  - Windows containers within the same cluster	 

[Step 2](files/step2.md)

  - AAD Integration - Setting  RBAC roles with AAD (k8 roles binding with aad groups)
  - Dashboard Overview		
  - Integrating ACR with AKS
  - Sample App
    - Deploying images stored in azure container registry
  - Persistent Storage (from Step 1)

[Step 3](files/step3.md)

 - Network Policies for namespaces
    - Restricting access between namespaces
 - Key Store
    - Using azure vault or hashicorp vault
 - Private IP Ingress/Egress endpoints for applications. 
 - Securing AKS management API’s to datacenter IP’s 
    - Whitelisting 

 

Step 4
- General Monitoring Overview (demo)
- Azure Devops Pipelines (demo)
- Using azure arc for centralize config management. ([overview](https://azure.microsoft.com/en-us/services/azure-arc/))
- Overview of Private Cluster (https://docs.microsoft.com/en-us/azure/aks/private-clusters)