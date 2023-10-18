{
    "hygenists": {$hygenists->status()},
    "unassigned": {
        "data":
            {$unassigned->currentUnassignedCalls()},
        "pagination": {
            "rows": {
                "total": "{$unassigned->_rowCount()}",
                "from": "{$unassigned->_fromRow()}",
                "to": "{$unassigned->_toRow()}"
            },
            "pages": {
                "total": "{$unassigned->_pages()}",
                "current": "{$unassigned->_page()}"
            }
        }
    },
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
    "requested": { 
        "data":
            {$requested->currentRequestingAppointmentCalls()},
        "pagination": {
            "rows": {
                "total": "{$requested->_rowCount()}",
                "from": "{$requested->_fromRow()}",
                "to": "{$requested->_toRow()}"
            },
            "pages": {
                "total": "{$requested->_pages()}",
                "current": "{$requested->_page()}"
            }          
        }
    },    
    "completed": {
        "data":    
            {$completed->currentCouncelingCompletedContacts()},
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