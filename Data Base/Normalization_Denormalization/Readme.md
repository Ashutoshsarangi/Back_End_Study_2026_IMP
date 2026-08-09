# Database Normalization Explained

Normalization is the process of organizing data in a relational database to **reduce redundancy** and **avoid update anomalies** (insert, update, delete problems). Denormalization is the deliberate reversal of that process for performance or simplicity.

---

## Core Idea

| Concept | Goal | Trade-off |
|---------|------|-----------|
| **Normalization** | Split data into related tables; each fact stored once | More joins, cleaner writes |
| **Denormalization** | Combine tables / duplicate data | Faster reads, risk of inconsistency |

---

## Before Normalization: A Bad Table

**StudentCourses** (violates almost everything):

| StudentID | StudentName | CourseID | CourseName | Instructor | Grade |
|-----------|-------------|----------|------------|------------|-------|
| 101 | Alice | C01 | DB Systems | Dr. Smith | A |
| 101 | Alice | C02 | Algorithms | Dr. Jones | B |
| 102 | Bob | C01 | DB Systems | Dr. Smith | A |

Problems:
- **Redundancy**: "Alice", "DB Systems", "Dr. Smith" repeat
- **Update anomaly**: Change Dr. Smith → must update many rows
- **Insert anomaly**: Can't add a course with no students
- **Delete anomaly**: Delete Bob's only row → lose course info if it was stored only there

---

## 1NF — First Normal Form

**Rule:** Each column holds **atomic (indivisible)** values; no repeating groups; each row is unique.

### Violation

| OrderID | Customer | Items |
|---------|----------|-------|
| 1 | Alice | Laptop, Mouse, Keyboard |

`Items` is not atomic (multi-valued).

### Fix (1NF)

| OrderID | Customer | Item |
|---------|----------|------|
| 1 | Alice | Laptop |
| 1 | Alice | Mouse |
| 1 | Alice | Keyboard |

Or use a separate **OrderItems** table:

| OrderID | Item |
|---------|------|
| 1 | Laptop |
| 1 | Mouse |

**1NF checklist:** One value per cell, no arrays/lists in a column, unique rows.

---

## 2NF — Second Normal Form

**Rule:** Must be in **1NF**, and every non-key column must depend on the **whole** primary key (no partial dependency).

Applies when the primary key is **composite** (multiple columns).

### Violation

PK = `(StudentID, CourseID)`

| StudentID | CourseID | StudentName | CourseName | Grade |
|-----------|----------|-------------|------------|-------|
| 101 | C01 | Alice | DB Systems | A |

- `StudentName` depends only on `StudentID` (partial dependency)
- `CourseName` depends only on `CourseID` (partial dependency)
- Only `Grade` depends on the full key `(StudentID, CourseID)`

### Fix (2NF)

**Students**

| StudentID | StudentName |
|-----------|-------------|
| 101 | Alice |

**Courses**

| CourseID | CourseName |
|----------|------------|
| C01 | DB Systems |

**Enrollments** (PK: StudentID + CourseID)

| StudentID | CourseID | Grade |
|-----------|----------|-------|
| 101 | C01 | A |

---

## 3NF — Third Normal Form

**Rule:** Must be in **2NF**, and no non-key column depends on **another non-key column** (no transitive dependency).

### Violation

PK = `EmployeeID`

| EmployeeID | DeptID | DeptName | Salary |
|------------|--------|----------|--------|
| E1 | D10 | Engineering | 80000 |

`DeptName` depends on `DeptID`, not directly on `EmployeeID` → transitive dependency.

### Fix (3NF)

**Employees**

| EmployeeID | DeptID | Salary |
|------------|--------|--------|
| E1 | D10 | 80000 |

**Departments**

| DeptID | DeptName |
|--------|----------|
| D10 | Engineering |

---

## 4NF — Fourth Normal Form

**Rule:** Must be in **3NF**, and no **multi-valued dependency** unless it comes from a candidate key.

A multi-valued dependency: knowing `A` determines a set of `B` values **independently** of other attributes.

### Violation

PK = `(ProfessorID, CourseID, TextbookID)` — but really:

| ProfessorID | CourseID | TextbookID |
|-------------|----------|------------|
| P1 | C01 | T1 |
| P1 | C01 | T2 |
| P1 | C02 | T1 |
| P1 | C02 | T2 |

Professor teaches multiple courses **and** uses multiple textbooks — these are **independent** facts. Storing them together creates redundant combinations (every course × every textbook).

### Fix (4NF)

**ProfessorCourses**

| ProfessorID | CourseID |
|-------------|----------|
| P1 | C01 |
| P1 | C02 |

**ProfessorTextbooks**

| ProfessorID | TextbookID |
|-------------|-----------|
| P1 | T1 |
| P1 | T2 |

---

## 5NF — Fifth Normal Form (Project-Join Normal Form)

**Rule:** Must be in **4NF**, and the table cannot be decomposed into smaller tables and **rejoined** without losing or creating spurious rows (no **join dependency** that isn't implied by keys).

This is rare in practice; it handles cases where a fact is really the **combination of three or more** independent relationships.

### Violation (simplified)

Suppose agents sell products, and products are made by brands, and agents work in certain cities — but "agent sells product in city" is only valid when all three relationships align:

| Agent | Product | Brand | City |
|-------|---------|-------|------|
| A1 | Widget | Acme | NYC |
| A2 | Gadget | Beta | LA |

If this table can be split into three binary relations and rejoined correctly only when all three hold, a single wide table may encode invalid combinations.

### Fix (5NF)

Split into three tables and join only valid tuples:

**AgentProduct** | **ProductBrand** | **AgentCity**

Decomposition ensures you can't reconstruct invalid `(Agent, Product, Brand, City)` rows that never existed in the real world.

---

## 6NF — Sixth Normal Form (Domain-Key Normal Form)

**Rule:** Every non-key attribute is part of a **candidate key**, or the table represents a **time-varying** fact where each attribute can change independently over time.

Mainly used in **temporal / data warehouse** designs where you track history.

### Idea

Instead of one row with many columns that change at different times:

| EmployeeID | Dept | Salary | EffectiveDate |
|------------|------|--------|---------------|
| E1 | D10 | 80000 | 2024-01-01 |

When only salary changes, you duplicate `Dept` even though it didn't change.

### Fix (6NF) — one table per attribute over time

**EmployeeDept**

| EmployeeID | Dept | ValidFrom | ValidTo |
|------------|------|-----------|---------|
| E1 | D10 | 2024-01-01 | 9999-12-31 |

**EmployeeSalary**

| EmployeeID | Salary | ValidFrom | ValidTo |
|------------|------|-----------|---------|
| E1 | 80000 | 2024-01-01 | 2025-06-01 |
| E1 | 85000 | 2025-06-01 | 9999-12-31 |

Each fact varies on its own timeline → no redundant columns when one attribute changes.

---

## Summary Table

| Normal Form | Main rule | Typical problem fixed |
|-------------|-----------|------------------------|
| **1NF** | Atomic values, unique rows | Multi-valued columns (`Items: A,B,C`) |
| **2NF** | Full key dependency | Partial dependency on composite key |
| **3NF** | No transitive dependency | `DeptName` via `DeptID` |
| **4NF** | No independent multi-valued facts | Course + textbook combos |
| **5NF** | No bad join recompositions | Three-way relationships |
| **6NF** | One fact per table (often temporal) | Independent attribute histories |

---

## Denormalization — When You Undo Normalization

After normalizing, queries may need many **JOINs**. Denormalization **merges or duplicates** data for speed.

### Example: E-commerce

**Normalized (3NF)**

- `Orders(OrderID, CustomerID, OrderDate)`
- `Customers(CustomerID, Name, City)`
- `OrderItems(OrderID, ProductID, Qty)`
- `Products(ProductID, Name, Price)`

**Denormalized (for reporting)**

| OrderID | CustomerName | City | ProductName | Qty | Price | LineTotal |
|---------|--------------|------|-------------|-----|-------|-----------|
| 1001 | Alice | NYC | Laptop | 1 | 999 | 999 |

| Pros | Cons |
|------|------|
| One query, fast dashboards | Customer name duplicated on every order line |
| Simple for analytics | Update customer name → many rows to fix |
| Good for read-heavy systems | Storage increases |

**Common denormalization patterns:**
- **Duplicate columns** (store `CustomerName` on `Orders`)
- **Summary tables** (daily sales totals)
- **JSON/embedded documents** (NoSQL-style inside SQL)
- **Materialized views** (precomputed joins)

---

## Practical Guidance

| Situation | Approach |
|-----------|----------|
| OLTP (transactions, CRM, billing) | Normalize to **3NF** (sometimes 4NF) |
| OLAP (reports, dashboards) | Denormalize into **star schema** (fact + dimension tables) |
| High-traffic reads | Cache or denormalize read models |
| Audit / history | Consider **6NF-style** temporal tables |

Most production systems aim for **3NF in the source of truth**, then **denormalize selectively** for performance — not the other way around.

---

## Quick Visual: Normalization Journey

```
Messy table (redundant, anomalies)
        ↓ 1NF  → atomic columns
        ↓ 2NF  → split partial key dependencies
        ↓ 3NF  → split transitive dependencies
        ↓ 4NF  → split multi-valued dependencies
        ↓ 5NF  → split join dependencies
        ↓ 6NF  → split temporal / independent facts
Clean, consistent writes
        ↓ (optional) Denormalize for reads
Fast queries, careful updates
```

If you want, I can walk through a **specific domain** (e.g. billing, users/orders, or the analytics code you have open) and show what 3NF vs denormalized tables would look like for that schema.