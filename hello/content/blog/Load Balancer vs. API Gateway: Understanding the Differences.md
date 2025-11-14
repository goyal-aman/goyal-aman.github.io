+++
title = "Load Balancer vs. API Gateway: Understanding the Differences"
date = "2024-12-16"
description = "API Gateway can provide caching, logging auth and load balancer distributes traffic between 2 or more servers for high-availability and horizontal scaling"
tags = [
    "Load Balancer",
    "API Gateway",
    "Network"
]
images = ["/images/api_gateway_and_load_balancer.png"]
cover = "/images/api_gateway_and_load_balancer.png"
+++
---

# TLDR; 
API Gateway can provide caching, logging auth and load balancer distributes traffic between 2 or more servers for high-availability and horizontal scaling.

Both load balancer and Api gateways are used between web clients and web servers. But they have served different purpose, that is to say, they are not interchangeable.

# Load Balancers
![load-balancer](/images/load_balancer.png)
Core function of load balancer is to distribute traffic. They receive traffic from web client’s and distribute them between 2 or more web servers.


When the volume of requests increase and one server is not enough to handle the traffic, more servers are added to distribute the load. All web clients send request to load balancer and load balancer distributes traffic to 2 or more web servers. Most common algorithm to distribute traffic between web servers is round robin. By adding more servers during increased traffic load balancers help to achieve horizontal scaling.

It also happens from time to time that web servers can get into some trouble which prevent them from serving traffic. This can be because hardware or software reasons. When that happens, load balancer directs any future traffic away from web server which is experiencing problem. In this way, load balancer helps to achieve high availability.

# API Gateway
![load-balancer](/images/api_gateway.png)
Web clients often need to interact with more than 1 service, for example, YouTube may need to interact with trending-videos service, notification-service, upload-service. Core function of API gateway is to provide a single-entry point for all the different services. API Gateway looks at the request from web client and forwards it to appropriate service, this is called routing


In addition, API Gateway also provides additional features

# Brining it together
![load-balancer](/images/api_gateway_and_load_balancer.png)
Load balancers and API Gateway have different use and purpose. They can be used together to combine their features.
API Gateway can provide caching, logging auth and load balancer distributes traffic between 2 or more servers for high-availability and horizontal scaling.


source: https://deploy.equinix.com/blog/how-api-gateways-differ-from-load-balancers-and-which-to-use/