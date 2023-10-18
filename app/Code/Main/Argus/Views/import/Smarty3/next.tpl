<form name="environment_apply_form-{$window_id}" id="environment_apply_form-{$window_id}" onsubmit="return false">
    <input type="hidden" name="latest_file" id="latest_file-{$window_id}" value="" />
    <fieldset><legend>Environment Copy - Apply Downloaded File</legend>
        <hr />
        <table>
            <tr>
                <td colspan="2">Latest File: <b>{$latest_file}</b><br /><br /></td>
            </tr>
            <tr>
                <td>Available Source Files: </td>
                <td>
                    <select class="environment-files-field" name="data_file" id="data_file-{$window_id}">
                        <option value=""> </option>
                        {foreach from=$dir->filesInDirectory() item=stats key=file}
                            <option {if ($file == $latest_file)}selected{/if}value="{$file}">{$file} [{$stats.size}] </option>
                        {/foreach}
                    </select>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>Choose the data file to apply above</td>
            </tr>
            <tr>
                <td style="text-align: right">Apply Rules: </td>
                <td>
                    <input type="file" class="environment-copy-field" name="apply_rules" id="apply_rules-{$window_id}" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>Select the apply rules file to upload</td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
                <td></td>
                <td><input type="button" value="  Apply  " name="apply_submit" id="apply_submit-{$window_id}" /></td>
            </tr>
        </table>
    </fieldset>
</form>
<script>
    var xx = new EasyEdits('','apply-file-{$window_id}');
    xx.fetch("/edits/argus/apply");
    xx.process(xx.getJSON().replace(/&&win_id&&/g,'{$window_id}'));    
</script>
