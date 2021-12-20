resource globalRulesCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-03-01' = {
  name: 'hub-fw-afwp/spoke1'
  properties: {
    priority: 1000
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
            name: 'Allow-Office365-SMTP'
            description: 'Allow SMTP traffic from the web server to Office 365 SMTP'
            sourceAddresses: [
              '10.0.8.4'
            ]
            sourceIpGroups: []
            ipProtocols: [
              'TCP'
            ]
            destinationPorts: [
              '25'
            ]
            destinationIpGroups: []
            destinationAddresses: []
            destinationFqdns: [
              'smtp.office365.com'
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
            name: 'Allow-GitHub'
            description: 'Allow traffic from all sources to GitHub'
            sourceAddresses: [
              '10.0.8.0/25'
            ]
            sourceIpGroups: []
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            targetFqdns: [
              'www.github.com'
            ]
            fqdnTags: []
          }
          {
            ruleType: 'ApplicationRule'
            name: 'Https'
            description: 'Allow traffic from the web server to some site'
            sourceAddresses: [
              '10.0.8.4'
            ]
            sourceIpGroups: []
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            targetFqdns: [
              'www.somesite.com'
            ]
            fqdnTags: []
          }
        ]
      }
    ]
  }
}
