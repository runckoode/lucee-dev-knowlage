component {

    this.name = 'InventoryApp' & hash(getDirectoryFromPath(cgi.script_name));
    this.sessionManagement = true;
    this.sessionTimeout = createTimespan(0, 8, 0, 0);
    this.applicationTimeout = createTimespan(2, 0, 0, 0);

    public boolean function onApplicationStart() {
        application.inventoryService = new components.Inventory();
        return true;
    }

    public boolean function onRequestStart(required string targetPage) {
        return true;
    }

}
