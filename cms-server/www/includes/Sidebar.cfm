<!--- Sidebar.cfm --->
<aside id="logo-sidebar" class="fixed top-0 left-0 z-40 w-64 h-screen transition-transform -translate-x-full md:translate-x-0 bg-white border-r">
    <div class="h-full px-3 py-4 overflow-y-auto">
        <div class="flex items-center ps-2.5 mb-8">
            <img src="https://flowbite.com/docs/images/logo.svg" class="h-8 me-3" alt="Logo">
            <span class="text-xl font-semibold">InventarioPRO</span>
        </div>
        <nav class="space-y-2">
            <a href="index.cfm" class="flex items-center p-2 text-white bg-blue-700 rounded-lg">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path d="M2 10a8 8 0 018-8v8h8a8 8 0 01-8 8V10z"></path><path d="M11 2h-1a8 8 0 00-8 8v1a8 8 0 008 8h1a8 8 0 008-8V10a8 8 0 00-8-8z"></path></svg>
                <span class="ms-3">Dashboard</span>
            </a>
            <a href="#" class="flex items-center p-2 text-gray-900 rounded-lg hover:bg-gray-100">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M5.5 3A2.5 2.5 0 003 5.5v9A2.5 2.5 0 005.5 17h9A2.5 2.5 0 0017 14.5v-9A2.5 2.5 0 0014.5 3h-9zM4 5.5A1.5 1.5 0 015.5 4h9A1.5 1.5 0 0116 5.5v9a1.5 1.5 0 01-1.5 1.5h-9A1.5 1.5 0 014 14.5v-9zM12.5 8a.5.5 0 00-.5-.5h-2a.5.5 0 00-.5.5v2a.5.5 0 00.5.5h2a.5.5 0 00.5-.5V8z" clip-rule="evenodd"/></svg>
                <span class="ms-3">Productos</span>
            </a>
            <a href="#" class="flex items-center p-2 text-gray-900 rounded-lg hover:bg-gray-100">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10.293 3.293a1 1 0 011.414 0l6 6a1 1 0 010 1.414l-6 6a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-4.293-4.293a1 1 0 010-1.414z" clip-rule="evenodd"/></svg>
                <span class="ms-3">Movimientos</span>
            </a>
            <a href="#" class="flex items-center p-2 text-gray-900 rounded-lg hover:bg-gray-100">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a1 1 0 01.78.375l.555.74A1 1 0 0012 4h4a2 2 0 012 2v8a2 2 0 01-2 2H4a2 2 0 01-2-2V4a2 2 0 012-2h4a1 1 0 011 1z"/></svg>
                <span class="ms-3">Categorías</span>
            </a>
            <a href="#" class="flex items-center p-2 text-gray-900 rounded-lg hover:bg-gray-100">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3zm6-3a1 1 0 100 2 1 1 0 000-2zm5.727-4.992A5 5 0 0011 4.5V3a1 1 0 00-2 0v1.5a5 5 0 00-4.727 4.508l-2.076.69A1 1 0 003 10a1 1 0 00-.994 1.11l1.5 9A1 1 0 005 20h10a1 1 0 00.994-.89l1.5-9A1 1 0 0017 10a1 1 0 00-1.927-.992z" clip-rule="evenodd"/></svg>
                <span class="ms-3">Proveedores</span>
            </a>
            <a href="#" class="flex items-center p-2 text-gray-900 rounded-lg hover:bg-gray-100">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M4 4a2 2 0 012-2h8a2 2 0 012 2v12a2 2 0 01-2 2H6a2 2 0 01-2-2V4zm2-1a1 1 0 00-1 1v.5a1 1 0 001 1h8a1 1 0 001-1V4a1 1 0 00-1-1H6zm0 4a1 1 0 00-1 1v4a1 1 0 001 1h8a1 1 0 001-1V8a1 1 0 00-1-1H6z" clip-rule="evenodd"/><path fill-rule="evenodd" d="M7 9a1 1 0 011-1h4a1 1 0 110 2H8a1 1 0 01-1-1zM7 13a1 1 0 011-1h4a1 1 0 110 2H8a1 1 0 01-1-1z" clip-rule="evenodd"/></svg>
                <span class="ms-3">Reportes</span>
            </a>
            <a href="#" class="flex items-center p-2 text-gray-900 rounded-lg hover:bg-gray-100">
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M11.49 3.17c-.38-1.16-1.47-1.47-2.5-1.47-.38 0-.74.07-1.07.19a.75.75 0 00-.77.16 2.05 2.05 0 00-2.48.55C3.39 3.65 3 4.62 3 5.75V11a2 2 0 002 2h3v2a2 2 0 002 2h2a2 2 0 002-2v-2h3a2 2 0 002-2V5.75c0-1.13-.39-2.1-1.08-2.65-.6-.4-1.3-.65-2.02-.77a.75.75 0 00-.77-.16zM7 6a1 1 0 100 2 1 1 0 000-2zm6 0a1 1 0 100 2 1 1 0 000-2zm-6 4a1 1 0 100 2 1 1 0 000-2zm6 0a1 1 0 100 2 1 1 0 000-2z" clip-rule="evenodd"/></svg>
                <span class="ms-3">Configuración</span>
            </a>
        </nav>
    </div>
</aside>
