# AZ-104 Networking - Scenario Reasoning

## September 17, 2026 - Networking Q1-Q10

## Scenario 1 - VNet and Subnet Architecture

### Situation

A VNet contains multiple subnets and virtual machines.

### Reasoning

The VNet is the private network boundary.

Subnets provide logical segmentation within the VNet.

A NIC connects the VM to the network.

An NSG controls applicable network traffic.

DNS provides name resolution.

### Key Lesson

Start at the highest architectural level:

VNet
  ->
Subnet
  ->
NIC
  ->
VM

Do not confuse a traffic-control component such as an NSG with the network boundary itself.

---

## Scenario 2 - Routing versus Traffic Permission

### Situation

Traffic needs to move between Azure resources.

### Reasoning

First distinguish two questions:

1. Where does the traffic go?
2. Is the traffic allowed?

Routing determines the traffic path.

NSGs determine whether applicable traffic is permitted.

### Key Lesson

Route = path

NSG = permission/filtering

---

## Scenario 3 - Hostname Failure

### Situation

A VM can connect to a destination by private IP address but cannot connect using the hostname.

### Reasoning

Because direct IP connectivity works, investigate DNS first.

The problem is likely related to name resolution rather than basic IP connectivity.

### Key Lesson

If IP works but hostname fails:

Investigate DNS.

---

## Scenario 4 - NSG Rule Priority

### Situation

An NSG contains:

Priority 100 - Deny TCP 443

Priority 200 - Allow TCP 443

### Reasoning

Lower priority numbers are evaluated first.

The priority 100 deny is therefore evaluated before the priority 200 allow.

TCP 443 is denied.

### Key Lesson

Lower number = higher evaluation priority.

---

## Scenario 5 - Private Endpoint and DNS

### Situation

A VM accesses an Azure Storage account through a Private Endpoint.

### Reasoning

Verify that the Storage hostname resolves to the Private Endpoint private IP from the VM.

Private DNS is an important part of this configuration.

### Key Lesson

Private Endpoint connectivity depends on correct private name resolution.

---

## Scenario 6 - Storage 403

### Situation

DNS, routing, NSG, managed identity, and Storage Blob Data role appear verified, but the application receives HTTP 403.

### Reasoning

HTTP 403 means the request reached the service but access was denied.

The effective authorization and access context should be re-checked before assuming an application dependency problem.

### Key Lesson

Separate:

Network reachability

from

Authorization.

A successful network path does not automatically mean the request is authorized.

---

## Scenario 7 - Multiple NSG Layers

### Situation

A subnet NSG allows TCP 443.

The NIC NSG denies TCP 443.

### Reasoning

Both applicable NSG layers must permit the traffic.

An allow on one applicable NSG does not cancel a deny on another applicable NSG.

### Key Lesson

Check all applicable NSG layers.

---

## Scenario 8 - VNet Peering

### Situation

VM-01 is in VNet-A.

VM-02 is in VNet-B.

The VNets have no connection.

### Reasoning

Use VNet Peering to provide private connectivity between the VNets.

The VMs can then communicate using private IP addresses.

### Key Lesson

VNet Peering = private connectivity between Azure VNets.

---

## Scenario 9 - Application Gateway Backend Connectivity

### Situation

Users can reach Application Gateway, but Application Gateway cannot reach VM-02.

DNS resolves correctly.

### Reasoning

Investigate the network path and traffic authorization:

1. Routing
2. Applicable NSGs
3. Backend connectivity
4. Application Gateway backend health

### Key Lesson

Successful DNS resolution does not prove that the complete network path is working.

---

## Scenario 10 - Application Gateway Backend Unhealthy

### Situation

DNS, routing, NSGs, VM status, and backend pool configuration appear correct.

Application Gateway reports VM-02 as Unhealthy.

### Reasoning

Investigate the Application Gateway health probe and the application/service running on VM-02.

The VM can be running while the application is not responding on the expected port or probe path.

### Key Lesson

VM health and application health are different concepts.

Application Gateway health probes help determine whether the backend is responding as expected.

---

## Cross-Scenario Reasoning Pattern

For Networking troubleshooting, use:

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

For cross-domain Azure troubleshooting, use:

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

## Networking Q1-Q10 Scenario Status

Scenario coverage: COMPLETE

Troubleshooting reasoning: COMPLETE

Primary reinforcement target:

VNet -> Subnet -> NIC -> VM

Supporting controls:

Route -> traffic path
NSG -> traffic filtering
DNS -> name resolution
VNet Peering -> VNet connectivity
Private Endpoint -> private service connectivity
Application Gateway -> Layer 7 routing and health probing

Next:

Networking weak-area reinforcement and retesting.
