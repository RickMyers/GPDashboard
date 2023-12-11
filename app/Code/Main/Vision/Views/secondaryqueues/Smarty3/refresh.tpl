{
    "referral_required": { 
        "data":
            {$referrals->formsRequiringReferral()},
        "pagination": {
            "rows": {
                "total": "{$referrals->_rowCount()}",
                "from": "{$referrals->_fromRow()}",
                "to": "{$referrals->_toRow()}"
            },
            "pages": {
                "total": "{$referrals->_pages()}",
                "current": "{$referrals->_page()}"
            }          
        }
    },
    "non_contracted": { 
        "data":
            {$noncon->nonContractedMembers()},
        "pagination": {
            "rows": {
                "total": "{$noncon->_rowCount()}",
                "from": "{$noncon->_fromRow()}",
                "to": "{$noncon->_toRow()}"
            },
            "pages": {
                "total": "{$noncon->_pages()}",
                "current": "{$noncon->_page()}"
            }          
        }
    },
    "failed_claims": { 
        "data":
            {$failures->failedClaims()},
        "pagination": {
            "rows": {
                "total": "{$failures->_rowCount()}",
                "from": "{$failures->_fromRow()}",
                "to": "{$failures->_toRow()}"
            },
            "pages": {
                "total": "{$failures->_pages()}",
                "current": "{$failures->_page()}"
            }          
        }
    }
}

