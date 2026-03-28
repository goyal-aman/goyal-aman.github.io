+++
title = "Scatter/Gather: Reducing Latency with Parallel Distributed Processing"
date = "2026-01-31"
description = "How the Scatter/Gather pattern distributes a request across multiple nodes for parallel processing and aggregates the results, dramatically reducing latency for compute-heavy workloads."
tags = ['Distributed Systems', 'System Design', 'Scatter Gather', 'Parallelism', 'Latency']
+++

##  Core Concept

- **Scatter/Gather = parallel processing pattern**
- Request is:
    - **Scattered** → sent to multiple nodes
    - **Gathered** → results combined into one response
- Goal: **reduce latency (faster responses)**

---

##  What It Solves

- Previous patterns:
    - Replication → scale requests
    - Sharding → scale data
- **Scatter/Gather → scale computation speed (time)**

---

##  How It Works

```
[ Client ]
     ↓
[ Root / Coordinator ]
     ↓↓↓
[ Leaf 1 ] [ Leaf 2 ] [ Leaf 3 ]
     ↓↓↓
[ Partial results ]
     ↓
[ Root combines → Final result ]
```

- Each leaf does **partial work**
- Root merges results and returns response

---

##  When to Use

- Problems that are:
    - **Independent**
    - **Parallelizable**
- Example:
    - Search queries
    - Data aggregation
    - Analytics

 Also called **"embarrassingly parallel" problems**

---

##  Two Variants

### 1. Pure Scatter/Gather (replicated data)

- All nodes have same data
- Work is split across nodes

---

### 2. Sharded Scatter/Gather

- Data is partitioned across nodes
- Request sent to **all shards**
- Each shard processes its own data
- Root combines results

 Used for:

- Large search systems
- Big datasets

---

##  Key Challenges

### 1. Diminishing returns (overhead)

- More nodes = more:
    - Network cost
    - Coordination cost

 Beyond a point → performance stops improving

---

### 2. Straggler problem (VERY IMPORTANT)

- Response time = **slowest node**
- Even one slow node delays entire response

 More nodes → higher chance of slowdown

---

### 3. Reliability issues

- If one node fails:
    - Entire request may fail
- More nodes → higher failure probability

---

##  Solutions

### 1. Replicate each shard

- Instead of 1 node per shard → multiple replicas
- Benefits:
    - Fault tolerance
    - Load balancing
    - Safe deployments

---

### 2. Smart scaling

- Don't blindly increase nodes
- Balance:
    - Parallelism vs overhead

---

##  Key Insights

- Parallelism ≠ always faster
- Tail latency (99th percentile) matters more
- System speed depends on **slowest component**

---

##  Trade-offs

### Pros

- Faster response times
- Scales compute-heavy workloads
- Efficient for parallel tasks

### Cons

- Complex coordination
- Sensitive to slow nodes
- Higher failure probability
- Network overhead

---

##  One-line Summary

> **Scatter/Gather distributes a request across multiple nodes for parallel processing and combines results to reduce latency, but performance is limited by overhead and the slowest node.**
> 
