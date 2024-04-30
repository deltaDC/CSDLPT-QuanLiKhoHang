-- trigger kiểm tra nếu employee.salary = null thì mặc định là 0
CREATE TRIGGER check_employee_insert
ON employee
AFTER INSERT
AS
BEGIN
	-- cap nhat luong cho employee
	UPDATE employee
	SET salary = CASE
		WHEN inserted.salary IS NULL THEN 0
		ELSE inserted.salary
	END
	FROM employee
	INNER JOIN inserted ON employee.ID = inserted.ID;
END;

INSERT INTO employee (ID, employee_name, date_of_birth, phone_number, address, warehouse_id)
VALUES ('BN01_006', 'Alice Johnson', '1988-07-12', '5551234567', '789 Elm St', 'BN01');

select * from employee where warehouse_id = 'BN01';



-- trigger validate phone_number của một customer
CREATE TRIGGER trg_customer_validate_phone_number
ON customer
AFTER INSERT, UPDATE
AS
BEGIN
    -- Check if the phone number is valid
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE NOT phone_number LIKE '[0-9]%'
              OR LEN(phone_number) < 10
              OR LEN(phone_number) > 15
    )
    BEGIN
        RAISERROR('Invalid phone number. Phone number must contain only digits and be between 10 and 15 characters in length.', 16, 1)
        ROLLBACK TRANSACTION;
    END;
END;


-- Chèn dữ liệu vào bảng customer
INSERT INTO customer (ID, customer_name, address, phone_number)
VALUES ('C001', 'John Doe', '123 Main St', '0123');



CREATE TRIGGER trg_product_validate_price
ON product
AFTER INSERT, UPDATE
AS
BEGIN
    -- Check if the price is valid
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE price <= 0
    )
    BEGIN
        RAISERROR('Giá tiền không hợp lệ', 16, 1)
        ROLLBACK TRANSACTION;
    END;
END;

INSERT INTO product (ID, product_name, price, category_id)
VALUES ('P005', 'Laptop', -1, 'CAT01');









