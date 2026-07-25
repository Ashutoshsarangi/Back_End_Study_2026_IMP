## 05 How Subnet Masks Reveal Network Secrets: A Deep Dive

1. Subnet
2. Subnet mask


If I wanted to send some data from my laptop to mobile which are part of the same network.

how it is using the subnetmask to get it.

Also we cover CIDR notation, I belive it is the same subnet mask.

Example:- 192.168.1.0 (Network ip)

CIDR notation is 192.168.1.0/24

laptop:- 192.168.1.3
mobile:- 192.168.1.2
router;- 192.168.1.1

Subnetmask (225.225.225.0) fixed


How a laptop know where he is it will apply the subnetmask to own ip (logical AND Operation) and then he will get the networkIP.

Now if he send the data to mobile laptop will do the same subnet masking with mobile IP. and in result we will get the same network IP.

hence we will get that both sender and reciver are in the same network.

Now laptop can send the data with out router / internet. (I am not sure how) ARP + MAC address 

If my laptop and Mobile are not in the same network laptop hand to use router to send the data out side of the network


---------Generated Content-----------

## 05 — How Subnet Masks Reveal Network Secrets

### 1. Subnet
A **subnet** is a group of IP addresses treated as one local network.  
Example: `192.168.1.0/24` covers hosts from `192.168.1.1` to `192.168.1.254` (with `.0` as network and `.255` as broadcast in a typical `/24`).

### 2. Subnet mask
A **subnet mask** tells a device which bits of an IP are the **network** part and which are the **host** part.

Example:
- Network: `192.168.1.0`
- Mask: `255.255.255.0`
- Meaning: first 24 bits = network, last 8 bits = host

---

### 3. CIDR notation
**CIDR** is another way to write the same thing (network + mask length).

| Style | Example |
|---|---|
| Network + mask | `192.168.1.0` with `255.255.255.0` |
| CIDR | `192.168.1.0/24` |

`/24` means 24 network bits → same as mask `255.255.255.0`.

---

### 4. Example setup

| Device | IP |
|---|---|
| Network | `192.168.1.0/24` |
| Router (gateway) | `192.168.1.1` |
| Laptop | `192.168.1.3` |
| Mobile | `192.168.1.2` |
| Subnet mask | `255.255.255.0` |

---

### 5. How a device finds its network ID
The device applies a **bitwise AND** between its IP and the subnet mask:

```
Laptop IP:   192.168.1.3
Mask:        255.255.255.0
AND result:  192.168.1.0   ← network ID
```

That is how the laptop knows which network it belongs to.

---

### 6. Same network: laptop → mobile (no internet / no routing needed)

When the laptop sends data to the mobile:

1. AND laptop IP with mask → `192.168.1.0`
2. AND mobile IP with mask → `192.168.1.0`
3. Same network ID → destination is **local (on-link)**

Then delivery uses Layer 2:

1. Laptop uses **ARP**: “Who has `192.168.1.2`?”
2. Mobile answers with its **MAC address**
3. Laptop sends a frame addressed to that MAC
4. The Wi‑Fi AP / switch forwards it on the LAN

Result: traffic stays on the local network. The router is not used as a *router* for this path (no need for the internet).

---

### 7. Different network: laptop must use the router

If the destination’s network ID (after AND with the mask) is **different**, the laptop treats it as remote:

1. It does **not** ARP for the destination IP
2. It ARPs for the **default gateway** (`192.168.1.1`) instead
3. It sends the frame to the router’s MAC
4. The router forwards the packet toward the other network (and possibly the internet)

---

### 8. One-line summary
**Subnet mask / CIDR** decides “same LAN or not.”  
**Same LAN** → ARP + MAC, local delivery.  
**Different LAN** → send to the router (gateway).

