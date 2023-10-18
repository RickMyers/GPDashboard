{
    "pcpqueue": {
        "data":
            {$pcpqueue->screeningFormsByPCP()},
        "pagination": {
            "rows": {
                "total": "{$pcpqueue->_rowCount()}",
                "from": "{$pcpqueue->_fromRow()}",
                "to": "{$pcpqueue->_toRow()}"
            },
            "pages": {
                "total": "{$pcpqueue->_pages()}",
                "current": "{$pcpqueue->_page()}"
            }
        }
    }
}
