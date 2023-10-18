{
    "ipa_clients": { 
        "data":
            {$clients->ipaClientForms()},
        "pagination": {
            "rows": {
                "total": "{$clients->_rowCount()}",
                "from": "{$clients->_fromRow()}",
                "to": "{$clients->_toRow()}"
            },
            "pages": {
                "total": "{$clients->_pages()}",
                "current": "{$clients->_page()}"
            }          
        }
    },
    "ipa_physicians": { 
        "data":
            {$physicians->ipaPhysicianForms()},
        "pagination": {
            "rows": {
                "total": "{$physicians->_rowCount()}",
                "from": "{$physicians->_fromRow()}",
                "to": "{$physicians->_toRow()}"
            },
            "pages": {
                "total": "{$physicians->_pages()}",
                "current": "{$physicians->_page()}"
            }          
        }
    }
}

