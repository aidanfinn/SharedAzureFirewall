This set of files provides Bicep code to deploy a (legacy) hub and spoke (workload) architecture with Azure Firewall, managed through DevSecOps:

- **hub.bicep**: Deploys a VNet-based (or legacy) hub with a VPN gateway, gateway subnet route table, Azure Firewall, Azure Firewall (Manager) Policy, and a "global" rules collection group. This is stored in the hub repo and deployed via pipeline to the hub subscription/resource group.
- **spoke1-network.bicep**: Deploys the workload VNet (or spoke), including a route table, a route to 0.0.0.0/0 through the hub firewall, an NSG, and a peering connection to the hub. This is stored in the workload repo and deployed to the workload subscription/resource group.
- **spoke1-hubpeering.bicep**: Deploys the hub>spoke peering connection. This is stored in the workload repo and is deployed to the hub subscription/resource group.
- **spoke1-routing.bicep**: Deploys the route in the GatewaySubnet route table to force ingress traffic through the firewall. This is stored in the workload repo and is deployed to the hub subscription/resource group.
- **spoke1-hubfirewall**: Deploys a rules collection group to the hub Azure Firewall Policy. This is stored in the workload repo and is deployed to the hub subscription/resource group.
