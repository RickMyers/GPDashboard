<style type="text/css">
    .pcp-portal-form {
        width: 400px; margin-left: auto; margin-right: auto; padding: 20px; border: 1px solid silver; background-color: ghostwhite; border-radius: 10px
    }
    .pcp-portal>fieldset {
        text-align: left;
    }
    .pcp-portal-form>fieldset>legend {
        text-align: left;
    }
    .pcp-portal-cell {
         margin-bottom: 10px
    }
    .pcp-portal-field {
        text-align: left
    }
    .pcp-portal-input {
        text-align: left; background-color: lightcyan; padding: 2px; border: 1px solid #aaf; border-radius: 2px; width: 250px
    }
    .pcp-portal-descriptor {
        text-align: left; font-family: monospace; letter-spacing: 2px
    }
</style>
<table style="width: 100%; height: 100%">
    <tr>
        <td style="text-align: center">
            <div id="pcp_portal_create-{$window_id}">
                
            </div> 
        </td>
    </tr>
</table>
<script type="text/javascript">
 (function () {
        var app = new Vue({
            el: '#pcp_portal_create-{$window_id}',
            data: {
                first_name: "",
                last_name: "",
                npi: ""
            },
            template: Humble.template('vision/pcp_portal_create'),
            methods: {
                createPcpPortal: function () {
                    (new EasyAjax('/vision/pcp/add')).addModel(this).then(function (response) {
                        alert(response);
                    }).post();
                }
            }
        });
        Argus.apps('{$window_id}',app);
        //console.log(app);
    })();    
    </script>