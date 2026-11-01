/*
====================================================================
COMMON POSTGRESQL DATA TYPES REFERENCE GUIDE
====================================================================
*/

-- =================================================================
-- 1. NUMERIC TYPES
-- =================================================================
-- INTEGER (or int)      -- 4 bytes, standard whole number (-2B to +2B)
-- BIGINT                -- 8 bytes, large-range whole number
-- SMALLINT              -- 2 bytes, small-range whole number (-32k to +32k)
-- SERIAL / BIGSERIAL    -- Auto-incrementing 4 or 8-byte integers
-- NUMERIC (or DECIMAL)  -- Exact precision numbers (great for currency)
-- REAL / DOUBLE PREC    -- Floating-point numbers (inexact, prone to rounding)

-- =================================================================
-- 2. CHARACTER / STRING TYPES
-- =================================================================
-- TEXT                  -- Variable-length string with no upper limit (recommended)
-- VARCHAR(n)            -- Variable-length string with strict character limit 'n'
-- CHAR(n)               -- Fixed-length string, space-padded to length 'n'

-- =================================================================
-- 3. DATE AND TIME TYPES
-- =================================================================
-- TIMESTAMP             -- Date and time without timezone context
-- TIMESTAMPTZ           -- Date and time with timezone (normalized to UTC, best practice)
-- DATE                  -- Calendar date only (year, month, day)
-- TIME                  -- Time of day only (hour, minute, second)
-- INTERVAL              -- A time span or duration (e.g., '1 hour 30 minutes')

-- =================================================================
-- 4. BOOLEAN TYPE
-- =================================================================
-- BOOLEAN               -- Stores true, false, or null

-- =================================================================
-- 5. ADVANCED & SPECIAL TYPES
-- =================================================================
-- JSONB                 -- Binary JSON data (parsed, indexable, highly queryable)
-- UUID                  -- Universally Unique Identifiers (16 bytes)
-- ARRAY (e.g., TEXT[])  -- Native single- or multi-dimensional lists

CREATE TABLE Category (
	category_id SERIAL PRIMARY KEY,
	category_name VARCHAR(50) NOT NULL
);

CREATE TABLE Product (
	product_id SERIAL PRIMARY KEY,
	category_id INTEGER NOT NULL,
	name VARCHAR(50) NOT NULL,
	description TEXT,
	price NUMERIC (10, 2) NOT NULL, -- up to 99999999.99 (less than 10-Million)
	stock_quantity INTEGER NOT NULL,


	FOREIGN KEY (category_id) REFERENCES Category (category_id)
);

CREATE TABLE Customer (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR (100) NOT NULL,
	last_name VARCHAR (100) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	password VARCHAR (255) NOT NULL, -- length depend on the hashing algorithm used

	-- depends on business, or regex rules
	CONSTRAINT customer_valid_email CHECK (email like '_%@%_')
);

-- renamed to avoid reserved keyword `Order`
CREATE TABLE Orders (
	order_id BIGSERIAL PRIMARY KEY,	  -- we expect huge number of orders
	customer_id INTEGER NOT NULL,
	order_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	total_amount NUMERIC (12, 2) NOT NULL CHECK (total_amount >= 0),

	FOREIGN KEY (customer_id) REFERENCES Customer (customer_id)
);


CREATE TABLE Order_details (
	order_detail_id BIGSERIAL PRIMARY KEY,
	order_id BIGINT NOT NULL,
	product_id INTEGER NOT NULL,
	quantity SMALLINT NOT NULL CHECK (quantity >= 0),
	unit_price  NUMERIC (10, 2) NOT NULL, -- matches the Product.price
	
	FOREIGN KEY (order_id) REFERENCES Orders (order_id),
	FOREIGN KEY (product_id) REFERENCES Product (product_id)
);

