# WebSockets vs Polling vs Server Sent Events

![alt text](image.png)
Here the connections are duplex in nature. 

- client 1 added new stock value in its account then
    - after updateing in the server, it will send the updated value to all the clients.

![alt text](image-2.png)

## Challenges with Websocket
- As this websocket is statefull service, server has limitation, meaning let's say max it can handle 1 Million duplex connections.
- But your user base increased to 2 Million, So you can only do Vertical scaling
- There are lots of challenges in the Horizontal scaling  


Reference:- https://www.youtube.com/watch?v=WS352jTTkPU
