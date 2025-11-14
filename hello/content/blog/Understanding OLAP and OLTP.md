+++
title = "Understanding OLAP and OLTP"
date = "2024-12-23"
description = "Any database falls into one of two category OLAP or OLTP — depending on the access pattern for which it is optimised"
tags = [
    "Database",
    "OLAP",
    "OLTP",
    "Analytics"
]
images = ["/images/olap_vs_olt.png"]
cover = "/images/olap_vs_olt.png"
+++
---

# TLDR; 
Any database falls into one of two category OLAP or OLTP — depending on the access pattern for which it is optimised

# Key differences: OLAP vs. OLTP
The primary purpose of online analytical processing (OLAP) is to analyse aggregated data, while the primary purpose of online transaction processing (OLTP) is to process database transactions.

You use OLAP systems to generate reports, perform complex data analysis, and identify trends. In contrast, you use OLTP systems to process orders, update inventory, and manage customer accounts.

Other major differences include data formatting, data architecture, performance, and requirements. We’ll also discuss an example of when an organization might use OLAP or OLTP.

Loosely speaking, database uses can be broadly categories into two types

Real time database has large number of transactions which have short life spans (generally in order of Ms) such as

* add contact in contact's table
* updating inventory in inventory table
* deleting comments
* getting post for user

Analytical databases have large queries over huge datasets where transactions have large life spans and have uses like

* aggregating dataset of multiple columns
* reporting
Database systems which are optimised for real time uses are OLTP and databases which are used for purpose for analytics, reporting are OLAP

# Summary

sources: https://aws.amazon.com/compare/the-difference-between-olap-and-oltp/

