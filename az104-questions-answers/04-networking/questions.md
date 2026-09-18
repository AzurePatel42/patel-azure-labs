# AZ-104 Networking - Formal Questions

## September 17, 2026 - Networking Q1-Q10

Questions completed:

10 / 10

Domain status:

FOUNDATION COMPLETE

Session score:

8.5 / 10

## Question Scores

- Q1 - 4/10
- Q2 - 9/10
- Q3 - 9/10
- Q4 - 10/10
- Q5 - 9/10
- Q6 - 7.5/10
- Q7 - 9/10
- Q8 - 10/10
- Q9 - 9/10
- Q10 - 8.5/10

## Q1 - VNet and Subnet Architecture

Scenario:

A VNet contains two subnets with virtual machines.

Question:

What provides the private network boundary and what is the role of subnets?

User reasoning:

NIC / DNS / NSG

Score:

4/10

Correction:

VNet provides the private network boundary.

Subnets provide logical segmentation inside the VNet.

NIC connects a VM to the network.

NSG filters network traffic.

DNS provides name resolution.

Key lesson:

Identify the architectural hierarchy before selecting a lower-level networking component.

## Q2 - Routing and Traffic Permission

User reasoning:

Routing table and NSG.

Score:

9/10

Correct reasoning:

Routing determines the traffic path.

NSGs determine whether applicable traffic is permitted.

Azure provides system routes by default.

Custom route tables are used when routing behavior needs to be customized.

## Q3 - Hostname versus Private IP

Scenario:

Hostname access fails but direct private IP access works.

User reasoning:

Investigate DNS, private or public.

Score:

9/10

Correct reasoning:

Investigate DNS first.

If direct private IP connectivity works but the hostname does not, name resolution is the primary area to investigate.

## Q4 - NSG Priority

Scenario:

Priority 100 denies TCP 443.

Priority 200 allows TCP 443.

User reasoning:

The priority 100 deny is evaluated first.

Score:

10/10

Correct reasoning:

Lower priority numbers are evaluated first.

The priority 100 deny therefore blocks TCP 443.

## Q5 - Private Endpoint and Storage DNS

Scenario:

A VM accesses Storage through a Private Endpoint.

User reasoning:

Private DNS must be configured.

Score:

9/10

Refinement:

Verify that the Storage hostname resolves to the Private Endpoint private IP from the VM.

Private DNS is an important part of this configuration.

## Q6 - Storage 403

Scenario:

DNS, routing, NSG, managed identity, and Storage Blob Data role are verified, but the application receives HTTP 403.

User reasoning:

Investigate the application layer and dependencies.

Score:

7.5/10

Correction:

A 403 indicates that the request reached the service but access was denied.

Re-check the effective authorization and access context before assuming the application itself is the problem.

## Q7 - Subnet NSG and NIC NSG

Scenario:

Subnet NSG allows TCP 443.

NIC NSG denies TCP 443.

User reasoning:

The connection is denied because the NIC NSG denies TCP 443.

Score:

9/10

Refinement:

Both applicable NSG layers must permit the traffic.

An allow on one layer does not cancel a deny on another applicable layer.

## Q8 - VNet Peering

Scenario:

VM-01 is in VNet-A.

VM-02 is in VNet-B.

The VNets have no connection.

User reasoning:

Use VNet Peering to communicate with VM-02 using private IP addresses.

Score:

10/10

Correct reasoning:

VNet Peering provides private connectivity between Azure VNets.

Resources in the connected VNets can communicate using private IP addresses.

## Q9 - Application Gateway Backend Connectivity

Scenario:

Users can reach Application Gateway, but Application Gateway cannot reach VM-02.

DNS resolves correctly.

User reasoning:

Investigate the route table and NSG on VM-02.

Score:

9/10

Correct reasoning:

Investigate routing, applicable NSGs, backend connectivity, and Application Gateway backend health.

DNS resolution alone does not prove that routing or traffic authorization is correct.

## Q10 - Application Gateway Backend Unhealthy

Scenario:

DNS, routing, NSGs, VM status, and backend pool configuration appear correct.

Application Gateway reports VM-02 as Unhealthy.

User reasoning:

Investigate whether the application has the proper availability mechanism.

Score:

8.5/10

Refinement:

Investigate the Application Gateway health probe and the application/service running on VM-02.

Unhealthy does not automatically mean the VM itself is stopped.

The VM can be running while the application is not responding on the expected port or probe path.

## Performance Summary

Questions completed: 10 / 10

Session score: 8.5 / 10

Strong areas:

- NSG priority
- DNS troubleshooting
- VNet Peering
- Routing versus NSG reasoning
- Layered troubleshooting
- Application Gateway backend investigation

Primary weakness:

Networking architecture hierarchy and component identification.

Priority reinforcement:

VNet -> Subnet -> NIC -> VM

Supporting networking controls:

Route -> traffic path
NSG -> traffic filtering
DNS -> name resolution

## Status

Networking Q1-Q10: COMPLETE

Theory brainstorming: COMPLETE

Formal question block: COMPLETE

Scenario coverage: COMPLETE

Troubleshooting coverage: COMPLETE

Next target:

Networking weak-area reinforcement and retesting.

## September 18, 2026 - Networking Q11-Q20

### Questions Completed

10 / 10

### Session Score

9.65 / 10

### Q11 - Same VNet Communication

User reasoning:

VMs in different subnets of the same VNet can communicate using private IP addresses when there are no NSG or routing restrictions.

Score:

10/10

Key refinement:

Subnets provide logical segmentation. NSGs and routing can restrict communication.

### Q12 - VNet Peering

User reasoning:

VNet Peering provides private connectivity between VNets using private IP addresses.

Score:

10/10

### Q13 - NSG Investigation

User reasoning:

Investigate the applicable NSG on VM-02.

Score:

10/10

### Q14 - Peering and Routing

User reasoning:

VNet Peering provides connectivity, but an incorrect route or next hop can prevent packet delivery.

Score:

10/10

Key lesson:

Connectivity does not guarantee correct routing.

### Q15 - Network Appliance Failure

User reasoning:

A configured route does not guarantee successful traffic delivery if the receiving network appliance or next hop is unavailable.

Score:

10/10

### Q16 - Service Endpoint vs Private Endpoint

User reasoning:

Service Endpoint uses the Azure service endpoint, while Private Endpoint provides private connectivity using a private IP address.

Score:

10/10

### Q17 - Private DNS

User reasoning:

Investigate DNS when a Private Endpoint scenario requires the Azure service hostname to resolve to the Private Endpoint private IP.

Score:

7.5/10

Correction:

When private IP connectivity is already proven but hostname access fails, DNS should be investigated before returning to lower network layers.

### Q18 - Application Gateway Path Routing

User reasoning:

Application Gateway is appropriate because the client request must be routed based on the URL path using HTTP/HTTPS.

Score:

10/10

### Q19 - Application Gateway Health Probe

User reasoning:

The backend application listens on HTTPS 8443 while the health probe checks HTTPS 443. Investigate and correct the health probe configuration.

Score:

10/10

### Q20 - HTTP 403

User reasoning:

Investigate the Application layer when the client receives HTTP 403 after DNS, routing, NSGs, VM, port, and health probe have been verified.

Score:

9/10

Refinement:

HTTP 403 means the request reached the service but access was denied. Investigate authorization and access context rather than assuming HTTP/HTTPS itself caused the problem.

## Q11-Q20 Performance Summary

Questions completed: 10 / 10

Session score: 9.65 / 10

Strong areas:

- VNet architecture
- VNet Peering
- NSG troubleshooting
- Routing reasoning
- Service Endpoint vs Private Endpoint
- Private DNS
- Application Gateway
- Health probe troubleshooting
- Cross-domain troubleshooting

Primary reinforcement lesson:

Use evidence from the troubleshooting flow to identify the failing layer instead of returning to layers already proven to work.

## Networking Progress

Q1-Q10: COMPLETE
Q11-Q20: COMPLETE

Current domain position:

Networking Q1-Q20 COMPLETE

Next target:

Networking Q21-Q30
