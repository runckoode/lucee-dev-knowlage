<cfparam name="attributes" type="struct">
<cfparam name="attributes.message" type="string" default="Ha ocurrido un error inesperado.">
<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-8" role="alert">
    <strong class="font-bold">Error:</strong>
    <span class="block sm:inline"><cfoutput>#attributes.message#</cfoutput></span>
</div>
