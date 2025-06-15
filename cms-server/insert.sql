-- PostgreSQL does not use the 'USE database_name;' command.
-- Ensure you are connected to the 'inventario' database when running this script.

-- Warehouses
INSERT INTO warehouses (warehouseName, location) VALUES
('Central Warehouse', '123 Main St'),
('North Branch', '456 North Ave'),
('South Depot', '789 South Rd');

-- Product Categories
INSERT INTO productCategories (categoryName, categoryDescription) VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Apparel and garments'),
('Food', 'Groceries and beverages');

-- Brands
INSERT INTO brands (brandName) VALUES
('TechBrand'),
('FashionCo'),
('Foodies'),
('GadgetPro');

-- Brands by Category
INSERT INTO brandsByCategory (categoryId, brandId) VALUES
(1, 1), -- TechBrand in Electronics
(1, 4), -- GadgetPro in Electronics
(2, 2), -- FashionCo in Clothing
(3, 3); -- Foodies in Food

-- Providers
INSERT INTO providers (providerName, contactName, phone, email, address) VALUES
('Electro Distributors', 'Carlos Pérez', '555-1111', 'carlos@electro.com', 'Av. Tecnología 100'),
('Moda Global', 'Ana Gómez', '555-2222', 'ana@modaglobal.com', 'Calle Moda 50'),
('Alimentos del Sur', 'Luis Martínez', '555-3333', 'luis@alimentosur.com', 'Ruta 9 Km 12');

-- Products
INSERT INTO products (productName, categoryId, brandId, providerId, description, price) VALUES
('Smartphone X100', 1, 1, 1, 'Smartphone con pantalla OLED y cámara avanzada', 700.00),
('Bluetooth Headphones', 1, 4, 1, 'Auriculares inalámbricos con cancelación de ruido', 120.00),
('Leather Jacket', 2, 2, 2, 'Chaqueta de cuero genuino', 180.00),
('Sports T-Shirt', 2, 2, 2, 'Camiseta deportiva transpirable', 35.00),
('Organic Coffee', 3, 3, 3, 'Café orgánico premium', 15.00),
('Granola Bar', 3, 3, 3, 'Barra energética de granola y frutos secos', 2.50);

-- Product Stock (multi-warehouse)
INSERT INTO productStock (productId, warehouseId, quantity, minStock, maxStock) VALUES
(1, 1, 50, 5, 200),
(2, 1, 30, 5, 100),
(3, 2, 15, 2, 50),
(4, 2, 25, 5, 60),
(5, 3, 100, 10, 300),
(6, 3, 200, 20, 500);

-- Purchases
INSERT INTO purchases (providerId, purchaseDate, totalAmount, status, notes) VALUES
(1, '2025-06-01 10:00:00', 4000.00, 'completed', 'Initial purchase of smartphones and headphones'),
(2, '2025-06-05 14:30:00', 800.00, 'completed', 'Purchase of clothing items'),
(3, '2025-06-10 09:15:00', 350.00, 'completed', 'Purchase of food products');

-- Purchase Details
INSERT INTO purchaseDetails (purchaseId, productId, quantity, unitCost) VALUES
(1, 1, 8, 500.00),
(1, 2, 10, 100.00),
(2, 3, 3, 150.00),
(2, 4, 10, 30.00),
(3, 5, 20, 12.00),
(3, 6, 50, 1.80);

-- Sales
INSERT INTO sales (saleDate, totalAmount, customerName, notes, status) VALUES
('2025-06-11 12:00:00', 700.00, 'Juan López', '', 'completed'),
('2025-06-12 16:45:00', 120.00, 'María Fernández', '', 'completed'),
('2025-06-13 11:30:00', 90.00, 'Pedro Sánchez', '', 'completed');

-- Sale Details
INSERT INTO saleDetails (saleId, productId, quantity, unitPrice) VALUES
(1, 1, 1, 700.00),
(2, 4, 2, 35.00),
(2, 3, 1, 50.00),
(3, 5, 3, 15.00),
(3, 6, 10, 3.00);
