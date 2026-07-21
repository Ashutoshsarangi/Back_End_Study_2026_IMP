## 03 Mastering IP Address Structure: From Octets to Binary Representation


**Name:**  **octet** — an 8-bit group.

**IPv4 structure**
- 4 octets × 8 bits = **32 bits** = **4 bytes**
- Written as decimal: `192.122.10.11`
- Same value in binary, e.g. first octet `192` → `11000000`

**Range per octet:** **0–255** (2⁸ − 1). That’s the full numeric range.

**“Reserved” isn’t every special number** — some whole **address ranges** or **roles** are special, for example:

| Range / address | Meaning |
|---|---|
| `0.0.0.0` | “This host” / unspecified (context-dependent) |
| `127.0.0.0/8` | Loopback (`127.0.0.1` = localhost) |
| `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16` | Private (LAN, not public internet) |
| `169.254.0.0/16` | Link-local (APIPA) |
| `224.0.0.0/4` | Multicast |
| `255.255.255.255` | Limited broadcast |

So: each octet is 0–255; only certain **addresses/ranges** are reserved or special — not random “forbidden” numbers inside every octet.



https://www.youtube.com/watch?v=mM9-9KAP0E8&list=PLd1s-PEC5Pio&index=3
