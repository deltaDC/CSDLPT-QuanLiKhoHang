DROP DATABASE QuanLiKhoHang;
CREATE DATABASE QuanLiKhoHang;


--tạo các bảng
CREATE TABLE headquarter (
	ID nvarchar(255) NOT NULL PRIMARY KEY,
	name_headquarter nvarchar(255),
	address_headquarter nvarchar(255)
);

CREATE TABLE warehouse (
	ID nvarchar(255) NOT NULL PRIMARY KEY,
	name_warehouse nvarchar(255),
	address_warehouse nvarchar(255),
	headquarter_id nvarchar(255) NOT NULL,
	CONSTRAINT FK_warehouse_headquarter FOREIGN KEY (headquarter_id) REFERENCES headquarter(ID)
);

CREATE TABLE employee (
	ID nvarchar(255) NOT NULL PRIMARY KEY,
	employee_name nvarchar(255),
	date_of_birth DATE,
	phone_number nvarchar(255),
	address nvarchar(255),
	salary int,
	warehouse_id nvarchar(255) NOT NULL
	CONSTRAINT FK_employee_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouse(ID)
);

CREATE TABLE orders (
	ID nvarchar(255) NOT NULL PRIMARY KEY,
	order_date DATE,
	delivery_date DATE,
	price int,
	employee_id nvarchar(255) NOT NULL,
	CONSTRAINT FK_order_employee FOREIGN KEY (employee_id) REFERENCES employee(ID),
	customer_id nvarchar(255) NOT NULL,
	CONSTRAINT FK_order_customer FOREIGN KEY (customer_id) REFERENCES customer(ID)
);

CREATE TABLE order_product (
	ID nvarchar(255) NOT NULL PRIMARY KEY,
	order_id nvarchar(255) NOT NULL,
	CONSTRAINT FK_order_product_order FOREIGN KEY (order_id) REFERENCES orders(ID),
	product_id nvarchar(255) NOT NULL,
	CONSTRAINT FK_oder_product_product FOREIGN KEY (product_id) REFERENCES product(ID)
);

CREATE TABLE customer (
	ID nvarchar(255) NOT NULL PRIMARY KEY,
	customer_name nvarchar(255),
	address nvarchar(255),
	phone_number nvarchar(255)
);

CREATE TABLE product (
	ID nvarchar(255) NOT NULL PRIMARY KEY,
	product_name nvarchar(255),
	price int,
	category_id nvarchar(255) NOT NULL,
	CONSTRAINT FK_product_category FOREIGN KEY (category_id) REFERENCES category(ID)
);

CREATE TABLE category (
	ID nvarchar(255) NOT NULL PRIMARY KEY,
	category_name nvarchar(255)
);