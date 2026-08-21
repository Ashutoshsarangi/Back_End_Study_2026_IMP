![alt text](image.png)

![alt text](image-1.png)
![alt text](image-2.png)

    - If I have single server, so horizontal scaling needed.
    -  

## Replication

    - keeping copies of a database on multiple server.

    types:-
        - Single Lead
        - Multi Lead
        - Leader Less

Single Lead:-

![alt text](image-3.png)

### Read Replica(Follower)
    - A Copy of a database from which data may only be read.

### Leader
    - We only going to send write requests there.


NOTE:- when we have multiple Leaders for write I believe we need to have some load balancer / when we have multiple follower I belive there also we need a load balancer to distribute the loads. But need more investigation on the same.


Communication between Leader and followers:-

    - Sync
    - Async


### SYNC 
![alt text](image-4.png)


### ASYNC
![alt text](image-5.png)

-- We need to decide based on trade offs which could be best fit for the situation


