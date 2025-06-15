<cfparam name="attributes" type="struct">
<cfparam name="attributes.summary" type="struct" default="#{totalValue:0,productsCount:0,lowStockCount:0,salesToday:0}#">
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
    <div class="bg-white p-6 rounded-lg shadow-sm"><h3 class="text-sm font-medium text-gray-500">Valor del Inventario</h3><p class="mt-2 text-3xl font-bold text-gray-900">$<cfoutput>#numberFormat(attributes.summary.totalValue, "_,.00")#</cfoutput></p></div>
    <div class="bg-white p-6 rounded-lg shadow-sm"><h3 class="text-sm font-medium text-gray-500">Productos Activos</h3><p class="mt-2 text-3xl font-bold text-gray-900"><cfoutput>#attributes.summary.productsCount#</cfoutput></p></div>
    <div class="bg-white p-6 rounded-lg shadow-sm"><h3 class="text-sm font-medium text-gray-500">Items con Bajo Stock</h3><p class="mt-2 text-3xl font-bold text-red-600"><cfoutput>#attributes.summary.lowStockCount#</cfoutput></p></div>
    <div class="bg-white p-6 rounded-lg shadow-sm"><h3 class="text-sm font-medium text-gray-500">Ventas (Hoy)</h3><p class="mt-2 text-3xl font-bold text-green-600">$<cfoutput>#numberFormat(attributes.summary.salesToday, "_,.00")#</cfoutput></p></div>
</div>
