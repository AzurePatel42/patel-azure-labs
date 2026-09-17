# AZ-104 Networking

## Networking Architecture Mental Model

VNet = private network boundary
Subnet = logical segmentation
NIC = connects a VM to a subnet
NSG = traffic filtering
Routing = determines traffic path
DNS = name resolution
VNet Peering = private connectivity between VNets
VPN Gateway = hybrid connectivity between Azure and on-premises
Private Endpoint = private connectivity to Azure services
Load Balancer = Layer 4 traffic distribution
Application Gateway = Layer 7 web/application routing

## Core Troubleshooting Model

Name
  ->
DNS
  ->
IP / Connectivity
  ->
Route
  ->
NSG
  ->
Destination
  ->
Application
  ->
Health
  ->
Troubleshooting

## Cross-Domain Reasoning Model

Authentication
  ->
Authorization
  ->
Scope
  ->
Network
  ->
Resource
  ->
Application
  ->
Health
  ->
Troubleshooting

## Theory Brainstorming - Q1 to Q10

### Q1 - Why use subnets?

Subnets provide logical segmentation and organization inside a VNet.

Important distinction:

A subnet does not automatically provide security.
NSGs, routing, and service-specific controls enforce traffic behavior.

### Q2 - What determines whether VM traffic is allowed?

Routing determines the traffic path.
NSGs determine whether applicable traffic is permitted.

Azure provides system routes by default.
Custom route tables are used when routing behavior needs to be customized.

### Q3 - Hostname fails but private IP works

Investigate DNS first.

If direct private IP connectivity works but the hostname does not, the primary issue is name resolution.

### Q4 - NSG priority

Lower priority numbers are evaluated first.

Example:

Priority 100 = Deny TCP 443
Priority 200 = Allow TCP 443

The priority 100 deny is evaluated first, so TCP 443 is denied.

### Q5 - Private Endpoint and Storage

When a VM accesses Storage through a Private Endpoint, verify that the Storage hostname resolves to the Private Endpoint private IP.

Private DNS is an important part of this configuration.

### Q6 - DNS, routing, NSG, identity, and role verified but Storage returns 403

A 403 indicates that the request reached the service but access was denied.

Re-check the effective authorization and access context before assuming the application itself is the problem.

### Q7 - Subnet NSG versus NIC NSG

Both applicable NSG layers must permit the traffic.

An allow on one layer does not cancel a deny on another applicable layer.

### Q8 - Private connectivity between VNets

Use VNet Peering to provide private connectivity between Azure VNets.

VNet Peering allows resources in the connected VNets to communicate using private IP addresses.

### Q9 - Application Gateway cannot reach backend VM

Investigate:

1. Routing
2. NSG rules
3. Backend connectivity
4. Application Gateway backend health

DNS resolution alone does not prove that routing or traffic authorization is correct.

### Q10 - Application Gateway reports backend VM as Unhealthy

Investigate the Application Gateway health probe and the application/service running on the backend VM.

Unhealthy does not automatically mean that the VM itself is stopped.

The VM can be running while the application is not responding on the expected port or probe path.

## Architecture Hierarchy

VNet
  |
  +-- Subnet
        |
        +-- NIC
              |
              +-- VM

Traffic controls and connectivity:

Route -> determines path
NSG -> filters traffic
DNS -> resolves names
VNet Peering -> connects VNets
Private Endpoint -> provides private service connectivity
Application Gateway -> Layer 7 routing and health probing

## Primary Weakness Identified

The main weakness identified during Networking Q1-Q10 is architecture hierarchy and component identification.

The key distinction to reinforce is:

VNet = network boundary
Subnet = segmentation
NIC = VM network connection
NSG = traffic filter
Route = traffic path
DNS = name resolution

## Networking Q1-Q10 Status

Theory brainstorming: COMPLETE
Formal questions: COMPLETE
Scenario reasoning: COMPLETE
Troubleshooting coverage: COMPLETE

Next step:

Networking weak-area reinforcement and retesting.
