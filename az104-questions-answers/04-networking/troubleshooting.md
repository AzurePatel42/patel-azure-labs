# AZ-104 Networking - Troubleshooting

## September 17, 2026 - Networking Q1-Q10

## Core Networking Troubleshooting Sequence

Use this sequence when diagnosing Azure networking problems:

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

The purpose is to troubleshoot from the lower-level connectivity layers toward the application and health layers.

---

## Layer 1 - Name

Question:

Can the client identify the destination by name?

If hostname access fails but direct IP access works:

Investigate DNS.

---

## Layer 2 - DNS

Verify:

- Hostname resolution
- Private DNS configuration
- Expected private IP resolution
- Private Endpoint DNS behavior

For Private Endpoint scenarios:

The service hostname should resolve to the Private Endpoint private IP from the client.

---

## Layer 3 - IP and Connectivity

Verify:

- Source IP
- Destination IP
- Network reachability
- Expected protocol
- Expected destination port

Successful DNS resolution does not prove network connectivity.

---

## Layer 4 - Routing

Question:

Does Azure have a valid route to the destination?

Azure provides system routes by default.

Investigate custom route tables when routing behavior has been intentionally customized.

Key distinction:

Route = traffic path

---

## Layer 5 - NSG

Question:

Is the traffic permitted?

Check all applicable NSGs.

Important:

A subnet NSG and NIC NSG can both apply.

An allow on one applicable NSG does not cancel a deny on another applicable NSG.

### NSG Priority

Lower priority numbers are evaluated first.

Example:

Priority 100 - Deny TCP 443
Priority 200 - Allow TCP 443

Result:

TCP 443 is denied.

---

## Layer 6 - Destination

If DNS, connectivity, routing, and NSGs appear correct:

Verify the destination resource.

For a VM:

- Is the VM running?
- Is the expected service available?
- Is the service listening on the expected port?

---

## Layer 7 - Application

A successful network connection does not guarantee application success.

Investigate:

- Application/service state
- Listening port
- Application configuration
- Application dependencies
- Expected protocol
- Expected response

---

## Layer 8 - Health

A resource can be running while the application or backend is unhealthy.

### Application Gateway Backend Health

If Application Gateway reports a backend VM as Unhealthy:

Investigate:

1. Health probe configuration
2. Probe path
3. Probe port
4. Backend application/service
5. Application response

Key distinction:

VM health != Application health

A VM may be running while the application is not responding as expected.

---

## HTTP 403 Troubleshooting

A 403 response indicates that the request reached the service but access was denied.

When authorization appears to be the problem:

1. Identify the requesting identity.
2. Verify effective authorization.
3. Verify the role.
4. Verify the scope.
5. Verify applicable access conditions.
6. Then investigate application behavior if the access context is confirmed.

Key distinction:

Network reachability != Authorization

---

## VNet Peering Troubleshooting

For private connectivity between Azure VNets:

Verify:

1. VNet Peering exists.
2. The VNets have non-overlapping address spaces.
3. Routing supports the connection.
4. Applicable NSGs permit the traffic.
5. The destination resource is reachable.

Key concept:

VNet Peering = private connectivity between Azure VNets.

---

## Private Endpoint Troubleshooting

When a VM accesses an Azure service through a Private Endpoint:

Check:

1. Private Endpoint exists.
2. DNS resolves the service hostname to the Private Endpoint private IP.
3. Routing is correct.
4. NSGs and other applicable network controls permit traffic.
5. Authentication is valid.
6. Authorization is valid.

Use the cross-domain sequence:

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

---

## Application Gateway Troubleshooting

Scenario:

Users can reach Application Gateway, but Application Gateway cannot successfully use VM-02 as a backend.

Troubleshooting sequence:

1. DNS
2. Routing
3. NSGs
4. Backend connectivity
5. Health probe
6. Backend application/service

If the backend is Unhealthy:

Do not immediately assume the VM is stopped.

Investigate whether the health probe can successfully reach and receive the expected response from the backend service.

---

## Q1-Q10 Troubleshooting Lessons

### Q1

Weakness:

Architecture hierarchy and component identification.

Reinforce:

VNet = network boundary
Subnet = segmentation
NIC = VM network connection
NSG = traffic filtering
Route = traffic path
DNS = name resolution

### Q2

Routing and NSG solve different problems.

Route determines path.

NSG determines whether applicable traffic is permitted.

### Q3

If private IP works but hostname fails:

Investigate DNS.

### Q4

Lower NSG priority number is evaluated first.

### Q5

Private Endpoint scenarios require correct private name resolution.

### Q6

HTTP 403 requires authorization/access-context investigation.

### Q7

All applicable NSG layers must permit the traffic.

### Q8

VNet Peering provides private connectivity between Azure VNets.

### Q9

Application Gateway backend problems require investigation of routing, NSGs, connectivity, and backend health.

### Q10

Application Gateway Unhealthy requires investigation of the health probe and backend application/service.

---

## Primary Networking Weak Area

Architecture hierarchy and component identification.

### Reinforcement Model

VNet
  ->
Subnet
  ->
NIC
  ->
VM

Supporting controls:

Route -> traffic path
NSG -> traffic filtering
DNS -> name resolution

Connectivity:

VNet Peering -> VNet-to-VNet private connectivity
Private Endpoint -> private connectivity to Azure services

Application delivery:

Load Balancer -> Layer 4
Application Gateway -> Layer 7 + health probing

---

## Status

Networking Q1-Q10 troubleshooting coverage: COMPLETE

Next:

Networking weak-area reinforcement and retesting.

## September 18, 2026 - Networking Q11-Q20 Troubleshooting

### Q11 - Same VNet Traffic

If resources in different subnets cannot communicate:

1. Verify source and destination IPs.
2. Check routing.
3. Check applicable NSGs.
4. Check destination availability.

### Q12 - VNet Peering

If communication between peered VNets fails:

1. Verify peering exists.
2. Verify address spaces do not overlap.
3. Verify routing.
4. Verify applicable NSGs.
5. Verify destination availability.

### Q13 - NSG Investigation

Check all applicable NSGs.

A deny on an applicable subnet or NIC NSG can block traffic even if another applicable NSG allows it.

### Q14 - Routing

VNet connectivity does not prove that the required route is correct.

Investigate:

- Destination prefix
- Effective routes
- Next hop
- Custom route tables
- Network appliance path

### Q15 - Network Appliance

A route pointing to a network appliance does not guarantee delivery.

Verify that the appliance is:

- Available
- Reachable
- Configured to receive the traffic
- Able to forward the traffic

### Q16 - Service Endpoint vs Private Endpoint

When comparing the two models, identify whether the scenario requires private IP-based access to the Azure service.

Private Endpoint provides private connectivity through a private IP.

### Q17 - Private DNS

If private IP connectivity works but the service hostname fails:

1. Check DNS resolution.
2. Verify Private DNS configuration.
3. Verify VNet linkage.
4. Verify hostname resolves to the expected Private Endpoint private IP.

### Q18 - Application Gateway

If routing must use URL paths:

Application Gateway
  ->
Layer 7
  ->
HTTP/HTTPS
  ->
Path-based routing

### Q19 - Health Probe

If Application Gateway reports a backend as Unhealthy:

1. Verify probe protocol.
2. Verify probe port.
3. Verify probe path.
4. Verify backend service is running.
5. Verify expected response.

Example:

Application = HTTPS 8443
Probe = HTTPS 443

Potential failure:

Probe checks a port where the application is not listening.

### Q20 - HTTP 403

If the client receives HTTP 403 after network connectivity is proven:

Investigate:

1. Requesting identity
2. Authentication context
3. Effective authorization
4. Role
5. Scope
6. Applicable access conditions
7. Application behavior

Key lesson:

HTTP 403 is evidence that the request reached the service and access was denied.

Do not automatically return to DNS, routing, or NSG troubleshooting when those layers have already been verified.

## Networking Q11-Q20 Troubleshooting Status

Troubleshooting coverage: COMPLETE

Primary improvement:

Evidence-based layer selection.

Mental model:

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

Networking model:

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

Next:

Networking Q21-Q30
