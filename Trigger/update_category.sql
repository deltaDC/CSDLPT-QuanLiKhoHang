USE [QuanLiKhoHang]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[update_category]
ON [dbo].[category]
AFTER INSERT,UPDATE
AS
BEGIN
    -- Lấy ID từ bảng inserted
    DECLARE @ID VARCHAR(50)
    SET @ID = (SELECT TOP 1 ID FROM inserted)  -- Giả sử một hàng chèn

    -- Kiểm tra ID có bắt đầu bằng 'CAT' không
    IF @ID LIKE 'CAT%'
    BEGIN
        PRINT 'Cập nhật dữ liệu thành công.'
    END
    ELSE
    BEGIN
        -- Nếu không, hủy giao dịch và đưa ra thông báo lỗi
		PRINT 'Cập nhật thông tin thất bại.'
        RAISERROR ('ID không hợp lệ, phải bắt đầu bằng "CAT".', 16, 1)
        ROLLBACK TRANSACTION
    END
END
