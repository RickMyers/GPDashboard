{
    "scanning": { 
        "data":
            {$scanning->odScanningForms()},
        "pagination": {
            "rows": {
                "total": "{$scanning->_rowCount()}",
                "from": "{$scanning->_fromRow()}",
                "to": "{$scanning->_toRow()}"
            },
            "pages": {
                "total": "{$scanning->_pages()}",
                "current": "{$scanning->_page()}"
            }          
        }
    },
    "screening": { 
        "data":
            {$screening->odScreeningForms()},
        "pagination": {
            "rows": {
                "total": "{$screening->_rowCount()}",
                "from": "{$screening->_fromRow()}",
                "to": "{$screening->_toRow()}"
            },
            "pages": {
                "total": "{$screening->_pages()}",
                "current": "{$screening->_page()}"
            }          
        }
    },
    "od_staging": { 
        "data":
            {$staging->odStagingForms()},
        "pagination": {
            "rows": {
                "total": "{$staging->_rowCount()}",
                "from": "{$staging->_fromRow()}",
                "to": "{$staging->_toRow()}"
            },
            "pages": {
                "total": "{$staging->_pages()}",
                "current": "{$staging->_page()}"
            }          
        }
    }
}
