<cfparam name="attributes" type="struct">
<cfparam name="attributes.movimientos" type="query" default="#queryNew('productName,type,quantity,moveDate')#">

<cfscript>
// Helper functions
function getIconData(type) {
    return {
        class: type == 'Entrada' ? 'bg-green-100' : 'bg-red-100',
        color: type == 'Entrada' ? 'text-green-500' : 'text-red-500',
        path: type == 'Entrada' 
            ? '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>'
            : '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 12H6"/>'
    };
}

function renderTimelineIcon(type) {
    var iconData = getIconData(type);
    return '
        <span class="h-8 w-8 rounded-full #iconData.class# flex items-center justify-center ring-8 ring-white">
            <svg class="h-5 w-5 #iconData.color#" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                #iconData.path#
            </svg>
        </span>
    ';
}

function renderMovementItem(row, isLast) {
    return '
        <li>
            <div class="relative pb-8">
                #!isLast ? '<span class="absolute top-4 left-4 -ml-px h-full w-0.5 bg-gray-200"></span>' : ''#
                <div class="relative flex space-x-3">
                    <div>#renderTimelineIcon(row.type)#</div>
                    <div class="min-w-0 flex-1 pt-1.5 flex justify-between space-x-4">
                        <div>
                            <p class="text-sm text-gray-500">
                                #EncodeForHTML(row.type)# de 
                                <strong>#EncodeForHTML(row.quantity)#</strong> unidades de 
                                <strong>#EncodeForHTML(row.productName)#</strong>
                            </p>
                        </div>
                        <div class="text-right text-sm whitespace-nowrap text-gray-500">
                            <time>#dateFormat(row.moveDate, "mmm dd")#</time>
                        </div>
                    </div>
                </div>
            </div>
        </li>
    ';
}

function renderMovementsList(movimientos) {
    if (movimientos.recordCount == 0) {
        return '<li><p class="text-sm text-gray-500">No hay movimientos recientes.</p></li>';
    }

    return movimientos.reduce((output, row, index) => {
        return output & renderMovementItem(row, index == movimientos.recordCount);
    }, '');
}
</cfscript>

<div class="bg-white p-6 rounded-lg shadow-sm">
    <h3 class="text-lg font-semibold text-gray-800 mb-4">Movimientos Recientes</h3>
    <div class="flow-root">
        <ul role="list" class="-mb-8">
            <cfoutput>#renderMovementsList(attributes.movimientos)#</cfoutput>
        </ul>
    </div>
</div>