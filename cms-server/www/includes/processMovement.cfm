<!--- processMovement.cfm --->
<cfscript>
    if (structKeyExists(form, "productId") && structKeyExists(form, "movementType") && structKeyExists(form, "quantity")) {
        inventory = new components.Inventory();
        // Asumimos warehouseId = 1 por defecto, puedes ajustarlo según tu lógica
        result = inventory.registerMovement(
            productId = form.productId,
            warehouseId = 1,
            movementType = form.movementType,
            quantity = form.quantity,
            reason = form.reason ?: ""
        );

        if (result.success) {
            session.successMessage = result.message;
        } else {
            session.errorMessage = result.message;
        }
        location(url="index.cfm", addtoken=false);
    } else {
        session.errorMessage = "Datos del formulario incompletos.";
        location(url="index.cfm", addtoken=false);
    }
</cfscript>
