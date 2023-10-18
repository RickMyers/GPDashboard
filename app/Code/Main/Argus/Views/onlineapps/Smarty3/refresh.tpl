{
    "oainq": {
        "data":
            {$new->fetch()},
        "pagination": {
            "rows": {
                "total": "{$new->_rowCount()}",
                "from": "{$new->_fromRow()}",
                "to": "{$new->_toRow()}"
            },
            "pages": {
                "total": "{$new->_pages()}",
                "current": "{$new->_page()}"
            }
        }
    },
    "oaipq": { 
        "data":
            {$inprogress->fetch()},
        "pagination": {
            "rows": {
                "total": "{$inprogress->_rowCount()}",
                "from": "{$inprogress->_fromRow()}",
                "to": "{$inprogress->_toRow()}"
            },
            "pages": {
                "total": "{$inprogress->_pages()}",
                "current": "{$inprogress->_page()}"
            }
        }            
    },    
    "oacaq": { 
        "data":
            {$completed->fetch()},
        "pagination": {
            "rows": {
                "total": "{$completed->_rowCount()}",
                "from": "{$completed->_fromRow()}",
                "to": "{$completed->_toRow()}"
            },
            "pages": {
                "total": "{$completed->_pages()}",
                "current": "{$completed->_page()}"
            }          
        }
    },    
    "oaerr": { 
        "data":
            {$errored->fetch()},
        "pagination": {
            "rows": {
                "total": "{$errored->_rowCount()}",
                "from": "{$errored->_fromRow()}",
                "to": "{$errored->_toRow()}"
            },
            "pages": {
                "total": "{$errored->_pages()}",
                "current": "{$errored->_page()}"
            }          
        }
    }
}