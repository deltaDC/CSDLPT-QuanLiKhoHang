CREATE TRIGGER update_category
ON category
AFTER INSERT,UPDATE
AS
BEGIN
    -- Lấy ID từ bảng inserted
    DECLARE @ID VARCHAR(50)
    SET @ID = (SELECT TOP 1 ID FROM inserted)  -- Giả sử một hàng chèn

    -- Kiểm tra ID có bắt đầu bằng 'CAT' không
    IF @ID LIKE 'CAT%'
    BEGIN
        PRINT 'Chèn dữ liệu thành công.'
    END
    ELSE
    BEGIN
        -- Nếu không, hủy giao dịch và đưa ra thông báo lỗi
        RAISERROR ('ID không hợp lệ, phải bắt đầu bằng "CAT".', 16, 1)
        ROLLBACK TRANSACTION
    END
END
