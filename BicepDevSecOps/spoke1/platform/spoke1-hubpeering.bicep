////////////////
// Parameters //
////////////////

// Resource ID of the workload Virtual Network
param workloadVirtualNetworkId string


///////////////
// Resources //
///////////////

// Hub-to-Spoke Peering //

resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: 'hub-vnet/spoke1-vnet'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: workloadVirtualNetworkId
    }
  }
}
