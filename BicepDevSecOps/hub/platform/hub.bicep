////////////////
// Parameters //
////////////////

// Address prefix for virtualNetwork
param virtualNetworkAddressPrefixes array

// Address prefix for virtualNetwork - GatewaySubnet
param virtualNetworkGatewaySubnetAddressPrefix string

// Address prefix for virtualNetwork - AzureFirewallSubnet
param virtualNetworkAzureFirewallSubnetAddressPrefix string

// Address prefix for virtualNetwork - AzureBastionSubnet
param virtualNetworkAzureBastionSubnetAddressPrefix string

// Properties of Azure Firewall Policy
param firewallPolicyProperties object

// Properties of Global Rule Collection Group
param globalRulesCollectionProperties object


////////////////
// Resources //
////////////////

// Hub Virtual Network //

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'hub-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: virtualNetworkAddressPrefixes
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: virtualNetworkGatewaySubnetAddressPrefix
          routeTable: {
            id: '${gatewaySubnetRouteTable.id}'
          }
        }
      }
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: virtualNetworkAzureFirewallSubnetAddressPrefix
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: virtualNetworkAzureBastionSubnetAddressPrefix
        }
      }
    ]
  }
}


// GatwaySubnet Route Table //

resource gatewaySubnetRouteTable 'Microsoft.Network/routeTables@2019-11-01' = {
  name: 'hub-vnet-gatewaysubnet-rt'
  location: resourceGroup().location
  properties: {
    disableBgpRoutePropagation: false
  }
}


// VNet VPN Gatway PIP //

resource virtualNetworkGatewayPip 'Microsoft.Network/publicIPAddresses@2020-03-01' = {
  name: 'hub-vpn-pip001'
  location: resourceGroup().location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
  sku: {
    name: 'Basic'
  }
}


// VNet VPN Gateway //

resource vpnVirtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2020-11-01' = {
  name: 'hub-vpn'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'hub-vpn-pip001'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${virtualNetwork.id}/subnets/GatewaySubnet'
          }
          publicIPAddress: {
            id: '${virtualNetworkGatewayPip.id}'
          }
        }
      }
    ]
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: true
  }
}


// Azure Firewall PIP //

resource firewallPip 'Microsoft.Network/publicIPAddresses@2020-03-01' = {
  name: 'hub-afw-pip001'
  location: resourceGroup().location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
}


// Azure Firewall Policy //

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2021-03-01' = {
  name: 'hub-fw-afwp'
  location: resourceGroup().location
  properties: firewallPolicyProperties
}


// Azure Firewall //

resource firewall 'Microsoft.Network/azureFirewalls@2020-11-01' = {
  name: 'hub-afw'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'hub-fw-pip001'
        properties: {
          subnet: {
            id: '${virtualNetwork.id}/subnets/AzureFirewallSubnet'
          }
          publicIPAddress: {
            id: '${firewallPip.id}'
          }
        }
      }
    ]
    firewallPolicy: {
      id: '${firewallPolicy.id}'
    }
  }
}


// Global Rule Collection Group //

resource globalRulesCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-03-01' = {
  name: '${firewallPolicy.name}/global'
  properties: globalRulesCollectionProperties
}


/////////////
// Outputs //
/////////////

// Hub VNet ID
output virtualNetworkId string = virtualNetwork.id

// Firewall Private IP
output firewallPrivateIp string = firewall.properties.ipConfigurations[0].properties.privateIPAddress
