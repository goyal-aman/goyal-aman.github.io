+++
title = "Understanding Constants in Go: Typed vs. Untyped (Kinds)"
date = "2025-11-18"
description = "Quick note on go constants"
tags = [
    "Database",
    "OLAP",
    "OLTP",
    "Analytics"
]
images = ["/images/type_literal.svg"]
cover = "/images/type_literal.svg"
+++
---

​# Understanding Constants in Go: Typed vs. Untyped (Kinds)

​In Go, constants are immutable values evaluated entirely at compile time. A crucial concept for moving from beginner to intermediate Go programmer is understanding the difference between *typed* and *untyped* constants.

​## 1. Untyped Constants (The Default "Kind")

​By default, any constant you declare without an explicit type is **untyped**. These constants don't adhere to Go's strict type system initially; instead, they possess a generic classification known as a **"kind"** (e.g., `untyped integer`, `untyped float`, `untyped string`).

​The primary benefits are **arbitrary precision** and **flexibility**:

​*   **Arbitrary Precision:** Untyped numeric constants are calculated with very high precision (at least 256 bits) during compilation. They do not overflow until assigned to a variable of limited precision.
​*   **Flexibility (Implicit Conversion):** An untyped constant can be used wherever a concrete type is expected, as long as the value fits. The compiler implicitly converts it to the required type.

​```go
​const SpeedOfLight = 299792458 // Untyped integer kind

​func main() {
​	var i int = SpeedOfLight
​	var i32 int32 = SpeedOfLight   // OK: Value fits in int32
​	var f64 float64 = SpeedOfLight // OK: Value fits in float64
​}
​```
​## Typed Constants

​A constant becomes  **typed**  when you explicitly assign a type during its declaration. Typed constants are strictly bound by the Go type system rules from the moment they are declared.

​-   **Strict Typing:**  They follow the same rigorous type-matching rules as variables.
​-   **Requires Explicit Conversion:**  You cannot use a typed constant with a variable of a different type without an explicit cast.
​```go
​const TypedSpeed int = 299792458 // Now has type 'int'

​func main() {
​	var i int = TypedSpeed         // OK
​	// var i32 int32 = TypedSpeed  // ERROR: Cannot use type 'int' as type 'int32'
​	var i32 int32 = int32(TypedSpeed) // OK: Explicit conversion required
​}
​```
​## Summary for Advanced Usage

​The "untyped constant kind" is a powerful language feature that simplifies numeric code. It allows you to define universal numeric values (like 𝜋 or physical constants) that can be reused across different numeric types (`float32`, `float64`, `int`, etc.) without type errors or messy conversions.

​-   **Use untyped constants by default** for maximum flexibility.
​-   **Use typed constants** only when you need to enforce strict type checking immediately, often when creating constants of a custom type (`type MyInt int; const M MyInt = 1`).