resource "azurerm_resource_group" "poc" {
  name     = "${var.prefix}-aks-cluster"
  location = "${var.location}"
}

/*
resource "azurerm_route_table" "poc" {
  name                = "${var.prefix}-routetable"
  location            = "${azurerm_resource_group.poc.location}"
  resource_group_name = "${azurerm_resource_group.poc.name}"

  route {
    name                   = "default"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
}
*/

resource "azurerm_virtual_network" "poc" {
  name                = "${var.prefix}-vnet"
  location            = "${azurerm_resource_group.poc.location}"
  resource_group_name = "${azurerm_resource_group.poc.name}"
  address_space       = ["${var.vnet.address_space}"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "${var.vnet.subnet1_name}"
  resource_group_name  = "${azurerm_resource_group.poc.name}"
  address_prefix       = "${var.vnet.subnet1_cidr}"
  virtual_network_name = "${azurerm_virtual_network.poc.name}"
  depends_on           = ["azurerm_virtual_network.poc"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "${var.vnet.subnet2_name}"
  resource_group_name  = "${azurerm_resource_group.poc.name}"
  address_prefix       = "${var.vnet.subnet2_cidr}"
  virtual_network_name = "${azurerm_virtual_network.poc.name}"
  depends_on           = ["azurerm_virtual_network.poc"]
}


/*resource "azurerm_subnet_route_table_association" "poc" {
  subnet_id      = "${azurerm_subnet.poc.id}"
  route_table_id = "${azurerm_route_table.poc.id}"
}
*/
resource "azurerm_kubernetes_cluster" "poc" {
  name                = "${var.prefix}-cluster"
  location            = "${azurerm_resource_group.poc.location}"
  dns_prefix          = "${var.prefix}-cluster"
  resource_group_name = "${azurerm_resource_group.poc.name}"
  node_resource_group = "${azurerm_resource_group.poc.name}-nodes"

  linux_profile {
    admin_username = "acctestuser1"

    ssh_key {
      key_data = "${var.public_ssh_key}"
    }
  }

  default_node_pool {
      name                = element(var.agent_pools, 0).name
      vm_size             = element(var.agent_pools, 0).vm_size
      #os_type             = element(var.agent_pools, 0).os_type
      os_disk_size_gb     = element(var.agent_pools, 0).os_disk_size_gb
      type                = "VirtualMachineScaleSets"
      availability_zones  = element(var.agent_pools, 0).availability_zones
      enable_auto_scaling = element(var.agent_pools, 0).enable_auto_scaling
      min_count           = element(var.agent_pools, 0).min_count
      max_count           = element(var.agent_pools, 0).max_count
      max_pods            = element(var.agent_pools, 0).max_pods

      # Required for advanced networking
      vnet_subnet_id = "${azurerm_subnet.subnet1.id}"
  }

/*
 agent_pool_profile {
      name                = element(var.agent_pools, 1).name
      vm_size             = element(var.agent_pools, 1).vm_size
      os_type             = element(var.agent_pools, 1).os_type
      os_disk_size_gb     = element(var.agent_pools, 1).os_disk_size_gb
      availability_zones  = element(var.agent_pools, 1).availability_zones
      enable_auto_scaling = element(var.agent_pools, 1).enable_auto_scaling
      min_count           = element(var.agent_pools, 1).min_count
      max_count           = element(var.agent_pools, 1).max_count
      max_pods            = element(var.agent_pools, 1).max_pods

      # Required for advanced networking
      vnet_subnet_id = "${azurerm_subnet.subnet2.id}"
  }
*/
  service_principal {
    client_id     = "${var.kubernetes_client_id}"
    client_secret = "${var.kubernetes_client_secret}"
  }

  network_profile {
    network_plugin    = "azure"
    # Required for availability zones
    load_balancer_sku = "standard"
  }
}

  resource "azurerm_kubernetes_cluster_node_pool" "poc" {
    count = var.include_windows ? 1 : 0
  #  name                  = "internal"
    kubernetes_cluster_id = azurerm_kubernetes_cluster.poc.id
  #  vm_size               = "Standard_DS2_v2"
  #  node_count            = 1

    name                = element(var.agent_pools, 1).name
    vm_size             = element(var.agent_pools, 1).vm_size
    os_type             = element(var.agent_pools, 1).os_type
    os_disk_size_gb     = element(var.agent_pools, 1).os_disk_size_gb
    availability_zones  = element(var.agent_pools, 1).availability_zones
    enable_auto_scaling = element(var.agent_pools, 1).enable_auto_scaling
    min_count           = element(var.agent_pools, 1).min_count
    max_count           = element(var.agent_pools, 1).max_count
    max_pods            = element(var.agent_pools, 1).max_pods

    # Required for advanced networking
    vnet_subnet_id = "${azurerm_subnet.subnet2.id}"

  }
