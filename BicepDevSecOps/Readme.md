# Managing Azure Firewall With DevSecOps

In this solution there are three sets of files:

- **customRoles**: Custom roles that are used to authorise the workload (spoke) DevOps pipelines service principals with least possible privileges.
- **hub**: A legacy (virtual network) hub with an Azure Firewall.
- **spoke1**: A dummy networked workload that must be connected to the hub, have firewall rules, and a GatewaySubnet route.

Learn more about this DevSecOps architecture [here](https://aidanfinn.com/?p=22495).
