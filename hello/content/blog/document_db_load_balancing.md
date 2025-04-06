+++
title = "DocumentDB Load Balancing: A Key Learning from Our Load Testing"
date = "2025-03-26"
description = "Amazon DocumentDB load-balances traffic at the TCP connection level rather than at the request level. This can lead to unexpected resource distribution issues, particularly when scaling read replicas under high load. The solution? Restarting application pods to establish new TCP connections that are evenly distributed across replicas."
tags = [
    "DocumentDB",
    "Load Balancing",
    "AWS",
]
+++
---

# TL;DR
Amazon DocumentDB load-balances traffic at the TCP connection level rather than at the request level. This can lead to unexpected resource distribution issues, particularly when scaling read replicas under high load. The solution? Restarting application pods to establish new TCP connections that are evenly distributed across replicas.

# Understanding the Load Balancing Issue
In a typical Amazon DocumentDB cluster, there is a primary node that handles all write operations and one or more read replicas to distribute read traffic. During our load testing, we observed that a single read replica was hitting over 90% CPU utilization due to high read requests.

To handle the increased load, we added another read replica to the cluster, expecting the load to distribute between the two replicas. However, the new replica remained underutilized, while the old read replica continued to handle most of the traffic.

# Why Did This Happen?
DocumentDB does not balance traffic at the request level but rather at the TCP connection level. When a TCP connection is established, DocumentDB’s load balancer assigns it to one of the available nodes. Once a connection is created, all queries over that connection go to the same node. Since our existing connections were already mapped to the first read replica, the new read replica was not receiving any requests.

#The Solution: Restarting Application Pods
The only effective way to distribute traffic across the newly added read replica was to restart our application pods. By doing this, we forced our application to establish new TCP connections, which were then distributed across both read replicas, balancing the load more effectively.

# Key Takeaways:
DocumentDB load-balances at the TCP connection level, not per request.
Adding a new read replica does not automatically redistribute traffic.
To ensure proper load distribution, restart application pods to establish new TCP connections.