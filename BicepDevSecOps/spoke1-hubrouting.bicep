resource route 'Microsoft.Network/routeTables/routes@2021-03-01' = {
  name: 'hub-vnet-gatewaysubnet-rt/spoke1-vnet'
  properties: {
    addressPrefix: '10.0.8.0/25'
    nextHopIpAddress: '10.0.1.4'
    nextHopType: 'VirtualAppliance'
  }
}
