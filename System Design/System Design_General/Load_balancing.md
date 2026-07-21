1. Load Balancing

    - Consistent Hasinging
    - Round Roubbin
    - Hash function to go to a server

Problems with load balancing:-

 - If we use use example 5 server and if we see we have lots of trafic now we need to add more server.
 - While adding new server, Let's say if we use some caching in previous servers these are no longer useful.
    - As we add new server total is 10 then it sends request in randmo order and we have a performance impact.
    - similarly when we have less traffic we need to remove the extra servers in this cases also our caching mechanism will be ruined.

To handle this issue we need consisten hashing.

