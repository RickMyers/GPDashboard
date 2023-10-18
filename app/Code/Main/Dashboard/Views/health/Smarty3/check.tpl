{
    "SQL_DB": {
        "status": "{$system->SQLDBCheck()}"
    },
    "NoSQL_DB": {
        "status": "{$system->NoSQLCheck()}"
    },
    "Cache": {
        "status": "{$system->CacheCheck()}"
    },
    "DWH/ArgusApp": {
        "status": "{$system->DWHCheck()}"
    },
    "Email": {
        "status": "{$system->EmailCheck()}"
    }
}