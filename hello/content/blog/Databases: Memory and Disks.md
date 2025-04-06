+++
title = "Databases: Memory and Disks"
date = "2024-12-02"
description = "Database is io bottlenecked?"
tags = [
    "Database",
    "Disk",
    "Memory"
]
cover = "/images/database_disk_and_memory.png"
+++
---

Most databases rely on disks and SSD’s to store both data and data structures like table, rows, indexes. There are primarily two reasons for this: disk’s and SSD’s are persistent (or durable) that means data is not lost in case of power loss and they are much cheaper than ram for per Gb cost. Relying on persistent storage devices though comes with challenges. Data in memory needs to be encoded into certain format before it can be written on to them which is slow and CPU intensive.

There is emerging set of new databases that rely on memory serve read and writes. Memcached is a key-value store, which solely uses ram. It is intended for caching purposes where data loss is acceptable. There are certain in-memory databases which provide durability guarantees to some degree. Durability guarantees is result of maintaining a write ahead log for writes that happen on database and making periodic snapshots, in case of power loss or crash, state of database can be restored from previous snapshot and redoing writes from write ahead log. In-memory stores like reddis provides weak durability guarantees by maintaining snapshots at every seconds, in case of power loss or crash writes that happened after last snapshots are lost.

In-memory databases are also capable of providing data structure which are not easily implemented in disk-based databases. Redis, for example, provides sorted-set, priority queue, set, list etc.

Contrary to popular belief, the performance of in-memory databases is not entirely attributed to the fact that writes/reads on disk-based storage is slow. It is possible that disk-based databases never read from disk if memory is large enough. This happens because OS caches the recently used pages and serves pages from cache. The advantage of in-memory databases comes from the fact that they do not need to encode and decode data structures into formats compatible with disk storage before writing.