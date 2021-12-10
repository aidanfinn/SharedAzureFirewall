resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: 'hub-vnet/spoke1-vnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: '/subscriptions/608bc755-1c4d-4b03-ac26-3e8a20a3dc03/resourceGroups/spoke1/providers/Microsoft.Network/virtualNetworks/spoke1-vnet'
    }
  }
}
