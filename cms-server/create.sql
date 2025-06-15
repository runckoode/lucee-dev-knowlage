-- PostgreSQL does not use CREATE DATABASE or USE statements within a script
-- The database `inventario` should be created externally (e.g., via docker-compose environment variables or psql commands).

-- Table: warehouses (multi-almacén)
CREATE TABLE warehouses (
    warehouseId SERIAL PRIMARY KEY, -- Changed AUTO_INCREMENT to SERIAL
    warehouseName VARCHAR(100) NOT NULL,
    location VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW()
);

-- Table: productCategories
CREATE TABLE productCategories (
    categoryId SERIAL PRIMARY KEY, -- Changed AUTO_INCREMENT to SERIAL
    categoryName VARCHAR(100) NOT NULL UNIQUE, -- Added UNIQUE constraint here
    categoryDescription TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(), -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW()
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW(). Note: PostgreSQL handles ON UPDATE differently, usually via triggers.
);

-- Table: brands
CREATE TABLE brands (
    brandId SERIAL PRIMARY KEY, -- Changed AUTO_INCREMENT to SERIAL
    brandName VARCHAR(100) NOT NULL UNIQUE, -- Added UNIQUE constraint here
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(), -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW()
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW(). Note: PostgreSQL handles ON UPDATE differently, usually via triggers.
);

-- Table: brandsByCategory (relación muchos a muchos)
CREATE TABLE brandsByCategory (
    brandsByCategoryId SERIAL PRIMARY KEY, -- Changed AUTO_INCREMENT to SERIAL
    categoryId INT NOT NULL,
    brandId INT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(), -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW()
    FOREIGN KEY (categoryId) REFERENCES productCategories(categoryId) ON DELETE CASCADE,
    FOREIGN KEY (brandId) REFERENCES brands(brandId) ON DELETE CASCADE,
    UNIQUE (categoryId, brandId)
);

-- Table: providers
CREATE TABLE providers (
    providerId SERIAL PRIMARY KEY, -- Changed AUTO_INCREMENT to SERIAL
    providerName VARCHAR(150) NOT NULL UNIQUE, -- Added UNIQUE constraint here
    contactName VARCHAR(100),
    phone VARCHAR(30),
    email VARCHAR(100),
    address VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(), -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW()
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW(). Note: PostgreSQL handles ON UPDATE differently, usually via triggers.
);

-- Table: products
CREATE TABLE products (
    productId SERIAL PRIMARY KEY, -- Changed AUTO_INCREMENT to SERIAL
    productName VARCHAR(150) NOT NULL,
    categoryId INT NOT NULL,
    brandId INT NOT NULL,
    providerId INT,
    description TEXT,
    price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(), -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW()
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(), -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW(). Note: PostgreSQL handles ON UPDATE differently, usually via triggers.
    FOREIGN KEY (categoryId) REFERENCES productCategories(categoryId) ON DELETE RESTRICT,
    FOREIGN KEY (brandId) REFERENCES brands(brandId) ON DELETE RESTRICT,
    FOREIGN KEY (providerId) REFERENCES providers(providerId) ON DELETE SET NULL,
    UNIQUE (productName, brandId, categoryId)
);

-- Table: productStock (ahora multi-almacén)
CREATE TABLE productStock (
    stockId SERIAL PRIMARY KEY, -- Changed AUTO_INCREMENT to SERIAL
    productId INT NOT NULL,
    warehouseId INT NOT NULL DEFAULT 1,
    quantity INT NOT NULL DEFAULT 0,
    minStock INT DEFAULT 0,
    maxStock INT DEFAULT 0,
    lastUpdate TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(), -- Changed TIMESTAMP and ON UPDATE CURRENT_TIMESTAMP to NOW(). Note: PostgreSQL handles ON UPDATE differently, usually via triggers.
    FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE CASCADE,
    FOREIGN KEY (warehouseId) REFERENCES warehouses(warehouseId) ON DELETE RESTRICT
);

-- Table: sales
CREATE TABLE sales (
    saleId SERIAL PRIMARY KEY, -- Changed AUTO_INCREMENT to SERIAL
    saleDate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(), -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW()
    totalAmount DECIMAL(12,2) NOT NULL,
    customerName VARCHAR(100),
    notes TEXT,
    status TEXT DEFAULT 'completed' CHECK (status IN ('pending','completed','cancelled')), -- Changed ENUM to TEXT with CHECK constraint
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(), -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW()
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW(). Note: PostgreSQL handles ON UPDATE differently, usually via triggers.
);

-- Table: saleDetails
CREATE TABLE saleDetails (
    saleDetailId SERIAL PRIMARY KEY, -- Changed AUTO_INCREMENT to SERIAL
    saleId INT NOT NULL,
    productId INT NOT NULL,
    quantity INT NOT NULL,
    unitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (saleId) REFERENCES sales(saleId) ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE RESTRICT
);

-- Table: purchases
CREATE TABLE purchases (
    purchaseId SERIAL PRIMARY KEY, -- Changed AUTO_INCREMENT to SERIAL
    providerId INT NOT NULL,
    purchaseDate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(), -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW()
    totalAmount DECIMAL(12,2) NOT NULL,
    notes TEXT,
    status TEXT DEFAULT 'completed' CHECK (status IN ('pending','completed','cancelled')), -- Changed ENUM to TEXT with CHECK constraint
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(), -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW()
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(), -- Changed DATETIME to TIMESTAMP WITHOUT TIME ZONE and CURRENT_TIMESTAMP to NOW(). Note: PostgreSQL handles ON UPDATE differently, usually via triggers.
    FOREIGN KEY (providerId) REFERENCES providers(providerId) ON DELETE RESTRICT
);

-- Table: purchaseDetails
CREATE TABLE purchaseDetails (
    purchaseDetailId SERIAL PRIMARY KEY, -- Changed AUTO_INCREMENT to SERIAL
    purchaseId INT NOT NULL,
    productId INT NOT NULL,
    quantity INT NOT NULL,
    unitCost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (purchaseId) REFERENCES purchases(purchaseId) ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE RESTRICT
);

-- Índices adicionales para rendimiento
CREATE INDEX idx_products_category ON products(categoryId);
CREATE INDEX idx_products_brand ON products(brandId);
CREATE INDEX idx_productStock_product ON productStock(productId);
CREATE INDEX idx_productStock_warehouse ON productStock(warehouseId);
CREATE INDEX idx_saleDetails_product ON saleDetails(productId);
CREATE INDEX idx_purchaseDetails_product ON purchaseDetails(productId);
