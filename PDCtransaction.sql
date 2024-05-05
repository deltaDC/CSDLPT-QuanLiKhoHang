-- tang gia product duoc order nhieu nhat
BEGIN TRANSACTION

BEGIN TRY

	DECLARE @product_id nvarchar(255)

	SELECT TOP 1 @product_id = op.product_id FROM order_product as op
	JOIN product as p
	ON p.ID = op.product_id
	GROUP BY op.product_id
	ORDER BY COUNT(*) DESC

	UPDATE product
	SET price = price * 1.1
	WHERE ID = @product_id

	IF(@@ROWCOUNT = 0)
	THROW 50001, 'Khong update duoc gia', 1

	COMMIT

END TRY
BEGIN CATCH
	ROLLBACK
	PRINT 'Co loi xay ra ' + ERROR_MESSAGE()
END CATCH

-- giam gia product duoc order it nhat
BEGIN TRANSACTION

BEGIN TRY
	DECLARE @product_id nvarchar(255)

	SELECT TOP 1 @product_id = op.product_id FROM order_product as op
	JOIN product as p
	ON p.ID = op.product_id
	GROUP BY op.product_id
	ORDER BY COUNT(*) ASC

	UPDATE product
	SET price = price * 1.1
	WHERE ID = @product_id

	IF(@@ROWCOUNT = 0)
	THROW 50001, 'khong update duoc', 1

	COMMIT

END TRY
BEGIN CATCH
	ROLLBACK
	PRINT 'co loi xay ra ' + ERROR_MESSAGE()
END CATCH


-- tang luong cho nhan vien co nhieu order nhat
BEGIN TRANSACTION

BEGIN TRY

	DECLARE @employee_id nvarchar(255)

	SELECT TOP 1 @employee_id = employee_id FROM orders as o
	JOIN employee as e
	ON e.ID = o.employee_id
	GROUP BY employee_id
	ORDER BY COUNT(*) DESC

	UPDATE employee
	SET salary = salary * 1.2
	WHERE ID = @employee_id

	IF(@@ROWCOUNT = 0)
	THROW 50001, 'khong update duoc', 1

	COMMIT

END TRY
BEGIN CATCH
	ROLLBACK
	PRINT 'co loi xay ra: ' + ERROR_MESSAGE()
END CATCH


-- liet ke customer co nhieu order nhat
BEGIN TRANSACTION

BEGIN TRY

	SELECT TOP 5 o.customer_id, c.customer_name, c.address, c.phone_number, COUNT(*) as total_order FROM orders as o
	JOIN customer as c
	ON c.ID = o.customer_id
	GROUP BY customer_id, c.customer_name, c.address, c.phone_number
	ORDER BY COUNT(*) DESC

END TRY
BEGIN CATCH
	ROLLBACK
	PRINT 'co loi xay ra'
END CATCH



-- xoa order da duoc giao
BEGIN TRANSACTION

BEGIN TRY  

	DELETE FROM order_product
	WHERE order_id IN (
		SELECT ID FROM orders WHERE delivery_date <= GETDATE()
	)

	DELETE FROM orders
	WHERE delivery_date >= GETDATE()

    IF(@@ROWCOUNT = 0)
    THROW 50001, 'khong tac dong duoc den row nao ca', 1

    COMMIT

END TRY  
BEGIN CATCH  
    ROLLBACK
	PRINT 'transaction da duoc rollback'
    PRINT 'Co loi xay ra: ' + ERROR_MESSAGE();
END CATCH;  




BEGIN TRANSACTION

BEGIN TRY  

    SELECT TOP 1 op.product_id, p.product_name FROM order_product as op
	JOIN product as p
	ON p.ID = op.product_id
	GROUP BY op.product_id, p.product_name
	ORDER BY COUNT(*) DESC

    IF(@@ROWCOUNT = 0)
    THROW 50001, 'khong tac dong duoc den row nao ca', 1

    COMMIT

END TRY  
BEGIN CATCH  
    ROLLBACK
    PRINT 'Co loi xay ra: ' + ERROR_MESSAGE();
END CATCH;  

   
-- tạo một order mới của một employee đã tồn tại, với tên khách hàng mới và sản phẩm mới (insert vào customer và product)	
BEGIN TRANSACTION

BEGIN TRY  

    INSERT INTO customer (ID, customer_name, address, phone_number) 
	VALUES ('BN01C011', N'Phạm Đức Chính', N'Thái Bình', '0123456789');

	INSERT INTO product (ID, product_name, price, category_id) 
	VALUES ('P005', N'Áo ba lỗ', 30000, 'CAT01');

	INSERT INTO orders (ID, order_date, delivery_date, price, employee_id, customer_id)
	VALUES ('OD00588', '2024-04-30', '2024-05-01', 60000, 'BN01_001', 'BN01C011');

	INSERT INTO order_product (ID, order_id, product_id) 
	VALUES ('ODP001001', 'OD00588', 'P005');

    IF(@@ROWCOUNT = 0)
    THROW 50001, 'khong tac dong duoc den row nao ca', 1

    COMMIT

END TRY  
BEGIN CATCH  
    ROLLBACK
    PRINT 'Co loi xay ra: ' + ERROR_MESSAGE();
END CATCH;  

