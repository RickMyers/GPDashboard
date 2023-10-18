{

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
    "completed-counseling": {
        "data":
            {$counseled->currentCompletedCounseling()},
        "pagination": {
            "rows": {
                "total": "{$counseled->_rowCount()}",
                "from": "{$counseled->_fromRow()}",
                "to": "{$counseled->_toRow()}"
            },
            "pages": {
                "total": "{$counseled->_pages()}",
                "current": "{$counseled->_page()}"
            }
        }
    },
    "completed": {
        "data":
            {$completed->completedContacts()},
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
