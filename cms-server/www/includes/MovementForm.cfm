<cfparam name="attributes" type="struct">
<cfparam name="attributes.movimientos" type="query" default="#queryNew('productName,productId,type,quantity,moveDate,detail')#">

<cfscript>
    function renderTableHeader() {
        return '
            <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                <tr>
                    <th class="px-6 py-3">Producto</th>
                    <th class="px-6 py-3">Tipo</th>
                    <th class="px-6 py-3">Cantidad</th>
                    <th class="px-6 py-3">Fecha</th>
                </tr>
            </thead>
        ';
    }

    function renderMovementRow(row) {
        return '
            <tr class="bg-white border-b hover:bg-gray-50">
                <td class="px-6 py-4 font-medium text-gray-900">#EncodeForHTML(row.productName)#</td>
                <td class="px-6 py-4">#EncodeForHTML(row.type)#</td>
                <td class="px-6 py-4">#EncodeForHTML(row.quantity)#</td>
                <td class="px-6 py-4">#dateFormat(row.moveDate, "yyyy-mm-dd")#</td>
            </tr>
        ';
    }

    function renderEmptyState() {
        return '<tr><td colspan="4" class="px-6 py-4 text-center">No hay movimientos recientes.</td></tr>';
    }

    function renderTableBody(movements) {
        if (movements.recordCount == 0) {
            return renderEmptyState();
        }

        var output = '';
        for (var row in movements) {
            output &= renderMovementRow(row);
        }
        return output;
    }
</cfscript>

<div class="bg-white rounded-xl shadow-lg overflow-hidden mb-8">
    <div class="p-6 border-b">
        <h2 class="text-xl font-semibold">Historial de Movimientos</h2>
    </div>
    <div class="overflow-x-auto">
        <table class="w-full text-sm text-left text-gray-500">
            <cfoutput>
                #renderTableHeader()#
                <tbody>
                    #renderTableBody(attributes.movimientos)#
                </tbody>
            </cfoutput>
        </table>
    </div>
</div>