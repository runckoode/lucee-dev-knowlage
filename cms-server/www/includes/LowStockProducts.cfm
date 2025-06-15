<cfparam name="attributes" type="struct">
<cfparam name="attributes.productos" type="query" default="#queryNew('productName,quantity')#">
<div class="bg-white p-6 rounded-lg shadow-sm">
    <h3 class="text-lg font-semibold text-gray-800 mb-4">Alerta de Stock Bajo</h3>
    <ul role="list" class="divide-y divide-gray-200">
        <cfif attributes.productos.recordCount gt 0>
            <cfloop query="attributes.productos">
                <li class="py-3 sm:py-4">
                    <div class="flex items-center space-x-4">
                        <div class="flex-shrink-0"><span class="h-8 w-8 rounded-full bg-red-100 flex items-center justify-center"><svg class="h-5 w-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg></span></div>
                        <div class="flex-1 min-w-0"><p class="text-sm font-medium text-gray-900 truncate"><cfoutput>#attributes.productos.productName#</cfoutput></p></div>
                        <div class="inline-flex items-center text-base font-semibold text-red-600"><cfoutput>#attributes.productos.quantity#</cfoutput> unid.</div>
                    </div>
                </li>
            </cfloop>
        <cfelse>
            <p class="text-sm text-gray-500">No hay productos con stock bajo.</p>
        </cfif>
    </ul>
</div>
