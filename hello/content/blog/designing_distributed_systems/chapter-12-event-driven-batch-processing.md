+++
title = "Event-Driven Batch Processing: Building Scalable Workflow Pipelines"
date = "2026-02-28"
description = "How to extend work queues into full event-driven DAG workflows using patterns like copier, filter, splitter, sharder, and merger, connected through pub/sub systems like Kafka."
tags = ['Distributed Systems', 'System Design', 'Event-Driven', 'Batch Processing', 'Kafka', 'Workflows']
+++

##  Core Concept

- Extend work queues into **workflows (DAGs)**
- Output of one stage → input to next stage
- Entire system becomes **event-driven pipeline**

 Think:

> **Multiple work queues connected together by events**
> 

---

##  Why This Pattern Exists

- Work queues (Chapter 11) → 1 input → 1 output
- Real systems:
    - Multiple outputs
    - Multiple steps
    - Parallel + conditional flows

 Need **workflow orchestration**

---

##  Core Patterns

---

### 1. Copier

- Duplicate work into multiple queues

Use case:

- Video → multiple formats (4K, 1080p, GIF)

 Also improves:

- Reliability (run twice)
- Latency (take fastest result)

---

### 2. Filter

- Remove unwanted items

Example:

- Only users who opted for email

 Implemented as:

- Adapter over source

---

### 3. Splitter

- Route items to different queues (no loss)

Example:

- Email vs SMS notifications

 Like:

- Conditional routing

---

### 4. Sharder

- Distribute work evenly across queues

Benefits:

- Scalability
- Fault isolation
- Multi-region distribution

 Same idea as service sharding

---

### 5. Merger

- Combine multiple queues → one queue

Example:

- Multiple repos → single build pipeline

 Opposite of copier

---

##  Workflow Mental Model

```
Input → [Copy] → [Parallel queues] → [Filter/Split] → [Merge] → Output
```

 DAG (Directed Acyclic Graph)

---

##  Pub/Sub is the Backbone

- Use systems like:
    - Kafka
    - SQS
    - EventGrid

 Provides:

- Reliable message delivery
- Decoupling between stages

---

##  Kafka Setup (Exact Commands)

### Create topics

```bash
for x in 0 1 2; do
  kubectl run kafka --image=solsson/kafka:0.11.0.0 --rm --attach --command -- \
    ./bin/kafka-topics.sh --create --zookeeper kafka-service-zookeeper:2181 \
      --replication-factor 3 --partitions 10 --topic photos-$x
done
```

---

### Produce messages

```bash
kubectl run kafka-producer --image=solsson/kafka:0.11.0.0 --rm -it --command -- \
    ./bin/kafka-console-producer.sh --broker-list kafka-service-kafka:9092 \
    --topic photos-1
```

---

### Consume messages

```bash
kubectl run kafka-consumer --image=solsson/kafka:0.11.0.0 --rm -it --command -- \
    ./bin/kafka-console-consumer.sh --bootstrap-server kafka-service-kafka:9092\
    --topic photos-1 \
        --from-beginning
```

---

##  Real Example: User Signup Workflow

Flow:

1. User signup → verification email
2. After verification:
    - Copier → welcome email + notifications
3. Notifications:
    - Filter → email/SMS preferences

 Combines:

- Copier
- Filter
- Sharder

---

##  Real-World Problems

---

### 1. Uneven Work (Stragglers)

 Solution: **Work Stealing**

- Idle worker → steals from longest queue

---

### 2. Worker Failures

- Work is retried automatically

 Must ensure:

- **Idempotent processing**

---

### 3. Poison Messages

- Some tasks always fail → crash workers

 Solution:

- Retry count
- Exponential backoff
- Eventually drop task

---

### 4. Backlog Problem

- Old tasks pile up → new tasks delayed

 Solution: **Priority queues**

- New work → high priority
- Retry work → lower priority

---

##  Key Insights

- Workflows = **composition of simple patterns**
- Pub/Sub = **decoupling glue**
- System must handle:
    - Failures
    - Slow tasks
    - Backlogs

---

##  Trade-offs

### Pros

- Highly scalable
- Modular
- Flexible workflows
- Fault tolerant

### Cons

- Complex to reason about
- Debugging is hard
- Requires strong monitoring

---

##  One-line Summary

> **Event-driven batch systems connect multiple work queues into workflows using patterns like copier, filter, splitter, sharder, and merger, enabling scalable and reliable data processing pipelines.**
> 
