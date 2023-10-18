{
    "{$queue_id}": {
        "data":
            {$forms->queueContents()},
        "pagination": {
            "rows": {
                "total": "{$forms->_rowCount()}",
                "from": "{$forms->_fromRow()}",
                "to": "{$forms->_toRow()}"
            },
            "pages": {
                "total": "{$forms->_pages()}",
                "current": "{$forms->_page()}"
            }
        }
    }
}
