{
    "hygenists": {$hygenists->status()},
    "unassigned": {
        "data":
            {$unassigned->currentUnassignedContacts()},
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
            {$queued->currentQueuedContacts()},
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
    "onhold": {
        "data":
            {$onhold->currentOnHoldContacts()},
        "pagination": {
            "rows": {
                "total": "{$onhold->_rowCount()}",
                "from": "{$onhold->_fromRow()}",
                "to": "{$onhold->_toRow()}"
            },
            "pages": {
                "total": "{$onhold->_pages()}",
                "current": "{$onhold->_page()}"
            }
        }
    },
    "returned": {
        "data":
            {$returned->currentReturnedContacts()},
        "pagination": {
            "rows": {
                "total": "{$returned->_rowCount()}",
                "from": "{$returned->_fromRow()}",
                "to": "{$returned->_toRow()}"
            },
            "pages": {
                "total": "{$returned->_pages()}",
                "current": "{$returned->_page()}"
            }
        }
    },    
    "requested": {
        "data":
            {$requested->currentRequestingAppointment()},
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
            {$completed->currentCompletedCounseling()},
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