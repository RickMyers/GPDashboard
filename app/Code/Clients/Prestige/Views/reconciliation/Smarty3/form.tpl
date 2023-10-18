<style type='text/css'>
    .reconciliation-form-field {
        padding: 2px; color: #333;
    }
    .reconciliation-field-description {
        font-size: .85em; letter-spacing: 2px; font-family: monospace; padding-bottom: 15px; color: #333
    }
</style>
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style='width: 65%; min-width: 650px; padding: 10px; margin-left: auto; margin-right: auto; border-radius: 10px; border: 1px solid #333; color: #333;'>
                <form name='provider_reconciliation_form' id='provider_reconciliation_form-{$window_id}' onsubmit='return false'>
                    <fieldset><legend>Instructions</legend>
                        This tool will reconcile Argus's list of Providers and their data with Prestige's list of Providers and data. The output is a CSV containing matched and unmatched provider data.<br /><br />Please provide the source files, in CSV format, as requested below:<br/><br/>
                        <div class='reconciliation-form-field'>
                            <input type='file' name='argus_provider_list' id='argus_provider_list-{$window_id}' />
                        </div>
                        <div class='reconciliation-field-description'>
                            Argus Provider List (CSV format)
                        </div>
                        <div class='reconciliation-form-field'>
                            <input type='file' name='prestige_provider_list' id='prestige_provider_list-{$window_id}' />
                        </div>
                        <div class='reconciliation-field-description'>
                            Prestige Provider List (CSV format)
                        </div>
                        <div class='reconciliation-form-field'>
                            <input type='button' name='reconciliation_submit' id='reconciliation_submit-{$window_id}' value='Generate Report' />
                        </div>
                    </fieldset>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type='text/javascript'>
    var ee = new EasyEdits(null,"reconciliation-form-{$window_id}");
    ee.fetch("/edits/prestige/reconciliation", function (response) {
        this.process(response.replace(/&&WID&&/g,'{$window_id}'));
    });
</script>