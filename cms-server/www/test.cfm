<cfscript>
    summary = {};
    productosActivos = queryNew("", "");
    tendenciasVentas = [];
    analisisPorCategoria = queryNew("", "");
    proveedoresRegistrados = queryNew("", "");
    historialMovimientos = queryNew("", "");
    productosParaDropdown = queryNew("", "");

    // Obtener y mostrar la hora actual
    currentTime = now();
    formattedTime = dateTimeFormat(currentTime, "yyyy-mm-dd HH:nn:ss");
    writeOutput("<p>Hora actual: #formattedTime#</p>");

    try {
        inve = new components.Inventory();

        // Mostrar los datos de getBrands usando writeDump para inspeccionar el resultado de la consulta
        brands = inve.getProviders();
        writeOutput("<p>Marcas obtenidas de la base de datos:</p>");
        writeDump(brands);

    } catch (any e) {
        errorMessage = "Ocurrió un error al cargar los datos del dashboard: " & e.message & " - " & e.Detail;
        writeOutput("<p>Error: #errorMessage#</p>");

        summary = {
            productosTotales: 0,
            totalValorInventario: 0,
            articulosBajoStock: 0,
            movimientosRecientes: 0
        };
        productosActivos = queryNew("", "");
        tendenciasVentas = [];
        analisisPorCategoria = queryNew("", "");
        proveedoresRegistrados = queryNew("", "");
        historialMovimientos = queryNew("", "");
        productosParaDropdown = queryNew("", "");
    }
</cfscript>
