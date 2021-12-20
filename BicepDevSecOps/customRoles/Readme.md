The following roles are defined to grants the workload (spoke) pipeline SPN rights in the hub:

- **CUSTOM - ARM Deployment Operator**: Update/check ARM deployments. This right is granted at the hub network's resource group.
- **CUSTOM - Virtual Network Peering Administrator**: Create a peering connection with the hub virtual network. This right is granted at the hub virtual network.
- **CUSTOM - Azure Route Table Routes Administrator**: Add a route to the GatewaySubnet RouteTable. This right is granted at the GatewaySubnet Route Table.
- **CUSTOM - Azure Firewall Policy Rule Collection Group Administrator**: Create an Azure Firewall Policy Rules Collection Group for the workload. This right is granted at the Azure Firewall Policy that is assigned to the hub Azure Firewall.