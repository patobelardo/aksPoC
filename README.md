# AKS PoC for Sleep Number

Features to include

Week 1

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

Week 2

  - Setting  RBAC roles with AAD (k8 roles binding with aad groups)		
  - Network Policies for namespaces
    - Restricting access between namespaces
  - Key Store
    - Using azure vault or hashicorp vault
- Integrating ACR with AKS
  - Deploying images stored in azure container registry

Week 3

 - Private IP Ingress/Egress endpoints for applications. 
 - Securing AKS management API’s to datacenter IP’s 
    - Whitelisting 
    - Using azure arc for centralize config management. 
 

Week 4
- General Monitoring.
