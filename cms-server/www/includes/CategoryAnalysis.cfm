<cfparam name="attributes" type="struct">
<cfparam name="attributes.categorias" type="query" default="#queryNew('categoryName,totalProducts,lowStockItems,totalQuantityInStock')#">
<div class="bg-white rounded-xl shadow-lg p-6 mb-8">
    <h3 class="text-lg font-semibold mb-4">Análisis por Categoría</h3>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <cfif attributes.categorias.recordCount gt 0>
            <cfloop query="attributes.categorias">
                <div class="p-4 bg-gray-50 rounded-lg">
                    <h4 class="font-medium text-gray-900"><cfoutput>#attributes.categorias.categoryName#</cfoutput></h4>
                    <p><cfoutput>#attributes.categorias.totalProducts#</cfoutput> Productos</p>
                </div>
            </cfloop>
        <cfelse>
            <div class="col-span-2 text-center text-gray-500">No hay datos de categorías para analizar.</div>
        </cfif>
    </div>
</div>
