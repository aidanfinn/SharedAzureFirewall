////////////////
// Parameters //
////////////////

// Name of the ingress route to add to the hub GatewaySubnet for the workload
param workloadGatewaySubnetRouteName string

// Ingress route to add to the hub GatewaySubnet for the workload
param workloadGatewaySubnetRoute object


///////////////
// Resources //
///////////////

// Workload route in Hub GatewaySubnet Route Table //

resource route 'Microsoft.Network/routeTables/routes@2021-03-01' = {
  name: workloadGatewaySubnetRouteName
  properties: workloadGatewaySubnetRoute
}
