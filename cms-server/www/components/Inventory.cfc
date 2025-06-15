component
    displayname="Inventory"
    debug="true"
    output="false"
    hint="Servicio para gestionar datos de inventario utilizando principios de programación funcional y mejores prácticas."
{

    variables.datasource = 's';

    public struct function getSummaryData() {
        var summary = {};
        var qryResult = "";

        var inventoryValueQuery = "
            SELECT COALESCE(SUM(ps.quantity * p.price), 0) AS total
            FROM productStock ps
            JOIN products p ON ps.productId = p.productId
        ";
        qryResult = queryExecute(inventoryValueQuery, {}, {datasource: variables.datasource});
        summary.totalValue = qryResult.total[1];

        var productsCountQuery = "SELECT COUNT(*) AS total FROM products";
        qryResult = queryExecute(productsCountQuery, {}, {datasource: variables.datasource});
        summary.productsCount = qryResult.total[1];

        var lowStockQuery = "SELECT COUNT(*) AS total FROM productStock WHERE quantity < minStock AND minStock > 0";
        qryResult = queryExecute(lowStockQuery, {}, {datasource: variables.datasource});
        summary.lowStockCount = qryResult.total[1];

        var salesTodayQuery = "
            SELECT COALESCE(SUM(totalAmount), 0) AS total
            FROM sales
            WHERE saleDate >= CURRENT_DATE AND saleDate < CURRENT_DATE + INTERVAL '1 day'
        ";
        qryResult = queryExecute(salesTodayQuery, {}, {datasource: variables.datasource});
        summary.salesToday = qryResult.total[1];

        return summary;
    }

    public array function getMovementTrendsLast30Days() {
        var endDate = now();
        var today = createDate(year(endDate), month(endDate), day(endDate));
        var startDate = dateAdd("d", -29, today);

        var purchasesSql = "
            SELECT CAST(p.purchaseDate AS date) as move_date, SUM(pd.quantity) as total_entradas
            FROM purchases p
            JOIN purchaseDetails pd ON p.purchaseId = pd.purchaseId
            WHERE CAST(p.purchaseDate AS date) >= :startDate AND CAST(p.purchaseDate AS date) <= :endDate
            GROUP BY CAST(p.purchaseDate AS date)
        ";
        var salesSql = "
            SELECT CAST(s.saleDate AS date) as move_date, SUM(sd.quantity) as total_salidas
            FROM sales s
            JOIN saleDetails sd ON s.saleId = sd.saleId
            WHERE CAST(s.saleDate AS date) >= :startDate AND CAST(s.saleDate AS date) <= :endDate
            GROUP BY CAST(s.saleDate AS date)
        ";

        var params = {
            startDate: { value: startDate, cfsqltype: 'cf_sql_date' },
            endDate: { value: today, cfsqltype: 'cf_sql_date' }
        };

        var dailyPurchasesQuery = queryExecute(purchasesSql, params, {datasource: variables.datasource});
        var dailySalesQuery = queryExecute(salesSql, params, {datasource: variables.datasource});

        var purchasesMap = {};
        if (dailyPurchasesQuery.recordCount > 0) {
            for (var i = 1; i <= dailyPurchasesQuery.recordCount; i++) {
                var row = queryGetRow(dailyPurchasesQuery, i);
                purchasesMap[dateFormat(row.move_date, "yyyy-mm-dd")] = row.total_entradas;
            }
        }

        var salesMap = {};
        if (dailySalesQuery.recordCount > 0) {
            for (var i = 1; i <= dailySalesQuery.recordCount; i++) {
                var row = queryGetRow(dailySalesQuery, i);
                salesMap[dateFormat(row.move_date, "yyyy-mm-dd")] = row.total_salidas;
            }
        }

        var trends = [];
        var currentDate = startDate;
        while (currentDate <= today) {
            var formattedDateKey = dateFormat(currentDate, "yyyy-mm-dd");
            var displayDate = dateFormat(currentDate, "Mon dd");

            arrayAppend(trends, {
                trendDate: displayDate,
                totalEntradas: structKeyExists(purchasesMap, formattedDateKey) ? purchasesMap[formattedDateKey] : 0,
                totalSalidas: structKeyExists(salesMap, formattedDateKey) ? salesMap[formattedDateKey] : 0
            });
            currentDate = dateAdd("d", 1, currentDate);
        }

        return trends;
    }

    public query function getStockDistributionByCategory() {
        var sql = "
            SELECT
                pc.categoryName,
                SUM(ps.quantity) as totalStock
            FROM productStock ps
            JOIN products p ON ps.productId = p.productId
            JOIN productCategories pc ON p.categoryId = pc.categoryId
            GROUP BY pc.categoryName
            HAVING SUM(ps.quantity) > 0
            ORDER BY totalStock DESC;
        ";
        return queryExecute(sql, {}, {datasource: variables.datasource});
    }

    public query function getLowStockProducts(numeric limit = 5) {
        var safeLimit = val(limit) > 0 ? val(limit) : 5;
        var sql = "
            SELECT p.productName, ps.quantity, ps.minStock
            FROM productStock ps
            JOIN products p ON ps.productId = p.productId
            WHERE ps.quantity < ps.minStock AND ps.minStock > 0
            ORDER BY (ps.minStock - ps.quantity) DESC
            LIMIT :limit
        ";
        var params = { limit: { value: safeLimit, cfsqltype: 'cf_sql_integer' } };
        return queryExecute(sql, params, {datasource: variables.datasource});
    }

    public query function getRecentMovements(numeric limit = 5) {
        var safeLimit = val(limit) > 0 ? val(limit) : 5;
        var sql = "
            (
                SELECT 'Entrada' as type, p.productName, pd.quantity, pu.purchaseDate as moveDate
                FROM purchaseDetails pd
                JOIN purchases pu ON pd.purchaseId = pu.purchaseId
                JOIN products p ON pd.productId = p.productId
            )
            UNION ALL
            (
                SELECT 'Salida' as type, p.productName, sd.quantity, s.saleDate as moveDate
                FROM saleDetails sd
                JOIN sales s ON sd.saleId = s.saleId
                JOIN products p ON sd.productId = p.productId
            )
            ORDER BY moveDate DESC
            LIMIT :limit
        ";
        var params = { limit: { value: safeLimit, cfsqltype: 'cf_sql_integer' } };
        return queryExecute(sql, params, {datasource: variables.datasource});
    }

    public query function getBrands() {
        var brands = new Query(datasource = variables.datasource);
        brands.setSQL('
            SELECT brandId, brandName, created_at, updated_at
            FROM brands
            ORDER BY brandName ASC
        ');
        return brands.execute().getResult();
    }

    public query function getProviders() {
        var providers = new Query(datasource = variables.datasource);
        providers.setSQL('
            SELECT providerId, providerName, contactName, phone, email, address, created_at, updated_at
            FROM providers
            ORDER BY providerName ASC
        ');
        return providers.execute().getResult();
    }

    public query function getProducts(numeric categoryId = 0, numeric brandId = 0) {
        var sql = "
            SELECT p.productId, p.productName
            FROM products p
            WHERE 1=1
        ";
        var params = {};

        if (structKeyExists(arguments, "categoryId") && arguments.categoryId > 0) {
            sql &= " AND p.categoryId = :catId";
            params.catId = { value: arguments.categoryId, cfsqltype: 'cf_sql_integer' };
        }

        if (structKeyExists(arguments, "brandId") && arguments.brandId > 0) {
            sql &= " AND p.brandId = :brandId";
            params.brandId = { value: arguments.brandId, cfsqltype: 'cf_sql_integer' };
        }

        sql &= " ORDER BY p.productName ASC";

        return queryExecute(sql, params, {datasource: variables.datasource});
    }

    public array function getStockByProduct(required numeric productId) {
        var stockQuery = new Query(
            datasource = variables.datasource,
            sql = '
                SELECT ps.stockId, ps.productId, ps.warehouseId, w.warehouseName, ps.quantity, ps.minStock, ps.maxStock
                FROM productStock ps
                LEFT JOIN warehouses w ON ps.warehouseId = w.warehouseId
                WHERE ps.productId = :productId
            '
        );
        stockQuery.addParam(name = 'productId', value = arguments.productId, cfsqltype = 'cf_sql_integer');
        var result = stockQuery.execute().getResult();

        return valueArray(result).map(function(row) {
            return {
                'stockId': row.stockId,
                'warehouse': row.warehouseName,
                'quantity': row.quantity,
                'minStock': row.minStock,
                'maxStock': row.maxStock
            };
        });
    }

    public array function getLowStockProductsByWarehouse(numeric warehouseId) {
        var sql = "
            SELECT p.productId, p.productName, ps.quantity, ps.minStock, w.warehouseName
            FROM productStock ps
            JOIN products p ON ps.productId = p.productId
            JOIN warehouses w ON ps.warehouseId = w.warehouseId
            WHERE ps.quantity < ps.minStock
        ";
        var params = {};

        if (arguments.keyExists("warehouseId") && arguments.warehouseId > 0) {
            sql &= " AND ps.warehouseId = :warehouseId";
            params.warehouseId = { value: arguments.warehouseId, cfsqltype: 'cf_sql_integer' };
        }

        var result = queryExecute(sql, params, {datasource: variables.datasource});

        return valueArray(result).filter(function(row) {
            return row.quantity < row.minStock;
        });
    }

    public boolean function updateStock(
        required numeric productId,
        required numeric warehouseId,
        required numeric quantityChange
    ) {
        var currentStockSql = '
            SELECT quantity
            FROM productStock
            WHERE productId = :productId AND warehouseId = :warehouseId
        ';
        var currentStockParams = {
            productId: { value: arguments.productId, cfsqltype: 'cf_sql_integer' },
            warehouseId: { value: arguments.warehouseId, cfsqltype: 'cf_sql_integer' }
        };
        var currentStockResult = queryExecute(currentStockSql, currentStockParams, {datasource: variables.datasource});

        if (currentStockResult.recordCount == 0) {
            return false;
        }

        var newQuantity = currentStockResult.quantity[1] + arguments.quantityChange;

        if (newQuantity < 0) {
            return false;
        }

        var updateSql = '
            UPDATE productStock
            SET quantity = :newQuantity,
                lastUpdate = NOW()
            WHERE productId = :productId AND warehouseId = :warehouseId
        ';
        var updateParams = {
            newQuantity: { value: newQuantity, cfsqltype: 'cf_sql_integer' },
            productId: { value: arguments.productId, cfsqltype: 'cf_sql_integer' },
            warehouseId: { value: arguments.warehouseId, cfsqltype: 'cf_sql_integer' }
        };
        queryExecute(updateSql, updateParams, {datasource: variables.datasource});

        return true;
    }

    public query function getAllBrands() {
        return queryExecute('SELECT * FROM brands ORDER BY brandName', {}, {datasource: variables.datasource});
    }

    public query function getAllWarehouses() {
        return queryExecute('SELECT * FROM warehouses ORDER BY warehouseName', {}, {datasource: variables.datasource});
    }

    public query function getAllCategories() {
        return queryExecute(
            'SELECT * FROM productCategories ORDER BY categoryName',
            {},
            {datasource: variables.datasource}
        );
    }

    public query function getAllProviders() {
        return queryExecute('SELECT * FROM providers ORDER BY providerName', {}, {datasource: variables.datasource});
    }

    public query function getAllProducts() {
        return queryExecute(
            '
            SELECT p.productId, p.productName, p.price, p.description,
                   c.categoryName, b.brandName, pr.providerName,
                   p.created_at, p.updated_at
              FROM products p
              JOIN productCategories c ON p.categoryId = c.categoryId
              JOIN brands b ON p.brandId = b.brandId
              LEFT JOIN providers pr ON p.providerId = pr.providerId
            ORDER BY p.productName
            ',
            {},
            {datasource: variables.datasource}
        );
    }

    public query function getProductStock() {
        return queryExecute(
            '
            SELECT s.stockId, s.productId, p.productName, s.warehouseId, w.warehouseName,
                   s.quantity, s.minStock, s.maxStock, s.lastUpdate
              FROM productStock s
              JOIN products p ON s.productId = p.productId
              JOIN warehouses w ON s.warehouseId = w.warehouseId
            ORDER BY w.warehouseName, p.productName
            ',
            {},
            {datasource: variables.datasource}
        );
    }

    public query function getRecentSales(numeric limit = 10) {
        var safeLimit = val(limit);
        if (safeLimit <= 0) safeLimit = 10;
        return queryExecute(
            '
            SELECT saleId, saleDate, totalAmount, customerName, status
              FROM sales
            ORDER BY saleDate DESC
            LIMIT :limit
            ',
            { limit: {value: safeLimit, cfsqltype: 'cf_sql_integer'} },
            {datasource: variables.datasource}
        );
    }

    public query function getRecentPurchases(numeric limit = 10) {
        var safeLimit = val(limit);
        if (safeLimit <= 0) safeLimit = 10;
        return queryExecute(
            '
            SELECT purchaseId, purchaseDate, totalAmount, providerId, status
              FROM purchases
            ORDER BY purchaseDate DESC
            LIMIT :limit
            ',
            { limit: {value: safeLimit, cfsqltype: 'cf_sql_integer'} },
            {datasource: variables.datasource}
        );
    }

    public array function getRecentTransactions(numeric limit = 5) {
        var safeLimit = max(val(limit), 1);
        return queryExecute(
            '
            (SELECT ''sale'' as type, saleDate as date, totalAmount as amount, customerName as detail FROM sales)
             UNION ALL
             (SELECT ''purchase'' as type, purchaseDate as date, totalAmount as amount, providerName as detail FROM purchases)
             ORDER BY date DESC LIMIT :limit
            ',
            { limit: {value: safeLimit, cfsqltype: 'cf_sql_integer'} },
            {datasource: variables.datasource, returntype: 'array'}
        );
    }

    public struct function getInventorySummary() {
        var qryResultBrands = queryExecute('SELECT COUNT(*) AS total FROM brands', {}, {datasource: variables.datasource});
        var qryResultProducts = queryExecute('SELECT COUNT(*) AS total FROM products', {}, {datasource: variables.datasource});
        var qryResultWarehouses = queryExecute('SELECT COUNT(*) AS total FROM warehouses', {}, {datasource: variables.datasource});
        var qryResultProviders = queryExecute('SELECT COUNT(*) AS total FROM providers', {}, {datasource: variables.datasource});
        var qryResultLowStock = queryExecute(
            'SELECT COUNT(*) AS total FROM productStock WHERE quantity < minStock',
            {},
            {datasource: variables.datasource}
        );

        return {
            brands: qryResultBrands.total[1],
            products: qryResultProducts.total[1],
            warehouses: qryResultWarehouses.total[1],
            providers: qryResultProviders.total[1],
            lowStock: qryResultLowStock.total[1]
        };
    }

    public array function getProductsDashboard() {
        return queryExecute(
            '
            SELECT p.productId, p.productName, p.price,
                   c.categoryName, b.brandName, ps.quantity, ps.minStock, ps.maxStock
             FROM products p
             JOIN productCategories c ON p.categoryId = c.categoryId
             JOIN brands b ON p.brandId = b.brandId
             JOIN productStock ps ON p.productId = ps.productId
             ORDER BY ps.quantity DESC
            ',
            {},
            {datasource: variables.datasource, returntype: 'array'}
        ).map(function(item) {
            return {
                productId: item.productId,
                productName: item.productName,
                price: item.price,
                categoryName: item.categoryName,
                brandName: item.brandName,
                quantity: item.quantity,
                stockStatus: (item.quantity < item.minStock && item.minStock > 0) ? 'low' : 'ok'
            };
        });
    }

}
