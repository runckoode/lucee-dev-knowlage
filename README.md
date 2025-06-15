component displayname="Inventory" hint="CFC for managing inventory data in PostgreSQL database" {

    // Define the datasource at the component level
    variables.datasource = "s"

    // Constructor (optional)
    public Inventory function init() {
        return this;
    }

    // Warehouse Management
    public query function getWarehouses() {
        var warehouses = new Query(datasource=variables.datasource);
        warehouses.setSQL("
            SELECT warehouseId, warehouseName, location, created_at
            FROM warehouses
            ORDER BY warehouseName ASC
        ");
        return warehouses.execute().getResult();
    }

    public numeric function addWarehouse(required string warehouseName, string location = "") {
        var insertWarehouse = new Query(datasource=variables.datasource);
        insertWarehouse.setSQL("
            INSERT INTO warehouses (warehouseName, location)
            VALUES (:warehouseName, :location)
            RETURNING warehouseId
        ");
        insertWarehouse.addParam(name="warehouseName", value=arguments.warehouseName, cfsqltype="cf_sql_varchar");
        insertWarehouse.addParam(name="location", value=arguments.location, cfsqltype="cf_sql_varchar");
        var result = insertWarehouse.execute();
        return result.getResult().warehouseId;
    }

    // Product Categories Management
    public query function getProductCategories() {
        var categories = new Query(datasource=variables.datasource);
        categories.setSQL("
            SELECT categoryId, categoryName, categoryDescription, created_at, updated_at
            FROM productCategories
            ORDER BY categoryName ASC
        ");
        return categories.execute().getResult();
    }

    public numeric function addProductCategory(required string categoryName, string categoryDescription = "") {
        var insertCategory = new Query(datasource=variables.datasource);
        insertCategory.setSQL("
            INSERT INTO productCategories (categoryName, categoryDescription)
            VALUES (:categoryName, :categoryDescription)
            RETURNING categoryId
        ");
        insertCategory.addParam(name="categoryName", value=arguments.categoryName, cfsqltype="cf_sql_varchar");
        insertCategory.addParam(name="categoryDescription", value=arguments.categoryDescription, cfsqltype="cf_sql_text");
        var result = insertCategory.execute();
        return result.getResult().categoryId;
    }

    // Brands Management
    public query function getBrands() {
        var brands = new Query(datasource=variables.datasource);
        brands.setSQL("
            SELECT brandId, brandName, created_at, updated_at
            FROM brands
            ORDER BY brandName ASC
        ");
        return brands.execute().getResult();
    }

    public numeric function addBrand(required string brandName) {
        var insertBrand = new Query(datasource=variables.datasource);
        insertBrand.setSQL("
            INSERT INTO brands (brandName)
            VALUES (:brandName)
            RETURNING brandId
        ");
        insertBrand.addParam(name="brandName", value=arguments.brandName, cfsqltype="cf_sql_varchar");
        var result = insertBrand.execute();
        return result.getResult().brandId;
    }

    // Providers Management
    public query function getProviders() {
        var providers = new Query(datasource=variables.datasource);
        providers.setSQL("
            SELECT providerId, providerName, contactName, phone, email, address, created_at, updated_at
            FROM providers
            ORDER BY providerName ASC
        ");
        return providers.execute().getResult();
    }

    public numeric function addProvider(required string providerName, string contactName = "", string phone = "", string email = "", string address = "") {
        var insertProvider = new Query(datasource=variables.datasource);
        insertProvider.setSQL("
            INSERT INTO providers (providerName, contactName, phone, email, address)
            VALUES (:providerName, :contactName, :phone, :email, :address)
            RETURNING providerId
        ");
        insertProvider.addParam(name="providerName", value=arguments.providerName, cfsqltype="cf_sql_varchar");
        insertProvider.addParam(name="contactName", value=arguments.contactName, cfsqltype="cf_sql_varchar");
        insertProvider.addParam(name="phone", value=arguments.phone, cfsqltype="cf_sql_varchar");
        insertProvider.addParam(name="email", value=arguments.email, cfsqltype="cf_sql_varchar");
        insertProvider.addParam(name="address", value=arguments.address, cfsqltype="cf_sql_varchar");
        var result = insertProvider.execute();
        return result.getResult().providerId;
    }

    // Products Management
    public query function getProducts() {
        var products = new Query(datasource=variables.datasource);
        products.setSQL("
            SELECT p.productId, p.productName, p.categoryId, p.brandId, p.providerId, p.description, p.price, p.created_at, p.updated_at,
                   pc.categoryName, b.brandName, pr.providerName
            FROM products p
            LEFT JOIN productCategories pc ON p.categoryId = pc.categoryId
            LEFT JOIN brands b ON p.brandId = b.brandId
            LEFT JOIN providers pr ON p.providerId = pr.providerId
            ORDER BY p.productName ASC
        ");
        return products.execute().getResult();
    }

    public numeric function addProduct(required string productName, required numeric categoryId, required numeric brandId, numeric providerId = 0, string description = "", numeric price = 0.00) {
        var insertProduct = new Query(datasource=variables.datasource);
        insertProduct.setSQL("
            INSERT INTO products (productName, categoryId, brandId, providerId, description, price)
            VALUES (:productName, :categoryId, :brandId, :providerId, :description, :price)
            RETURNING productId
        ");
        insertProduct.addParam(name="productName", value=arguments.productName, cfsqltype="cf_sql_varchar");
        insertProduct.addParam(name="categoryId", value=arguments.categoryId, cfsqltype="cf_sql_integer");
        insertProduct.addParam(name="brandId", value=arguments.brandId, cfsqltype="cf_sql_integer");
        insertProduct.addParam(name="providerId", value=arguments.providerId, cfsqltype="cf_sql_integer", null=(arguments.providerId == 0));
        insertProduct.addParam(name="description", value=arguments.description, cfsqltype="cf_sql_text");
        insertProduct.addParam(name="price", value=arguments.price, cfsqltype="cf_sql_decimal");
        var result = insertProduct.execute();
        return result.getResult().productId;
    }

    // Product Stock Management
    public query function getProductStock(required numeric productId, numeric warehouseId = 0) {
        var stock = new Query(datasource=variables.datasource);
        var sql = "
            SELECT stockId, productId, warehouseId, quantity, minStock, maxStock, lastUpdate
            FROM productStock
            WHERE productId = :productId
        ";
        if (arguments.warehouseId != 0) {
            sql &= " AND warehouseId = :warehouseId";
            stock.addParam(name="warehouseId", value=arguments.warehouseId, cfsqltype="cf_sql_integer");
        }
        stock.setSQL(sql);
        stock.addParam(name="productId", value=arguments.productId, cfsqltype="cf_sql_integer");
        return stock.execute().getResult();
    }

    public numeric function updateProductStock(required numeric productId, required numeric warehouseId, required numeric quantity, numeric minStock = 0, numeric maxStock = 0) {
        var updateStock = new Query(datasource=variables.datasource);
        updateStock.setSQL("
            INSERT INTO productStock (productId, warehouseId, quantity, minStock, maxStock)
            VALUES (:productId, :warehouseId, :quantity, :minStock, :maxStock)
            ON CONFLICT (productId, warehouseId)
            DO UPDATE SET quantity = :quantity, minStock = :minStock, maxStock = :maxStock, lastUpdate = NOW()
            RETURNING stockId
        ");
        updateStock.addParam(name="productId", value=arguments.productId, cfsqltype="cf_sql_integer");
        updateStock.addParam(name="warehouseId", value=arguments.warehouseId, cfsqltype="cf_sql_integer");
        updateStock.addParam(name="quantity", value=arguments.quantity, cfsqltype="cf_sql_integer");
        updateStock.addParam(name="minStock", value=arguments.minStock, cfsqltype="cf_sql_integer");
        updateStock.addParam(name="maxStock", value=arguments.maxStock, cfsqltype="cf_sql_integer");
        var result = updateStock.execute();
        return result.getResult().stockId;
    }

    // Sales Management
    public numeric function createSale(required numeric totalAmount, string customerName = "", string notes = "", string status = "completed") {
        var insertSale = new Query(datasource=variables.datasource);
        insertSale.setSQL("
            INSERT INTO sales (totalAmount, customerName, notes, status)
            VALUES (:totalAmount, :customerName, :notes, :status)
            RETURNING saleId
        ");
        insertSale.addParam(name="totalAmount", value=arguments.totalAmount, cfsqltype="cf_sql_decimal");
        insertSale.addParam(name="customerName", value=arguments.customerName, cfsqltype="cf_sql_varchar");
        insertSale.addParam(name="notes", value=arguments.notes, cfsqltype="cf_sql_text");
        insertSale.addParam(name="status", value=arguments.status, cfsqltype="cf_sql_varchar");
        var result = insertSale.execute();
        return result.getResult().saleId;
    }

    public numeric function addSaleDetail(required numeric saleId, required numeric productId, required numeric quantity, required numeric unitPrice) {
        var insertDetail = new Query(datasource=variables.datasource);
        insertDetail.setSQL("
            INSERT INTO saleDetails (saleId, productId, quantity, unitPrice)
            VALUES (:saleId, :productId, :quantity, :unitPrice)
            RETURNING saleDetailId
        ");
        insertDetail.addParam(name="saleId", value=arguments.saleId, cfsqltype="cf_sql_integer");
        insertDetail.addParam(name="productId", value=arguments.productId, cfsqltype="cf_sql_integer");
        insertDetail.addParam(name="quantity", value=arguments.quantity, cfsqltype="cf_sql_integer");
        insertDetail.addParam(name="unitPrice", value=arguments.unitPrice, cfsqltype="cf_sql_decimal");
        var result = insertDetail.execute();
        return result.getResult().saleDetailId;
    }

    // Purchases Management
    public numeric function createPurchase(required numeric providerId, required numeric totalAmount, string notes = "", string status = "completed") {
        var insertPurchase = new Query(datasource=variables.datasource);
        insertPurchase.setSQL("
            INSERT INTO purchases (providerId, totalAmount, notes, status)
            VALUES (:providerId, :totalAmount, :notes, :status)
            RETURNING purchaseId
        ");
        insertPurchase.addParam(name="providerId", value=arguments.providerId, cfsqltype="cf_sql_integer");
        insertPurchase.addParam(name="totalAmount", value=arguments.totalAmount, cfsqltype="cf_sql_decimal");
        insertPurchase.addParam(name="notes", value=arguments.notes, cfsqltype="cf_sql_text");
        insertPurchase.addParam(name="status", value=arguments.status, cfsqltype="cf_sql_varchar");
        var result = insertPurchase.execute();
        return result.getResult().purchaseId;
    }

    public numeric function addPurchaseDetail(required numeric purchaseId, required numeric productId, required numeric quantity, required numeric unitCost) {
        var insertDetail = new Query(datasource=variables.datasource);
        insertDetail.setSQL("
            INSERT INTO purchaseDetails (purchaseId, productId, quantity, unitCost)
            VALUES (:purchaseId, :productId, :quantity, :unitCost)
            RETURNING purchaseDetailId
        ");
        insertDetail.addParam(name="purchaseId", value=arguments.purchaseId, cfsqltype="cf_sql_integer");
        insertDetail.addParam(name="productId", value=arguments.productId, cfsqltype="cf_sql_integer");
        insertDetail.addParam(name="quantity", value=arguments.quantity, cfsqltype="cf_sql_integer");
        insertDetail.addParam(name="unitCost", value=arguments.unitCost, cfsqltype="cf_sql_decimal");
        var result = insertDetail.execute();
        return result.getResult().purchaseDetailId;
    }

}
