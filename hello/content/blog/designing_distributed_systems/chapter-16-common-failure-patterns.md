+++
title = "Common Failure Patterns in Distributed Systems: What Not to Do"
date = "2026-03-28"
description = "A catalog of the most common failure patterns in distributed systems—from thundering herds and hidden errors to catastrophic cleanups and the second system problem—and how to prevent them."
tags = ['Distributed Systems', 'System Design', 'Reliability', 'Failure Patterns', 'Resilience', 'Circuit Breaker']
+++

##  Core Idea

- This chapter is about **what NOT to do**
- Distributed systems fail in **predictable patterns**
- Learn them → **prevent repeated mistakes**

---

##  Major Failure Patterns

---

### 1. Thundering Herd (VERY IMPORTANT)

#### What happens:

- System overload → failures
- Clients retry → even more load
- Load amplifies exponentially

 Example:

- X requests → fail → retries → 2X → 4X → crash

---

#### Solutions:

- **Exponential backoff**
- **Jitter** (random delay)
- **Circuit breaker**
- Gradual recovery (don't flood system)

---

### 2. "No Errors" Is Also an Error

#### Problem:

- Zero errors ≠ healthy system

 Example:

- System stops receiving requests
- No errors → but system is broken

---

#### Fix:

- Alert on:
    - Too many errors
    - Too few errors / requests

---

### 3. Ignoring "Client Errors"

#### Problem:

- Treating errors as:
    - "user fault"
    - "expected"

 Can hide real bugs

---

#### Example:

- All users suddenly unauthorized
    
    → system bug, not client issue
    

---

#### Fix:

- Monitor **patterns & anomalies**, not just categories
- Use **synthetic requests** (controlled inputs)

---

### 4. Versioning Mistakes

#### Problem:

- Tight coupling:
    - API ↔ internal ↔ storage

 Hard to:

- Upgrade
- Rollback

---

#### Best Practice:

- Separate:
    - External API version
    - Internal representation
    - Storage version

 Add translation layers

---

### 5. "Optional" Components Become Critical

#### Problem:

- Add cache as optional
- Over time → system depends on it

 Cache failure = system failure

---

#### Fix:

- Treat "optional" components as **first-class citizens**
- Design for:
    - Reliability
    - Scalability

---

### 6. Catastrophic Cleanup ("Deleted Everything")

#### What happens:

- Small bug → system-wide deletion

---

#### Example:

- DB failure → user lookup returns "not found"
- GC deletes all data

---

#### Root causes:

- Wrong error handling
- No safeguards

---

#### Fix:

- **Rate limiting**
- **Circuit breakers**
- Defensive design (assume failures)

---

### 7. Input Space Explosion (Edge Cases)

#### Problem:

- Huge input space → untested cases
- Some users always fail

---

#### Fix:

- Test with:
    - Real production inputs
    - Fuzzing (random inputs)

---

### 8. Processing Obsolete Work

#### Problem:

- System slow → users retry
- Old requests still processed
- Wastes resources

---

#### Fix:

- **Timeouts**
- **Autoscaling on latency**
- **Prioritize newer requests**

---

### 9. Backlog After Recovery

#### Problem:

- System recovers → but backlog remains
- Causes long latency

---

#### Fix:

- Scale up temporarily
- Clear backlog faster

---

### 10. "Second System" Problem (VERY IMPORTANT)

#### Problem:

- Rebuild system from scratch
- New system:
    - Always behind
    - Never production-ready

---

#### Why it fails:

- Old system keeps evolving
- New system lacks real usage

---

#### Better approach:

- Incremental improvements
- Replace **parts**, not whole system

---

##  Key Insights

- Failures are often:
    - Amplified (retries, cascades)
    - Hidden (wrong metrics)
    - Human-triggered (bad assumptions)

---

- Design for:
    - **Failure prevention**
    - **Fast recovery**

---

##  Core Principles

- Expect:
    - Retries
    - Crashes
    - Bad inputs
- Always ask:

> "What happens when this fails?"
> 

---

##  One-line Summary

> **Distributed systems commonly fail due to retries, hidden errors, bad assumptions, and poor safeguards—robust systems anticipate these patterns and design for failure and recovery.**
> 
