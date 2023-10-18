{
    "icq": {
        "data":
            {$inbound->inboundRegistrationForms()},
        "pagination": {
            "rows": {
                "total": "{$inbound->_rowCount()}",
                "from": "{$inbound->_fromRow()}",
                "to": "{$inbound->_toRow()}"
            },
            "pages": {
                "total": "{$inbound->_pages()}",
                "current": "{$inbound->_page()}"
            }
        }
    },
    "pcq": { 
        "data":
            {$processing->processingRegistrationForms()},
        "pagination": {
            "rows": {
                "total": "{$processing->_rowCount()}",
                "from": "{$processing->_fromRow()}",
                "to": "{$processing->_toRow()}"
            },
            "pages": {
                "total": "{$processing->_pages()}",
                "current": "{$processing->_page()}"
            }
        }            
    },    
    "acq": { 
        "data":
            {$archive->archivedRegistrationForms()},
        "pagination": {
            "rows": {
                "total": "{$archive->_rowCount()}",
                "from": "{$archive->_fromRow()}",
                "to": "{$archive->_toRow()}"
            },
            "pages": {
                "total": "{$archive->_pages()}",
                "current": "{$archive->_page()}"
            }          
        }
    }
}