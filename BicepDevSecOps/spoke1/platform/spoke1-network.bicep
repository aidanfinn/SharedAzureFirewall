resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'spoke1-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.8.0/25'
      ]
    }
    subnets: [
      {
        name: 'FrontendSubnet'
        properties: {
          addressPrefix: '10.0.8.0/27'
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
  }
}


resource route 'Microsoft.Network/routeTables/routes@2021-03-01' = {
  name: 'Everywhere'
  parent: frontendSubnetRouteTable
  properties: {
    addressPrefix: '0.0.0.0/0'
    nextHopIpAddress: '10.0.1.4'
    nextHopType: 'VirtualAppliance'
  }
}


resource frontendSubnetNsg 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'spoke1-vnet-frontendsubnet-nsg'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'AllowHttpsFromOnPrem'
        properties: {
          description: 'Allow HTTPS from an on-premises network'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '192.168.0.0/16'
          destinationAddressPrefix: '10.0.8.0/25'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
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
      id: '/subscriptions/de1b9349-a302-4b0f-98fb-2e6adc5b2d68/resourceGroups/hub-network/providers/Microsoft.Network/virtualNetworks/hub-vnet'
    }
  }
}

