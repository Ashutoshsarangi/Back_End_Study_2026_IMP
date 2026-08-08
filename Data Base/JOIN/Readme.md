The primary difference between an **Inner Join** and an **Outer Join** in SQL comes down to how unmatched rows are handled across tables:

* **Inner Join:** Returns **only the rows that match** in both tables based on the join condition. Unmatched rows from either table are excluded.
* **Outer Join:** Returns matching rows **plus unmatched rows** from one or both tables (filling in missing values with `NULL`).

---

## Example Setup

Suppose you have two tables: `Customers` and `Orders`.

**`Customers`**

| CustomerID | Name |
| --- | --- |
| 1 | Alice |
| 2 | Bob |
| 3 | Charlie |

**`Orders`**

| OrderID | CustomerID | Amount |
| --- | --- | --- |
| 101 | 1 | $50 |
| 102 | 2 | $30 |
| 103 | 4 | $100 |

*(Note: Charlie (ID 3) has no orders; Order 103 belongs to Customer ID 4, who isn't in the Customers table.)*

---

## 1. Inner Join

An `INNER JOIN` finds the intersection between both tables. If a row doesn't have a corresponding match in the other table, it is dropped from the result set.

```sql
SELECT Customers.Name, Orders.OrderID, Orders.Amount
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

```

**Result:**

| Name | OrderID | Amount |
| --- | --- | --- |
| Alice | 101 | $50 |
| Bob | 102 | $30 |

---

## 2. Outer Joins

Outer joins keep rows even when there is no match. They come in three types:

### A. Left Outer Join (`LEFT JOIN`)

Returns **all rows from the left table** (`Customers`), and the matched rows from the right table (`Orders`). If there is no match, the right side returns `NULL`.

```sql
SELECT Customers.Name, Orders.OrderID, Orders.Amount
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

```

**Result:**

| Name | OrderID | Amount |
| --- | --- | --- |
| Alice | 101 | $50 |
| Bob | 102 | $30 |
| **Charlie** | **NULL** | **NULL** |

---

### B. Right Outer Join (`RIGHT JOIN`)

Returns **all rows from the right table** (`Orders`), and matched rows from the left table (`Customers`). Unmatched left values return `NULL`.

```sql
SELECT Customers.Name, Orders.OrderID, Orders.Amount
FROM Customers
RIGHT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

```

**Result:**

| Name | OrderID | Amount |
| --- | --- | --- |
| Alice | 101 | $50 |
| Bob | 102 | $30 |
| **NULL** | **103** | **$100** |

---

### C. Full Outer Join (`FULL JOIN`)

Returns **all rows from both tables**. When there is no match, `NULL` values appear for columns of the table that lacks a match.

```sql
SELECT Customers.Name, Orders.OrderID, Orders.Amount
FROM Customers
FULL OUTER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

```

**Result:**

| Name | OrderID | Amount |
| --- | --- | --- |
| Alice | 101 | $50 |
| Bob | 102 | $30 |
| Charlie | NULL | NULL |
| NULL | 103 | $100 |

---

## Quick Comparison Summary

| Join Type | Included Left Rows | Included Right Rows | Common Use Case |
| --- | --- | --- | --- |
| **INNER JOIN** | Matched only | Matched only | Fetching data where relationships strictly exist (e.g., active orders with customer details). |
| **LEFT JOIN** | All | Matched only | Finding records that may or may not have associated items (e.g., all customers and their orders, including customers with zero orders). |
| **RIGHT JOIN** | Matched only | All | Same as LEFT JOIN, but prioritizing the right table (less commonly used; often rewritten as LEFT JOIN for readability). |
| **FULL JOIN** | All | All | Auditing data or finding unmatched rows in both systems/tables. |