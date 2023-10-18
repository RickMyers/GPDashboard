{
    "queued": { 
        "data":
            {$queued->currentQueuedCalls()},
        "pagination": {
            "rows": {
                "total": "{$queued->_rowCount()}",
                "from": "{$queued->_fromRow()}",
                "to": "{$queued->_toRow()}"
            },
            "pages": {
                "total": "{$queued->_pages()}",
                "current": "{$queued->_page()}"
            }
        }            
    },    
    "in-progress": { 
        "data":
            {$inprogress->currentInProgressCalls()},
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
    "completed": {
        "data":    
            {$completed->currentCompletedCalls()},
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
    }
}