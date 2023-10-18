{
    "signed": { 
        "data":
            {$signed->signedVisionPackets()},
        "pagination": {
            "rows": {
                "total": "{$signed->_rowCount()}",
                "from": "{$signed->_fromRow()}",
                "to": "{$signed->_toRow()}"
            },
            "pages": {
                "total": "{$signed->_pages()}",
                "current": "{$signed->_page()}"
            }          
        }
    },
    "archive": { 
        "data":
            {$archive->archivedVisionPackets()},
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
