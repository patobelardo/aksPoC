resource "azurerm_resource_group" "poc" {
  name     = "${var.prefix}-anw-resources"
  location = "${var.location}"
}

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

resource "azurerm_virtual_network" "poc" {
  name                = "${var.prefix}-network"
  location            = "${azurerm_resource_group.poc.location}"
  resource_group_name = "${azurerm_resource_group.poc.name}"
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "poc" {
  name                 = "internal"
  resource_group_name  = "${azurerm_resource_group.poc.name}"
  address_prefix       = "10.1.0.0/24"
  virtual_network_name = "${azurerm_virtual_network.poc.name}"

  # this field is deprecated and will be removed in 2.0 - but is required until then
  route_table_id = "${azurerm_route_table.poc.id}"
}

resource "azurerm_subnet_route_table_association" "poc" {
  subnet_id      = "${azurerm_subnet.poc.id}"
  route_table_id = "${azurerm_route_table.poc.id}"
}

resource "azurerm_kubernetes_cluster" "poc" {
  name                = "${var.prefix}-anw"
  location            = "${azurerm_resource_group.poc.location}"
  dns_prefix          = "${var.prefix}-anw"
  resource_group_name = "${azurerm_resource_group.poc.name}"

  linux_profile {
    admin_username = "acctestuser1"

    ssh_key {
      key_data = "${file(var.public_ssh_key_path)}"
    }
  }

  dynamic "agent_pool_profile" {
    for_each = var.agent_pools
    content {
      name                = agent_pool_profile.value.name
      count               = agent_pool_profile.value.count
      vm_size             = agent_pool_profile.value.vm_size
      os_type             = agent_pool_profile.value.os_type
      os_disk_size_gb     = agent_pool_profile.value.os_disk_size_gb
      type                = "VirtualMachineScaleSets"
      availability_zones  = agent_pool_profile.value.availability_zones
      enable_auto_scaling = agent_pool_profile.value.enable_auto_scaling
      min_count           = agent_pool_profile.value.min_count
      max_count           = agent_pool_profile.value.max_count
      max_pods            = agent_pool_profile.value.max_pods

      # Required for advanced networking
      vnet_subnet_id = "${azurerm_subnet.poc.id}"
    }
  }

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