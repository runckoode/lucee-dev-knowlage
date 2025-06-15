<cfparam name="attributes" type="struct">
<cfparam name="attributes.chartData" type="string" default="{}">
<div class="bg-white p-6 rounded-lg shadow-sm h-full">
    <h3 class="text-lg font-semibold text-gray-800 mb-4">Stock por Categoría</h3>
    <div id="category-donut-chart"></div>
</div>
<script>
document.addEventListener("DOMContentLoaded", function() {
    const data = JSON.parse('<cfoutput>#attributes.chartData#</cfoutput>');
    const options = {
        chart: { type: 'donut', height: 350 },
        series: data.series,
        labels: data.labels,
        legend: { position: 'bottom' },
        responsive: [{ breakpoint: 480, options: { chart: { width: 200 }, legend: { position: 'bottom' } } }]
    };
    new ApexCharts(document.querySelector("#category-donut-chart"), options).render();
});
</script>
