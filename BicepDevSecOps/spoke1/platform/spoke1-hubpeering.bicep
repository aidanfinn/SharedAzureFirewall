resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: 'hub-vnet/spoke1-vnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: '/subscriptions/6fd7f490-4be8-41e2-bbdc-7f52d1d7162c/resourceGroups/spoke1-network/providers/Microsoft.Network/virtualNetworks/spoke1-vnet'
    }
  }
}
