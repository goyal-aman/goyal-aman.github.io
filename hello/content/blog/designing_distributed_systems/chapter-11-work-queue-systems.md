+++
title = "Work Queue Systems: Scalable Batch Processing with Independent Tasks"
date = "2026-02-21"
description = "How work queue systems process independent tasks at scale using a generic queue manager, pluggable sources, and worker containers, with Kubernetes Jobs providing built-in reliability."
tags = ['Distributed Systems', 'System Design', 'Work Queues', 'Batch Processing', 'Kubernetes']
+++

##  Core Concept

- **Work queue = batch processing pattern**
- Work is:
    - Broken into **independent tasks**
    - Processed by **workers in parallel**
- Goal:
    - Process all items within acceptable time

---

##  Architecture Overview

- Three main components:
    1. **Work Queue Manager** (generic logic)
    2. **Source (Ambassador)** → provides work items
    3. **Worker** → processes each item

 Strong separation:

- Infra = reusable
- Business logic = pluggable

---

##  Two Key Interfaces

---

### 1. Source Interface (HTTP)

```
GET http://localhost/api/v1/items
GET http://localhost/api/v1/items/<item-name>
```

---

### Response format

```json
{
   kind: ItemList,
   apiVersion: v1,
   items: [
      "item-1",
      "item-2"
   ]
}
```

---

 Important:

- Source only **provides data**
- Queue manager tracks **state (processed/not)**

---

### 2. Worker Interface (File-based)

- Worker gets input via:
    - `WORK_ITEM_FILE`
- No HTTP server needed

 Simpler + more secure

---

##  Core Work Queue Algorithm

```
Repeat forever
    Get items from source
    Get current jobs
    Find unprocessed items
    Create jobs for them
```

---

##  Full Work Queue Implementation (Python)

```python
import requests
import json
from kubernetes import client, config
import time

namespace = "default"

def make_container(item, obj):
    container = client.V1Container()
    container.image = "my/worker-image"
    container.name = "worker"
    return container

def make_job(item):
    response = requests.get("http://localhost:8000/items/{}".format(item))
    obj = json.loads(response.text)
    job = client.V1Job()
    job.metadata = client.V1ObjectMeta()
    job.metadata.name = item
    job.spec = client.V1JobSpec()
    job.spec.template = client.V1PodTemplate()
    job.spec.template.spec = client.V1PodTemplateSpec()
    job.spec.template.spec.restart_policy = "Never"
    job.spec.template.spec.containers = [
        make_container(item, obj)
    ]
    return job

def update_queue(batch):
    response = requests.get("http://localhost:8000/items")

    obj = json.loads(response.text)
    items = obj['items']

    ret = batch.list_namespaced_job(namespace, watch=False)

    for item in items:
        found = False
        for i in ret.items:
            if i.metadata.name == item:
                found = True
        if not found:
            job = make_job(item)
            batch.create_namespaced_job(namespace, job)

config.load_kube_config()
batch = client.BatchV1Api()

while True:
    update_queue(batch)
    time.sleep(10)
```

 Key idea:

- **Kubernetes Jobs handle reliability**
- Queue manager only orchestrates

---

##  Example: Source Container (Node.js)

```jsx
const http = require('http');
const fs = require('fs');

const port = 8080;
const path = process.env.MEDIA_PATH;

const requestHandler = (request, response) => {
	console.log(request.url);
	fs.readdir(path + '/*.mp4', (err, items) => {
		var msg = {
			'kind': 'ItemList',
			'apiVersion': 'v1',
			'items': []
		};
		if (!items) {
			return msg;
		}
		for (var i = 0; i < items.length; i++) {
			msg.items.push(items[i]);
		}
		response.end(JSON.stringify(msg));
	});
}

const server = http.createServer(requestHandler);

server.listen(port, (err) => {
	if (err) {
		return console.log('Error starting server', err);
	}

	console.log(`server is active on ${port}`)
});
```

 Lists work items (videos)

---

##  Example: Worker (ffmpeg)

```bash
ffmpeg -i ${INPUT_FILE} -frames:v 100 thumb.png
```

 Processes each item independently

---

##  Scaling Insights

### Key Metrics:

- **Interarrival time** (rate of new tasks)
- **Processing time** (latency per task)

---

### Rule:

> Processing time / parallelism < interarrival time
> 

---

### Cases:

-  Faster processing → system catches up
-  Equal → fragile system
-  Slower → backlog grows forever

---

##  Scaling Strategies

- Limit number of workers → control cost
- Increase parallelism → reduce backlog
- Use tools like:
    - **KEDA (event-driven autoscaling)**

---

##  Multiworker Pattern

- Combine multiple worker containers into one pipeline

Example:

- Detect faces → tag → blur

 Benefits:

- Reuse components
- Compose workflows

---

##  Key Insights

- Work queue = **decouple ingestion from processing**
- Kubernetes Jobs = **built-in reliability**
- System is:
    - Modular
    - Reusable
    - Scalable

---

##  Trade-offs

### Pros

- Scales easily
- Fault-tolerant
- Reusable architecture

### Cons

- Increased system complexity
- Queue lag under heavy load
- Requires careful scaling

---

##  One-line Summary

> **Work queues process independent tasks using scalable workers, with a generic queue manager orchestrating jobs and ensuring reliable execution.**
> 
