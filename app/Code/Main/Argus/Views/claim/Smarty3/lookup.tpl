<style type="text/css">
    .claim-lookup-row {
        white-space: nowrap; margin: 1px; 
    }
    .claim-lookup-cell {
        margin-right: 2px; display: inline-block; background-color: rgba(100,100,100,.1)
    }
    .claim-lookup-header {
        letter-spacing: 1px; font-family: monospace; font-size: .85em; color: #333; padding: 5px 5px 2px 2px;
    }    
    .claim-lookup-data {
        padding-left: 15px; font-family: sans-serif; color: black; font-size: .95em
    }
</style>
<div id="claim_lookup_{$window_id}">
</div>
<script type="text/javascript">
    {literal}
    (function () {
        Argus.apps('{$window_id}', new Vue({
            {/literal}
                el: '#claim_lookup_{$window_id}',
            {literal}
                template: Humble.template('argus/claim'),
                data: {
                    PatientControlNumber: '',
                    claimNumber: '',
                    claimType: '',
                    claimStatus: '',
                    serviceDateRange: '',
                    statusDate: '',
                    totalBilledAmount: '',
                    totalPaidAmount: '',
                    authorizationNumber: '',
                    authorizationUsed: '',
                    paidDate: '',
                    providerGID: '',
                    locationGID: '',
                    businessGID: '',
                    state: '',
                    providerFirstName: '',
                    providerLastName: '',
                    providerNPI: '',
                    memberGID: '',
                    groupGID: '',
                    memberID: '',
                    memberFirstName: '',
                    memberLastName: ''
                 },
                methods: {
                    fetch: function () {
                        var app = this;
                        (new EasyAjax('/argus/claim/data')).addModel(this).then(function (response) {
                            var data = JSON.parse(response);
                            if (data.details) {
                                for (var i in data.details.claims[0]) {
                                    app[i] = data.details.claims[0][i]
                                }
                            }
                        }).post();
                    }
                }
            })
        );
    })();
    {/literal}
</script>    

