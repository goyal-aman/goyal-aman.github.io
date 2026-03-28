+++
title = "Leader Election: Ensuring a Single Owner in a Distributed System"
date = "2026-02-14"
description = "How distributed systems implement leader election and ownership using compare-and-swap, TTL-based locks, and versioning over key-value stores like etcd to safely handle failures and race conditions."
tags = ['Distributed Systems', 'System Design', 'Leader Election', 'etcd', 'Distributed Locks', 'Consensus']
+++

##  Core Concept

- **Ownership / Leader election = only one replica owns a task at a time**
- Needed for:
    - Scheduling
    - Shard ownership
    - Background jobs
- Implemented via:
    - **Distributed locks over KV stores (etcd, ZooKeeper, Consul)**

---

##  Do You Even Need Leader Election?

- **Singleton approach**
    -  Simple
    -  Downtime during failures or deploys

 Use leader election only when:

- You need **high availability (4+ nines)**

---

##  Core Primitive: Compare-And-Swap

```go
lock := sync.Mutex{}
store := map[string]string{}

func compareAndSwap(key, nextValue, currentValue string) (bool, error) {
  lock.Lock()
  defer lock.Unlock()
  _, containsKey := store[key]
  if !containsKey {
    if len(currentValue) == 0 {
      store[key] = nextValue
      return true, nil
    }
    return false, fmt.Errorf(
      "Expected value %s for key %s, but found empty", currentValue, key)
  }
  if store[key] == currentValue {
    store[key] = nextValue
    return true, nil
  }
  return false, nil
}
```

 Foundation of distributed locking

---

##  Basic Lock

### Acquire

```go
func (Lock l) simpleLock() boolean {
  // compare and swap "1" for "0"
  locked, _ = compareAndSwap(l.lockName, "1", "0")
  return locked
}
```

---

### Handle missing key

```go
func (Lock l) simpleLock() boolean {
  // compare and swap "1" for "0"
  locked, error = compareAndSwap(l.lockName, "1", "0")
  // lock doesn't exist, try to write "1" with a previous value of
  // non-existent
  if error != nil {
    locked, _ = compareAndSwap(l.lockName, "1", nil)
  }
  return locked
}
```

---

### Blocking lock

```go
func (Lock l) lock() {
  while (!l.simpleLock()) {
    sleep(2)
  }
}
```

---

### Event-based (better)

```go
func (Lock l) lock() {
  while (!l.simpleLock()) {
    waitForChanges(l.lockName)
  }
}
```

---

### Unlock

```go
func (Lock l) unlock() {
  compareAndSwap(l.lockName, "0", "1")
}
```

---

##  Problem: Crash While Holding Lock

 Lock never released → system stuck

---

## ⏳ Solution: TTL-based Lock

```go
func (Lock l) simpleLock() boolean {
  // compare and swap "1" for "0"
  locked, error = compareAndSwap(l.lockName, "1", "0", l.ttl)
  // lock doesn't exist, try to write "1" with a previous value of
  // non-existent
  if error != nil {
    locked, _ = compareAndSwap(l.lockName, "1", nil, l.ttl)
  }
  return locked
}
```

 Lock auto-expires

---

##  Critical Bug (TTL + Unlock)

- Old owner may unlock **new owner's lock**

---

##  Fix: Resource Version

### Lock with version

```go
func (Lock l) simpleLock() boolean {
  // compare and swap "1" for "0"
  locked, l.version, error = compareAndSwap(l.lockName, "1", "0", l.ttl)
  // lock doesn't exist, try to write "1" with a previous value of
  // non-existent
  if error != null {
    locked, l.version, _ = compareAndSwap(l.lockName, "1", null, l.ttl)
  }
  return locked
}
```

---

### Safe unlock

```go
func (Lock l) unlock() {
  compareAndSwap(l.lockName, "0", "1", l.version)
}
```

 Prevents unlocking someone else's lock

---

##  Renewable Lock (Leader Election)

```go
func (Lock l) renew() boolean {
  locked, _ = compareAndSwap(l.lockName, "1", "1", l.version, ttl)
  return locked
}
```

---

### Renewal loop

```go
for {
  if !l.renew() {
    handleLockLost()
  }
  sleep(ttl/2)
}
```

 Leader keeps renewing lease

---

##  etcd Example

### Create lock

```bash
kubectl exec my-etcd-cluster-0000 -- sh -c \
  "ETCD_API=3 etcdctl --endpoints=${ETCD_ENDPOINTS} set my-lock unlocked"
```

---

### Acquire lock

```bash
kubectl exec my-etcd-cluster-0000 -- sh -c \
  "ETCD_API=3 etcdctl --endpoints=${ETCD_ENDPOINTS} \
      set --swap-with-value unlocked my-lock alice"
```

---

### Failed acquisition

```bash
kubectl exec my-etcd-cluster-0000 -- sh -c \
  "ETCD_API=3 etcdctl --endpoints=${ETCD_ENDPOINTS} \
      set --swap-with-value unlocked my-lock bob"
Error:  101: Compare failed ([unlocked != alice]) [6]
```

---

### Release lock

```bash
kubectl exec my-etcd-cluster-0000 -- sh -c \
  "ETCD_API=3 etcdctl --endpoints=${ETCD_ENDPOINTS} \
      set --swap-with-value alice my-lock unlocked"
```

---

##  Lease-based Lock (etcd)

```bash
kubectl exec my-etcd-cluster-0000 -- \
    sh -c "ETCD_API=3 etcdctl --endpoints=${ETCD_ENDPOINTS} \
        --ttl=10 mk my-lock alice"
```

---

### Renew lease

```bash
kubectl exec my-etcd-cluster-0000 -- \
    sh -c "ETCD_API=3 etcdctl --endpoints=${ETCD_ENDPOINTS} \
        set --ttl=10 --swap-with-value alice my-lock alice"
```

---

##  Advanced Problem: Dual Leaders

 Temporary overlap can happen

---

### Check before acting

```go
func (Lock l) isLocked() boolean {
  return l.locked && l.lockTime + 0.75 * l.ttl > now()
}
```

---

##  Final Insights

- Distributed locks are **hard and subtle**
- Always handle:
    - Crashes
    - Expiry
    - Network delays
- Always verify:
    - Leader identity
    - Version

---

##  Final Trade-off

- **At-most-once**
    - Strong consistency
    - Lower availability
- **At-least-once**
    - Higher availability
    - Possible duplicates

---

##  One-line Summary

> **Leader election uses distributed locks (CAS + TTL + versioning) to ensure a single owner in a distributed system while handling failures and race conditions.**
> 
