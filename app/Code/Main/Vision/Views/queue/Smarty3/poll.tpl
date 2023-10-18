{
    "staging": {
        "data":
            {$staging->stagingVisionPackets()},
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
    },
    "inbound": { 
        "data":
            {$inbound->inboundVisionPackets()},
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
    "outbound": { 
        "data":
            {$outbound->outboundVisionPackets()},
        "pagination": {
            "rows": {
                "total": "{$outbound->_rowCount()}",
                "from": "{$outbound->_fromRow()}",
                "to": "{$outbound->_toRow()}"
            },
            "pages": {
                "total": "{$outbound->_pages()}",
                "current": "{$outbound->_page()}"
            }          
        }
    }
}