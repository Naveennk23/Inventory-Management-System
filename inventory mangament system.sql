mysql> use inventory_system;
Database changed
mysql> show tables;
+----------------------------+
| Tables_in_inventory_system |
+----------------------------+
| products                   |
| stock                      |
| suppliers                  |
| warehouses                 |
+----------------------------+
4 rows in set (0.04 sec)

mysql> select * from products;
+----+--------------+-------+---------------+
| id | name         | price | reorder_level |
+----+--------------+-------+---------------+
|  1 | laptop       | 35000 |             1 |
|  2 | objective gk |   450 |             1 |
|  3 | lucents book |   400 |             1 |
|  4 | smart watch  |  1300 |             2 |
|  5 | airbords     |   500 |             1 |
+----+--------------+-------+---------------+
5 rows in set (0.05 sec)

mysql> select * from stock;
+----------+------------+--------------+----------+
| stock_id | product_id | warehouse_id | quantity |
+----------+------------+--------------+----------+
|        1 |          1 |            1 |        1 |
|        2 |          2 |            1 |        1 |
|        3 |          3 |            1 |        2 |
|        4 |          4 |            2 |        2 |
|        5 |          5 |            2 |        1 |
+----------+------------+--------------+----------+
5 rows in set (0.03 sec)

mysql> select * from suppliers;
+----+--------------------+------------------+
| id | name               | contact          |
+----+--------------------+------------------+
|  1 | lenovo             | lenovo@gmail.com |
|  2 | sp books           | sp@gmail.com     |
|  3 | lucent publication | lucent@gmail.com |
|  4 | jbl                | jbl@gmail.com    |
+----+--------------------+------------------+
4 rows in set (0.02 sec)

mysql> select * from warehouses;
+----+---------------------+-----------+
| id | name                | location  |
+----+---------------------+-----------+
|  1 | main warehouse      | bangalore |
|  2 | secondary warehouse | mysore    |
+----+---------------------+-----------+
2 rows in set (0.02 sec)

mysql> SELECT
    ->     p.name AS product_name,
    ->     w.name AS warehouse_name,
    ->     s.quantity
    -> FROM stock s
    -> JOIN products p ON s.product_id = p.id
    -> JOIN warehouses w ON s.warehouse_id = w.id;
+--------------+---------------------+----------+
| product_name | warehouse_name      | quantity |
+--------------+---------------------+----------+
| laptop       | main warehouse      |        1 |
| objective gk | main warehouse      |        1 |
| lucents book | main warehouse      |        2 |
| smart watch  | secondary warehouse |        2 |
| airbords     | secondary warehouse |        1 |
+--------------+---------------------+----------+
5 rows in set (0.13 sec)

mysql> SELECT
    ->     p.name AS product_name,
    ->     s.quantity,
    ->     p.reorder_level
    -> FROM stock s
    -> JOIN products p ON s.product_id = p.id
    -> WHERE s.quantity <= p.reorder_level;
+--------------+----------+---------------+
| product_name | quantity | reorder_level |
+--------------+----------+---------------+
| laptop       |        1 |             1 |
| objective gk |        1 |             1 |
| smart watch  |        2 |             2 |
| airbords     |        1 |             1 |
+--------------+----------+---------------+
4 rows in set (0.01 sec)

mysql> DELIMITER //
mysql> DROP PROCEDURE IF EXISTS transfer_stock;
    -> CREATE PROCEDURE transfer_stock(
    ->     IN from_warehouse INT,
    ->     IN to_warehouse INT,
    ->     IN prod_id INT,
    ->     IN qty INT
    -> )
    -> BEGIN
    ->     DECLARE available_qty INT;
    ->     SELECT quantity INTO available_qty
    ->     FROM stock
    ->     WHERE product_id = prod_id AND warehouse_id = from_warehouse;
    ->     IF available_qty >= qty THEN
    ->         UPDATE stock
    ->         SET quantity = quantity - qty
    ->         WHERE product_id = prod_id AND warehouse_id = from_warehouse;
    ->         IF EXISTS (
    ->             SELECT 1 FROM stock WHERE product_id = prod_id AND warehouse_id = to_warehouse
    ->         ) THEN
    ->             UPDATE stock
    ->             SET quantity = quantity + qty
    ->             WHERE product_id = prod_id AND warehouse_id = to_warehouse;
    ->         ELSE
    ->             INSERT INTO stock(product_id, warehouse_id, quantity)
    ->             VALUES(prod_id, to_warehouse, qty);
    ->         END IF;
    ->     ELSE
    ->         SIGNAL SQLSTATE '45000'
    ->         SET MESSAGE_TEXT = 'Not enough stock in source warehouse!';
    ->     END IF;
    -> END //
Query OK, 0 rows affected (0.02 sec)
mysql>  SELECT * FROM stock WHERE product_id = 1;
+----------+------------+--------------+----------+
| stock_id | product_id | warehouse_id | quantity |
+----------+------------+--------------+----------+
|        1 |          1 |            1 |       -1 |
|        6 |          1 |            2 |        1 |
+----------+------------+--------------+----------+
2 rows in set (0.00 sec)