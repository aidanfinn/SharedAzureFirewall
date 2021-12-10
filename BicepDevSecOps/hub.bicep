resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'hub-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/22'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          routeTable: {
            id: '${gatewaySubnetRouteTable.id}'
          }
        }
      }
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.3.0/24'
        }
      }
    ]
  }
}

resource gatewaySubnetRouteTable 'Microsoft.Network/routeTables@2019-11-01' = {
  name: 'hub-vnet-gatewaysubnet-rt'
  location: resourceGroup().location
  properties: {
    disableBgpRoutePropagation: false
  }
}

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

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2021-03-01' = {
  name: 'hub-fw-afwp'
  location: resourceGroup().location
  properties: {
    threatIntelMode: 'Deny'
    dnsSettings: {
      enableProxy: true
    }
  }
}

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

resource globalRulesCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-03-01' = {
  name: '${firewallPolicy.name}/global'
  properties: {
    priority: 100
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'Allow-Network-Rules'
        priority: 400
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Azure-KMS-Service'
            description: 'Allow traffic from all Address Spaces to Azure platform KMS Service'
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '1688'
            ]
            destinationIpGroups: []
            destinationAddresses: []
            destinationFqdns: [
              'kms.core.windows.net'
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'Allow-Application-Rules'
        priority: 600
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'Http'
            description: 'Allow traffic from all sources to Azure platform KMS Service'
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            protocols: [
              {
                protocolType: 'Http'
                port: 80
              }
            ]
            targetFqdns: []
            fqdnTags: [
              'WindowsUpdate'
            ]
          }
          {
            ruleType: 'ApplicationRule'
            name: 'Https'
            description: 'Allow traffic from all sources to Azure platform KMS Service'
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            targetFqdns: []
            fqdnTags: [
              'WindowsUpdate'
            ]
          }
        ]
      }
    ]
  }
}
