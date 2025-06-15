<cfscript>
    // 1. Inicializar todas las variables para evitar errores si la llamada al servicio falla.
    summaryData = {};
    movementTrends = queryNew("");
    categoryDistribution = queryNew("");
    lowStockProducts = queryNew("");
    recentMovements = queryNew("");
    productsForDropdown = queryNew("");

 
function prepareChartData() {
    var movementTrends = variables.inventory.getMovementTrendsLast30Days();
    //writeDump(movementTrends);
    var categoryDistribution = variables.inventory.getStockDistributionByCategory();
    // Prepare movement data
    var movementData = {
        "labels": [],
        "entradas": [],
        "salidas": []
    };


    for (var trend in movementTrends) {
        arrayAppend(movementData.labels, trend.trendDate);
        arrayAppend(movementData.entradas, trend.totalEntradas);
        arrayAppend(movementData.salidas, trend.totalSalidas);
    }
    
    // Prepare category data
    var categoryData = {
        "labels": valueArray(categoryDistribution, "categoryName"),
        "series": valueArray(categoryDistribution, "totalStock")
    };
    
    return {
        movementChartJSON: serializeJSON(movementData),
        categoryChartJSON: serializeJSON(categoryData)
    };
}
    try {
        inventory = application.inventoryService;

        summaryData = inventory.getSummaryData();
        
        categoryDistribution = inventory.getStockDistributionByCategory();
        lowStockProducts = inventory.getLowStockProducts(5);
   
        recentMovements = inventory.getRecentMovements(5);
      //  writeDump(recentMovements);
        productsForDropdown = inventory.getProducts();
       // writeDump(productsForDropdown);

        variables.generatedChartData = prepareChartData();
        variables.movementChartJSON = variables.generatedChartData.movementChartJSON;
        variables.categoryChartJSON = variables.generatedChartData.categoryChartJSON;

    } catch (any e) {
        errorMessage = "Error in inventoryService: " & e.message;
        writeDump(e)
    }
</cfscript>


<!DOCTYPE html>
<html lang="es" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard de Inventario Avanzado</title>
    <!--- Se moverá a un archivo local en el siguiente paso --->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.css" rel="stylesheet">
    <style>body{font-family:'Inter',sans-serif;background-color:#f3f4f6;}.apexcharts-tooltip{background:#fff;border:1px solid ##e2e8f0;color:##1a202c;}</style>
</head>
<body class="h-full">
    <!--- El resto del body de index.cfm permanece igual --->
    <cfinclude template="./includes/Sidebar.cfm">
    <main class="lg:ml-64 p-4 sm:p-6 lg:p-8">
        <h1 class="text-3xl font-bold text-gray-800 mb-6">Dashboard de Operaciones</h1>
        <cfif structKeyExists(variables, "errorMessage")>
            <cfscript>attributes = { message: variables.errorMessage };</cfscript>
            <cfinclude template="./includes/ErrorMessage.cfm">
        </cfif>
        <cfscript>attributes = { summary: variables.summaryData };</cfscript>
        <cfinclude template="./includes/SummaryCards.cfm">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-6">
            <div class="lg:col-span-2">
                <cfscript>attributes = { chartData: variables.movementChartJSON };</cfscript>
                <cfinclude template="./includes/SalesChart.cfm">
            </div>
            <div>
                <cfscript>attributes = { chartData: variables.categoryChartJSON };</cfscript>
                <cfinclude template="./includes/CategoryStockChart.cfm">
            </div>
        </div>
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-6">
            <div class="lg:col-span-2">
                <cfscript>attributes = { movimientos: variables.recentMovements };</cfscript>
                <cfinclude template="./includes/RecentMovements.cfm">
            </div>
            <div>
                <cfscript>attributes = { productos: variables.lowStockProducts };</cfscript>
                <cfinclude template="./includes/LowStockProducts.cfm">
            </div>
        </div>
    </main>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
</body>
</html>
