<!--
    Get who you are in terms of window, then mark that window as 'static', and store a reference for future use
-->
<style type="text/css">
</style>

<div id="table_import_export_nav">
</div>
<div id="table_instructions_tab">
    <table style='width: 100%; height: 500px;'> 
        <tr>
            <td>
                <div style='border: 1px solid #333; padding: 10px; width: 600px; margin: auto;'>
                    With this tool you can export or import table data, one table at a time.  You are not allowed to import data into any environment that is flagged as production.
                </div>
            </td>
        </tr>
    </table>
</div>
<div id="table_export_tab">
    <table style='width: 100%; height: 500px;'> 
        <tr>
            <td>
                <div style='border: 1px solid #333; padding: 10px; width: 600px; margin: auto;'>
                    <form name="export_entity_form" id="export_entity_form" onsubmit="return false" method='post'>
                        <fieldset style="padding: 10px"><legend>Instructions</legend>
                            Choose the namespace and the entity to export.  Click 'Export' to perform the action.  When the export is finished, there will be a link to your file made available for download.
                            <br /><br /><br/> 
                            <select name='namespace' id='export_namespace'>
                                <option value=""> </option>
                                {foreach from=$namespaces->fetch() item=namespace}
                                    <option value="{$namespace.namespace}"> {$namespace.namespace}</option>
                                {/foreach}
                            </select>
                            <br /><br />
                            <select name='entity' id='export_entity'>
                                <option value=""> </option>
                            </select>
                            <br /><br />
                            <input type="text" name="condition" id="export_condition" value="" />
                            <br /><br />
                            <input type="button" name="export_submit" id="export_submit" value=" Export " />
                            <br /><br />
                            <div id="export_file">
                            </div>
                        </fieldset>
                    </form>
                </div>
            </td>
        </tr>
    </table>
</div>
<div id="table_import_tab">
    <table style='width: 100%; height: 500px;'> 
        <tr>
            <td>    
                <div style='border: 1px solid #333; padding: 10px; width: 600px; margin: auto;'>
                    <form name="import_entity_form" id="import_entity_form" onsubmit="return false" method='post'>
                        <fieldset style="padding: 10px"><legend>Instructions</legend>
                            Choose the namespace and the entity to import, and have the file ready to upload.  The file can be JSON or a ZIP.  Click 'Import' to perform the action.
                            <br /><br /><br/> 
                            <select name='namespace' id='import_namespace'>
                                <option value=""> </option>
                                {foreach from=$namespaces->fetch() item=namespace}
                                    <option value="{$namespace.namespace}"> {$namespace.namespace}</option>
                                {/foreach}
                            </select>
                            <br /><br />
                            <select name='entity' id='import_entity'>
                                <option value=""> </option>
                            </select>
                            <br /><br />
                            <input type="file" name='import_file' id='import_file' value='' />
                            <br /><br />
                            <input type="button" name="import_submit" id="import_submit" value=" Import " />
                            <br /><br />
                        </fieldset>
                    </form>
                </div>
            </td>
        </tr>
    </table>
</div>

<script type='text/javascript'>
    (function () {
        let tabs = new EasyTab('table_import_export_nav',120);
        tabs.add('Instructions',null,'table_instructions_tab');
        tabs.add('Export',null,'table_export_tab');
        tabs.add('Import',null,'table_import_tab');
        tabs.tabClick(0);
        new EasyEdits('/edits/argus/exportentity','export-entity');
        new EasyEdits('/edits/argus/importentity','import-entity');
    })();
</script>

