<cfparam name="attributes" type="struct">
<cfparam name="attributes.chartData" type="string" default="{}">
<div class="bg-white p-6 rounded-lg shadow-sm h-full">
    <h3 class="text-lg font-semibold text-gray-800 mb-4">Movimientos de Stock (Últimos 30 días)</h3>
    <div id="sales-area-chart"></div>
</div>
<script>
document.addEventListener("DOMContentLoaded", function() {
    const data = JSON.parse('<cfoutput>#attributes.chartData#</cfoutput>');
    const options = {
        chart: { type: 'area', height: 350, zoom: { enabled: false }, toolbar: { show: false } },
        series: [
            { name: 'Entradas', data: data.entradas },
            { name: 'Salidas', data: data.salidas }
        ],
        xaxis: { categories: data.labels, labels: { style: { colors: '#6b7280' } } },
        yaxis: { labels: { style: { colors: '#6b7280' } } },
        colors: ['#3b82f6', '#ef4444'],
        dataLabels: { enabled: false },
        stroke: { curve: 'smooth', width: 2 },
        fill: { type: 'gradient', gradient: { opacityFrom: 0.6, opacityTo: 0.1 } },
        legend: { position: 'top', horizontalAlign: 'right' }
    };
    new ApexCharts(document.querySelector("#sales-area-chart"), options).render();
});
</script>
