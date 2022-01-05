////////////////
// Parameters //
////////////////

// Name of the Rules Collection Group to add to the hub Azure Firewall for the workload
param workloadFirewallRulesCollectionGroupName string

// Priority of the Rules Collection Group to add to the hub Azure Firewall for the workload
param workloadFirewallRulesCollectionGroupPriority int

// Rules Collections to add to the hub Azure Firewall for the workload
param workloadFirewallRulesCollections array


///////////////
// Resources //
///////////////

// Workload route in Hub GatewaySubnet Route Table //

resource globalRulesCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-03-01' = {
  name: workloadFirewallRulesCollectionGroupName
  properties: {
    priority: workloadFirewallRulesCollectionGroupPriority
    ruleCollections: workloadFirewallRulesCollections
  }
}
