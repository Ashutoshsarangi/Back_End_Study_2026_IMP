# API Design and Architecture - Backend Engineering 

## Types of API

### REST API (HTTP + JSON)
Resource-based API over HTTP (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`). Usually exchanges JSON. Stateless, easy to cache, widely used for web/mobile backends.

### SOAP API (XML)
Older enterprise style: XML envelopes, formal WSDL contracts, often over HTTP. Strong typing and standards (security, transactions); heavier and less common for new apps.

### GraphQL
Client asks for exactly the fields it needs in one query against a schema. Great for flexible UIs and reducing over/under-fetching; needs careful design for caching and auth.

### gRPC (RPC + Protocol Buffers)
Binary RPC over HTTP/2 using Protobuf. Fast, strongly typed, good for service-to-service calls. Less browser-native than REST/JSON.

### WebSocket
Persistent two-way connection. Server and client push messages anytime. Used for chat, live updates, multiplayer—not classic request/response APIs.

### Message Broker (e.g. RabbitMQ)
Async messaging: producers publish, consumers process later. Decouples services, handles spikes and background work (orders, emails, retries)—not a direct client→server HTTP API.

---

## Passing Data to the Backend

### Query parameters
Data in the URL after `?` — e.g. `/products?page=2&sort=price`. Best for filters, search, pagination. Visible, cacheable, size-limited. Prefer for **GET**.

### Request body
Payload in the HTTP body (usually JSON) — e.g. `{ "email": "...", "password": "..." }`. Best for creating/updating resources. Prefer for **POST/PUT/PATCH**. Not for sensitive data in logs unless handled carefully.

### Path parameters
Data inside the URL path — e.g. `/users/42/orders/9`. Identifies a specific resource. Keep short and stable (IDs), not large filters or complex objects.

---

### **Quick pick:** 

- identify a resource → **path**; 
- filter/sort a list → **query**;
- send structured create/update data → **body**.

----------------------------

## My Question:-
Yes — **Publisher/Subscriber in microservices is almost always implemented with a message broker** (RabbitMQ, Kafka, SNS/SQS, Azure Service Bus, etc.). Your instinct is right.

## What the pattern is

```
Publisher(s)  →  Broker (exchange/topic)  →  Subscriber(s)
```

- **Publisher** emits an event (`OrderCreated`) and does **not** know who listens.
- **Broker** routes, stores (briefly or durably), and delivers.
- **Subscribers** each react independently (email, inventory, analytics).

That is **async, decoupled** communication — opposite of a REST call where service A waits for service B.

## Why a broker (not direct HTTP)

| Without broker (sync REST) | With broker (pub/sub) |
|---|---|
| Caller must know every consumer | Publisher only knows the topic |
| If one consumer is down, call fails | Messages can wait / retry |
| Hard to add new consumers | New subscriber = new binding |
| Tight coupling | Loose coupling |

## RabbitMQ specifically

RabbitMQ is a common **pub/sub** (and queue) broker:

1. Publisher → **Exchange** (e.g. `orders.events`)
2. Exchange routes by rules → **Queues**
3. Each subscriber has (or shares) a queue and consumes

Typical topologies:

- **Fanout** — every subscriber gets a copy (classic pub/sub)
- **Topic** — route by pattern (`order.created`, `order.*`)
- **Direct** — exact routing key
- **Work queue** — one message → one worker (competing consumers; more “queue” than “broadcast”)

So: **pub/sub ⊆ what message brokers do**; brokers also do point-to-point queues, RPC-over-queue, etc.

## Pub/Sub vs other microservice styles

| Style | Tooling | When |
|---|---|---|
| Sync request/response | REST, gRPC | Need immediate answer |
| Async pub/sub | RabbitMQ, Kafka, SNS | “Something happened”; many listeners |
| Async command/queue | RabbitMQ queue, SQS | One job to process once |
| Realtime push to UI | WebSocket | Live browser updates |

**WebSocket ≠ pub/sub between microservices.** WebSocket is usually client↔server. Service↔service pub/sub is broker-based.

## Mental model (e-comm example)

```
Checkout service publishes: OrderPlaced
         │
         ▼
      RabbitMQ
    ┌────┼────┐
    ▼    ▼    ▼
 Inventory  Email  Analytics
```

Checkout does not call those three APIs. It publishes once; each service reacts on its own.

## Caveats

- **Eventual consistency** — not instant across all services  
- **Ordering / duplicates** — design for at-least-once delivery  
- **Schema** — agree on event contracts (JSON/Avro/Protobuf)  
- **Kafka vs RabbitMQ** — Kafka = durable log, high throughput, replay; RabbitMQ = flexible routing, classic queues/pub-sub  
