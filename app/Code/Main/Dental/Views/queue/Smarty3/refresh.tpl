{
    "dental_new": {
        "data":
            {$new->queueContents()},
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
    "dental_inprogress": {
        "data":
            {$inprogress->queueContents()},
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
    "dental_completed": { 
        "data":
            {$completed->queueContents()},
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