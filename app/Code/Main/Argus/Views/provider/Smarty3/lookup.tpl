<style type="text/css">
    .npi-lookup-row {
        white-space: nowrap; margin: 1px; 
    }
    .npi-lookup-cell {
        margin-right: 2px; display: inline-block; background-color: rgba(100,100,100,.1)
    }
    .npi-lookup-header {
        letter-spacing: 1px; font-family: monospace; font-size: .85em; color: #333; padding: 5px 5px 2px 2px;
    }    
    .npi-lookup-data {
        padding-left: 15px; font-family: sans-serif; color: black; font-size: .95em
    }
</style>
<div id="provider_lookup_{$window_id}">
</div>
<script type="text/javascript">
    {literal}
    (function () {
        Argus.apps('{$window_id}', new Vue({
            {/literal}
                el: '#provider_lookup_{$window_id}',
             {literal}
                template: Humble.template('argus/provider'),
                data: {
                    npi: '',
                    npi_display: '',
                    first_name: '',
                    last_name: '',
                    business_address: '',
                    business_phone: '',
                    mailing_address: '',
                    mailing_phone: '',
                    specialty: '',
                    code: '',
                    license: '',
                    provider_active: '',
                    gender: '',
                    state: ''
                 },
                methods: {
                    fetch: function () {
                        var app = this;
                        (new EasyAjax('/argus/provider/data')).addModel(this).then(function (response) {
                            var data = JSON.parse(response);
                            if (data.result_count) {
                                var row = data.results[0];
                                app.npi_display      = row.number;
                                app.first_name       = row.basic.first_name;
                                app.last_name        = row.basic.last_name;
                                app.gender           = row.basic.gender;
                                app.provider_active  = row.basic.status;
                                app.specialty        = row.taxonomies[0].desc;
                                app.code             = row.taxonomies[0].code;
                                app.state            = row.taxonomies[0].state;
                                app.license          = row.taxonomies[0].license;
                                app.business_address = row.addresses[0].address_1+", "+row.addresses[0].city+", "+row.addresses[0].state+", "+row.addresses[0].postal_code;
                                app.business_phone   = row.addresses[0].telephone_number;
                                app.mailing_address  = row.addresses[1].address_1+", "+row.addresses[1].city+", "+row.addresses[0].state+", "+row.addresses[1].postal_code;
                                app.mailing_phone    = row.addresses[1].telephone_number;
                            }
                        }).get();
                    }
                },
                lookup: function () {
                    
                }
            })
        );
    })();
    {/literal}
</script>    

