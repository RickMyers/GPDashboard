{
    "admin_required": { 
        "data":
            {$admin->formsRequiringAdmin()},
        "pagination": {
            "rows": {
                "total": "{$admin->_rowCount()}",
                "from": "{$admin->_fromRow()}",
                "to": "{$admin->_toRow()}"
            },
            "pages": {
                "total": "{$admin->_pages()}",
                "current": "{$admin->_page()}"
            }          
        }
    }
}

