{
    "tech_completed": {
        "data":
            {$tech->screeningFormsByPCP()},
        "pagination": {
            "rows": {
                "total": "{$tech->_rowCount()}",
                "from": "{$tech->_fromRow()}",
                "to": "{$tech->_toRow()}"
            },
            "pages": {
                "total": "{$tech->_pages()}",
                "current": "{$tech->_page()}"
            }
        }
    }
}

