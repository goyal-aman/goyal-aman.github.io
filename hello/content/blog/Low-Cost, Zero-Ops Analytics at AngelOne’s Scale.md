+++
title = "Low-Cost, Zero-Ops Analytics at AngelOne’s Scale"
date = "2025-10-01"
description = "A small team developed a low-cost, zero-ops analytics pipeline on AWS that delivers full user journey visibility at scale built in a week, running ever since."
tags = [
    "AWS",
    "Lambda",
    "Firehose",
    "AWS Firehose",
    "AWS MSK",
    "MSK",
    "Analytics",
    "S3",
    "AWS S3",
    "Athena",
    "AWS Athena",
    "QuickSight",
    "AWS QuickSight",
    "One Page Later Pod"
]

+++
---

One of the early challenges our product teams had was visibility — not having a clear view of how users interact with our product or what their experience looks like. This made it hard for them to plan what to improve next.

We’re a small, independent team inside Angel One exploring new initiatives and moving fast. While we operate autonomously, all security standards and org-level policies still apply to us. This means we get the freedom to experiment, but the solution has to be secure and compliant from day one.

With a small team, a growing backlog, and limited bandwidth, we needed something simple and self-sustaining not another system to maintain. Our requirements were clear:
1. Give visibility into user journeys (our core need)
2. Require almost zero maintenance. We don’t have the bandwidth to manage infra
3. Avoid new third-party vendors (since onboarding one takes months)
4. Keep costs low, focus on impact, not infrastructure

# Finding the Right Fit
We looked at Apache Flink and Apache Spark — both powerful, both capable of solving the problem. But managed versions were expensive, and self-hosting meant dedicating bandwidth for maintenance and handling failures which is not ideal for our team size or priorities.

We parked them as “maybe later” and kept searching. That’s when we came across AWS Firehose (Kinesis Data Firehose).

# AWS Firehose + Athena — The Simpler Route
Firehose can take streaming data from multiple sources, do lightweight transformations, and push it directly to S3 — fully managed, no servers, no ops. Around the same time, we explored Amazon Athena, a serverless SQL engine that lets you query data in S3 using plain SQL.
This combination made perfect sense for us. Our clickstream data was already flowing into Amazon MSK (Managed Kafka from AWS). From there, we connected Firehose to send data into S3. AWS Glue managed schemas, and Athena enabled product teams to run SQL queries directly on the data.

This setup checked all boxes:
* Product teams could query data easily via Athena
* The entire pipeline was fully managed by AWS — zero ops
* No third-party vendors involved
* Cost remained low — we already had MSK and S3, and Athena charges only per query

# The Outcome
The pipeline handled ~300K events per second, consistently and without manual intervention. We tested and deployed it in just under few days, and by the end, it was already helping product teams answer key questions.

A week later, we integrated dashboards using Amazon QuickSight, giving everyone instant visibility into user journeys and metrics, again, without additional maintenance.

# 6 Months Later
It’s been over six months since launch. Our traffic has grown by more than 100%, and the same setup continues to work smoothly with zero human hours spent on maintenance.

Given its stability, low cost, and scalability, this solution can easily support our growth for the next few years.

# In Short
We wanted something low-cost, reliable, and simple  and we got exactly that. Using MSK, Firehose, S3, Glue, Athena, and QuickSight, we built a fully managed, zero-ops analytics pipeline that provides complete visibility into user behavior.

It’s secure, compliant, scales effortlessly — and has required no ongoing maintenance since day one.
