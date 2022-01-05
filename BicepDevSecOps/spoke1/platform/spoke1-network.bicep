////////////////
// Parameters //
////////////////

// Address prefix for virtualNetwork
param virtualNetworkAddressPrefixes array

// Address prefix for virtualNetwork - FrontendSubnet
param virtualFrontendSubnetAddressPrefix string

// NSG rules for virtualNetwork - FrontendSubnet
param virtualFrontendSubnetNsgRules array

// Route Table rules for virtualNetwork - FrontendSubnet
param virtualFrontendSubnetRoutes array

// Resource ID of the hub Virtual Network
param hubVirtualNetworkId string


///////////////
// Resources //
///////////////

// Workload Virtual Network //

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'spoke1-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: virtualNetworkAddressPrefixes
    }
    subnets: [
      {
        name: 'FrontendSubnet'
        properties: {
          addressPrefix: virtualFrontendSubnetAddressPrefix
          routeTable: {
            id: '${frontendSubnetRouteTable.id}'
          }
          networkSecurityGroup: {
            id: '${frontendSubnetNsg.id}'
          }
        }
      }
    ]
  }
}


resource frontendSubnetRouteTable 'Microsoft.Network/routeTables@2019-11-01' = {
  name: 'spoke1-vnet-frontendsubnet-rt'
  location: resourceGroup().location
  properties: {
    disableBgpRoutePropagation: true
    routes: virtualFrontendSubnetRoutes
  }
}


resource frontendSubnetNsg 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'spoke1-vnet-frontendsubnet-nsg'
  location: resourceGroup().location
  properties: {
    securityRules: virtualFrontendSubnetNsgRules
  }
}


resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: 'spoke1-vnet/hub-vnet'
  dependsOn: [
    virtualNetwork
  ]
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: true
    remoteVirtualNetwork: {
      id: hubVirtualNetworkId
    }
  }
}

