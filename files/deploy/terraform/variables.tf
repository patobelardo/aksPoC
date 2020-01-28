variable "prefix" {
  description = "A prefix used for all resources in this poc"
}

variable "location" {
  description = "The Azure Region in which all resources in this poc should be provisioned"
}

variable "vnet" {
  description = "vnet configuration"
  type = object({
    address_space = string
    subnet1_cidr = string
    subnet1_name = string
    subnet2_cidr = string
    subnet2_name = string 
  })

  default = {
      address_space = "172.16.0.0/17"
      subnet1_cidr = "172.16.0.0/20"
      subnet1_name = "aks-linux"
      subnet2_cidr = "172.16.32.0/20"
      subnet2_name = "aks-windows" 
    }
}
variable "kubernetes_client_id" {
  description = "The Client ID for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "kubernetes_client_secret" {
  description = "The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "public_ssh_key" {
  description = "The Path at which your Public SSH Key is located. Defaults to ~/.ssh/id_rsa.pub"
  default     = ""
}

variable "include_windows" {
  description = "If set to true, it will create a windows agent pool"
  type        = bool
  default     = false
}

variable "agent_pools" {
  description = "(Optional) List of agent_pools profile for multiple node pools"
  type = list(object({
    name                = string
    vm_size             = string
    os_type             = string
    os_disk_size_gb     = number
    max_pods            = number
    availability_zones  = list(number)
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
  }))
  
  default = [{
    name                = "pool1"
    vm_size             = "Standard_D2s_v3"
    os_type             = "Linux"
    os_disk_size_gb     = 30
    max_pods            = 45
    availability_zones  = [1, 2, 3]
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
  },
  {
    name                = "pool2"
    vm_size             = "Standard_D2s_v3"
    os_type             = "Windows"
    os_disk_size_gb     = 30
    max_pods            = 45
    availability_zones  = [1, 2, 3]
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
}]
}