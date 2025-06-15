<cfparam name="attributes" type="struct">
<cfparam name="attributes.movimientos" type="query" default="#queryNew('productName,productId,type,quantity,moveDate,detail')#">
<div class="bg-white rounded-xl shadow-lg overflow-hidden mb-8">
    <div class="p-6 border-b"><h2 class="text-xl font-semibold">Historial de Movimientos</h2></div>
    <div class="overflow-x-auto">
        <table class="w-full text-sm text-left text-gray-500">
            <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                <tr>
                    <th class="px-6 py-3">Producto</th>
                    <th class="px-6 py-3">Tipo</th>
                    <th class="px-6 py-3">Cantidad</th>
                    <th class="px-6 py-3">Fecha</th>
                </tr>
            </thead>
            <tbody>
                <cfif attributes.movimientos.recordCount gt 0>
                    <cfloop query="attributes.movimientos">
                        <tr class="bg-white border-b">
                            <td class="px-6 py-4 font-medium text-gray-900"><cfoutput>#attributes.movimientos.productName#</cfoutput></td>
                            <td class="px-6 py-4"><cfoutput>#attributes.movimientos.type#</cfoutput></td>
                            <td class="px-6 py-4"><cfoutput>#attributes.movimientos.quantity#</cfoutput></td>
                            <td class="px-6 py-4"><cfoutput>#dateFormat(attributes.movimientos.moveDate, "yyyy-mm-dd")#</cfoutput></td>
                        </tr>
                    </cfloop>
                <cfelse>
                    <tr><td colspan="4" class="px-6 py-4 text-center">No hay movimientos recientes.</td></tr>
                </cfif>
            </tbody>
        </table>
    </div>
</div>
