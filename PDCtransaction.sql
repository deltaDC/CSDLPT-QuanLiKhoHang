--tăng giá product được bán nhiều nhất
BEGIN TRANSACTION
DECLARE @product_id nvarchar(255)

-- lấy ra sản phẩm được bán nhiều nhất
SELECT TOP 1 @product_id = op.product_id FROM order_product as op
JOIN product as p 
ON p.ID = op.product_id
GROUP BY product_id, p.product_name, p.price
ORDER BY COUNT(*) DESC;

-- tăng giá lên 10%
UPDATE product
SET price = price * 1.1
WHERE ID = @product_id;

COMMIT TRANSACTION


--giảm giá product được bán ít nhất
BEGIN TRANSACTION
DECLARE @product_id nvarchar(255)

-- lấy ra sản phẩm được bán nhiều nhất
SELECT TOP 1 @product_id = op.product_id FROM order_product as op
JOIN product as p 
ON p.ID = op.product_id
GROUP BY product_id, p.product_name, p.price
ORDER BY COUNT(*) ASC;

-- giảm giá  10%
UPDATE product
SET price = price * 0.9
WHERE ID = @product_id;

COMMIT TRANSACTION


-- tăng lương cho nhân viên bán được nhiều order nhất
BEGIN TRANSACTION

DECLARE @employee_id nvarchar(255)

SELECT TOP 1 @employee_id = employee_id FROM orders as o
JOIN employee as e
ON e.ID = o.employee_id
GROUP BY o.employee_id
ORDER BY COUNT(*) DESC;

UPDATE employee
SET salary = salary * 1.2
WHERE ID = @employee_id

COMMIT TRANSACTION



--liệt kê 5 customer có nhiều order nhất
BEGIN TRANSACTION

SELECT TOP 5 o.customer_id, c.customer_name, COUNT(*) as total FROM orders as o
JOIN customer as c
ON c.ID = o.customer_id
GROUP BY o.customer_id, c.customer_name
ORDER BY COUNT(*) DESC;

COMMIT TRANSACTION


-- xóa những orders đã được giao
BEGIN TRANSACTION

DELETE FROM orders
WHERE delivery_date > GETDATE();

COMMIT TRANSACTION

-- liệt kê product được orders nhiều nhất
BEGIN TRANSACTION

-- lấy ra sản phẩm được bán nhiều nhất
SELECT TOP 1 op.product_id, p.product_name FROM order_product as op
JOIN product as p 
ON p.ID = op.product_id
GROUP BY product_id, p.product_name, p.price
ORDER BY COUNT(*) DESC;

COMMIT TRANSACTION

-- tạo một order mới của một employee đã tồn tại, với tên khách hàng mới và sản phẩm mới (insert vào customer và product)	
BEGIN TRANSACTION

INSERT INTO customer (ID, customer_name, address, phone_number) VALUES ('BN01C011', N'Phạm Đức Chính', N'Thái Bình', '0123456789');

INSERT INTO product (ID, product_name, price, category_id) VALUES ('P005', N'Áo ba lỗ', 30000, 'CAT01');

INSERT INTO orders (ID, order_date, delivery_date, price, employee_id, customer_id)
VALUES ('OD00588', '2024-04-30', '2024-05-01', 60000, 'BN01_001', 'BN01C011');

INSERT INTO order_product (ID, order_id, product_id) VALUES ('ODP001001', 'OD00588', 'P005');

COMMIT TRANSACTION