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

## September 18, 2026 - Networking Q11-Q20 Brainstorming

### Q11 - Same VNet Private Communication

Resources in different subnets of the same VNet can communicate using private IP addresses by default, assuming no NSG or routing restrictions prevent the traffic.

Key lesson:

VNet = private network boundary
Subnet = logical segmentation

A subnet does not automatically provide security isolation. NSGs and routing controls can restrict communication.

### Q12 - VNet Peering

VNet Peering provides private connectivity between two Azure VNets.

Resources in peered VNets can communicate using private IP addresses.

Key lesson:

VNet Peering = private VNet-to-VNet connectivity

### Q13 - NSG Troubleshooting

If VM-01 cannot communicate with VM-02, investigate the applicable NSG rules on the source and destination sides.

Key lesson:

Check all applicable NSG layers rather than assuming one NSG controls the entire path.

### Q14 - VNet Peering and Routing

VNet Peering provides connectivity between VNets, but connectivity does not automatically guarantee successful traffic delivery.

If the required route or next hop is incorrect, the packet may not reach the destination.

Key lesson:

Connectivity mechanism != successful routing

Route = traffic path

### Q15 - Network Virtual Appliance Failure

A route can exist while traffic still fails if the configured network appliance or next hop is unavailable.

Key lesson:

A valid route does not guarantee that the next hop can actually receive or forward traffic.

### Q16 - Service Endpoint vs Private Endpoint

Service Endpoint:

Provides private connectivity from a VNet to supported Azure services while the service remains accessed through its service endpoint.

Private Endpoint:

Provides private connectivity to an Azure service through a private IP address in the VNet.

Key lesson:

Private Endpoint = private IP-based access to the Azure service.

### Q17 - Private DNS with Private Endpoint

When accessing an Azure service through a Private Endpoint, private DNS can ensure the service hostname resolves to the Private Endpoint private IP.

Key lesson:

Private Endpoint + correct DNS resolution are closely connected.

### Q18 - Load Balancer vs Application Gateway

Load Balancer operates at Layer 4 and distributes traffic based on IP address and port.

Application Gateway operates at Layer 7 and supports HTTP/HTTPS-aware routing such as URL path-based routing.

Key lesson:

Load Balancer = L4 traffic distribution
Application Gateway = L7 web/application routing

### Q19 - Application Gateway Health Probe

If Application Gateway reports a backend as Unhealthy, investigate the health probe configuration and backend application/service.

Verify:

- Probe protocol
- Probe port
- Probe path
- Backend service
- Expected response

Example:

Application = HTTPS 8443
Health Probe = HTTPS 443

The probe can fail because it is checking the wrong port.

Key lesson:

VM health != application health

### Q20 - HTTP 403

If DNS, routing, NSGs, VM status, port, and health probe are working but the client receives HTTP 403, move upward to the application and authorization layers.

HTTP 403 indicates that the request reached the service but access was denied.

Investigate:

- Requesting identity
- Effective authorization
- Role
- Scope
- Access conditions
- Application behavior

Key lesson:

Network reachability != authorization

---

## Networking Cross-Domain Mental Model

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

## Networking Layered Troubleshooting Model

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

## Networking Architecture Mental Model

VNet
  |
  +-- Subnet
        |
        +-- NIC
              |
              +-- VM

Supporting controls:

Route -> traffic path
NSG -> traffic filtering
DNS -> name resolution

Connectivity:

VNet Peering -> private VNet-to-VNet connectivity
Private Endpoint -> private Azure service connectivity

Application delivery:

Load Balancer -> Layer 4
Application Gateway -> Layer 7 + health probing

## Networking Q11-Q20 Status

Theory brainstorming: COMPLETE
Formal questions: COMPLETE
Scenario reasoning: COMPLETE
Troubleshooting reasoning: COMPLETE

Formal Q11-Q20 average: 9.65 / 10

Primary reinforcement lesson:

Do not troubleshoot a lower layer after evidence has already proven that layer is working.
