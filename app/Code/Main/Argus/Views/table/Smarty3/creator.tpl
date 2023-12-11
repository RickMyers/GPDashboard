<style type="text/css">
    .db-creator-fieldname {
        margin-bottom: 15px; font-family: monospace; color: #333; letter-spacing: 1px
    }
</style>
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            
            <div style="min-width: 600px; width: 80%; margin: auto">
                <form name="db_creator_form" id="db_creator_form-{$window_id}" onsubmit="return false">
                    <fieldset><legend>Instructions</legend>
                        You can create a new table (Entity) by submitting a CSV, and optionally populate the table<br/><br/>
                        <select name="namespace" id="db_creator_namespace-{$window_id}">
                            <option value=""></option>
                            {foreach from=$namespaces->fetch() item=ns}
                                <option value="{$ns.namespace}"> {$ns.namespace} </option>
                            {/foreach}
                        </select><br />
                        <div class="db-creator-fieldname">Namespace</div>
                        <input type="text" name="table_name" id="db_creator_table_name-{$window_id}" value="" />
                        <div class="db-creator-fieldname">Table Name</div>
                        <input type="file" name="csv" id="db_creator_csv-{$window_id}" value="" />
                        <div class="db-creator-fieldname">CSV</div>
                        <button id="db_creator_create_button-{$window_id}"> Create </button>
                    </fieldset>
                </form>
            </div>
            
        </td>
    </tr>
</table>
<script type="text/javascript">
    (function () {
        let xx = new EasyEdits('','db-creator-{$window_id}');
        xx.fetch("/edits/argus/dbcreator");
        xx.process(xx.getJSON().replace(/&&win_id&&/g,'{$window_id}'));        
    })();
</script>
