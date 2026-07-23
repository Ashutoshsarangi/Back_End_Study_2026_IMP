### RTO / RPO (decide first)
- **RTO** — how long downtime is acceptable
- **RPO** — how much data loss is acceptable
- These drive backup restore vs warm/hot standby vs sync replica vs multi-primary

### Warm standby
- Primary serves traffic; standby waits and is promoted on failure
- **Pros:** simple, cheaper, no write conflicts, clear source of truth
- **Cons:** failover takes seconds–minutes; async → possible data loss; capacity often untested
- **Use when:** some downtime OK, DR focus, no write conflicts wanted

### Hot standby / read replica
- Writes → **primary only**; primary replicates to replica; reads may hit replica
- On failure: promote replica (do **not** write to replica until promoted)
- **Pros:** read scaling, faster failover, replica proven under load
- **Cons:** **replication lag** (stale reads after writes)
- **Lag handling:** read-your-writes from primary; replicas only for stale-OK reads; stop routing if lag high
- **Use when:** read-heavy, some staleness OK — most common production setup

### Multi-primary
- Multiple nodes accept writes
- **Hard problems:** write conflicts, partial failures, higher write latency, split-brain, ops complexity
- **Use only when:** multi-region writes + team can own conflict/consensus complexity

### Sync vs async replication
- **Async:** fast writes; risk of data loss + lag on failover
- **Sync:** lower data-loss risk; slower writes; replica issues can hurt primary

### Comparison (short)
| | Warm | Hot / replica | Multi-primary |
|---|---|---|---|
| Writes | primary | primary | many |
| Reads | primary | primary + replicas | many |
| Failover | medium | fast | very fast |
| Complexity | low | medium | very high |

### Practical default
- **One primary (writes) + read replicas (reads / failover)**
- Route: mutations → primary; critical post-write GETs → primary; reports/catalog → replicas
- Endpoints: `db-write` / `db-read` (stable listeners); automate health + promote; **fence** old primary; **test** failover drills

### One-liners
- **Warm:** backup ready, mostly passive  
- **Hot:** continuously updated, can serve reads  
- **Multi-primary:** many writers → conflicts & partial failure hell  
- **Default:** single primary + replicas