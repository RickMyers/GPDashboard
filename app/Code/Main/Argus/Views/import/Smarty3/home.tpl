<style type="text/css">
    .environment-copy-field {
        padding: 2px; font-size: .9em; color: #333; background-color: lightcyan; border: 1px solid #333; border-radius: 2px
    }
</style>
<div id="import-apply-nav-{$window_id}">
</div>
<div id="import-tab-{$window_id}">
    <form name="environment_copy_form-{$window_id}" id="environment_copy_form-{$window_id}" onsubmit="return false">
        <input type="hidden" name="latest_file" id="latest_file-{$window_id}" value="" />
        <fieldset><legend>Environment Copy - Import Remote Environment</legend>
            <hr />
            <table>
                <tr>
                    <td>Import Environment: </td>
                    <td>
                        <select class="environment-copy-field" name="environment" id="environment-{$window_id}">
                            <option value=""> </option>
                            {foreach from=$servers->fetch() item=server}
                                <option value="{$server.id}">{$server.name} [{$server.server}] </option>
                            {/foreach}
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>Choose server from above</td>
                </tr>
                <tr>
                    <td style="text-align: right">Import Scheme: </td>
                    <td>
                        <input type="file" class="environment-copy-field" name="scheme" id="scheme-{$window_id}" />
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>Select the scheme file to upload</td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="button" value="  Import  " name="export_submit" id="export_submit-{$window_id}" /></td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>
<div id="apply-tab-{$window_id}">
    
</div>
<script type="text/javascript">
    (function () {
        var f = function () {
            //alert('bazinga');
            (new EasyAjax('/argus/import/next')).add('latest_file',$('#latest_file-{$window_id}').val()).add('window_id','{$window_id}').then(function (response) {
                $('#apply-tab-{$window_id}').html(response);
            }).get();
        }
        var tabs = new EasyTab('import-apply-nav-{$window_id}',160);
        tabs.add('Import File',null,'import-tab-{$window_id}');
        tabs.add('Apply File',f,'apply-tab-{$window_id}');
        tabs.tabClick(0);
        var xx = new EasyEdits('','import-environment-{$window_id}');
        xx.fetch("/edits/argus/import");
        xx.process(xx.getJSON().replace(/&&win_id&&/g,'{$window_id}'));
        $('#latest_file-{$window_id}').on("change",function () {
            tabs.tabClick(1);
        });
    })();  
</script>