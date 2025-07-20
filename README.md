# Inventory and Warehouse Management System

This project is a **MySQL-based Inventory and Warehouse Management System** that allows users to track product stock, warehouse locations, suppliers, and automate stock transfers using stored procedures.

## 📌 Objective
To design and implement a simple inventory backend using **MySQL** that:
- Tracks product quantities across warehouses
- Sends reorder alerts
- Transfers stock between warehouses
- Stores supplier and warehouse information

## 🛠️ Tools Used
- MySQL CLI / DBeaver
- SQL (DDL, DML, Views, Triggers, Procedures)
- GitHub (Version Control)

---

## 📂 Database Schema

### `products`
Stores product details.

| Column         | Type                          |
|----------------|-------------------------------|
| id             | INT, PRIMARY KEY, AUTO_INCREMENT |
| name           | VARCHAR(100)                  |
| price          | INT                           |
| reorder_level  | INT                           |

### `suppliers`
Stores supplier information.

| Column  | Type                          |
|---------|-------------------------------|
| id      | INT, PRIMARY KEY, AUTO_INCREMENT |
| name    | VARCHAR(100)                 |
| contact | VARCHAR(100)                 |

### `warehouses`
Stores warehouse data.

| Column   | Type                          |
|----------|-------------------------------|
| id       | INT, PRIMARY KEY, AUTO_INCREMENT |
| name     | VARCHAR(100)                 |
| location | VARCHAR(100)                 |

### `stock`
Tracks quantity of products in each warehouse.

| Column        | Type                              |
|---------------|-----------------------------------|
| stock_id      | INT, PRIMARY KEY, AUTO_INCREMENT |
| product_id    | INT, FOREIGN KEY to `products(id)` |
| warehouse_id  | INT, FOREIGN KEY to `warehouses(id)` |
| quantity      | INT                               |

---

## 📦 Sample Data

### Product Example
```sql
INSERT INTO products (name, price, reorder_level)
VALUES 
('laptop', 35000, 1), 
('objective gk', 450, 1), 
('lucents book', 400, 1), 
('smart watch', 1300, 2), 
('airbords', 500, 1);
INSERT INTO warehouses (name, location)
VALUES 
('main warehouse', 'bangalore'), 
('secondary warehouse', 'mysore');
SELECT 
    p.name AS product_name, 
    w.name AS warehouse_name, 
    s.quantity
FROM stock s
JOIN products p ON s.product_id = p.id
JOIN warehouses w ON s.warehouse_id = w.id;
SELECT 
    p.name AS product_name, 
    s.quantity, 
    p.reorder_level
FROM stock s
JOIN products p ON s.product_id = p.id
WHERE s.quantity <= p.reorder_level;
CALL transfer_stock(from_warehouse, to_warehouse, product_id, qty);
