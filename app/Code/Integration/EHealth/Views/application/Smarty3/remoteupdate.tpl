{assign var=data value=$element->load()}
{assign var=stuff value=Log::console($data)}
<style type="text/css">
    .paradigm-config-descriptor {
        font-size: .8em; font-family: serif; letter-spacing: 2px;
    }
    .paradigm-config-field {
        font-size: 1em; font-family: sans-serif; text-align: right; padding-right: 4px;
    }
    .paradigm-config-cell {
        width: 33%; margin: 1px; background-color: #e8e8e8;  border: 1px solid #d0d0d0; padding-left: 2px
    }
    .paradigm-config-form-field {
        padding: 2px; background-color: lightcyan; color: #333; border: 1px solid #aaf
    }
</style>
<table style="width: 100%; height: 100%; border-spacing: 1px;">
    <tr style="height: 30px">
        <td class="paradigm-config-cell"><div class="paradigm-config-descriptor">Type</div><div class="paradigm-config-field">{$data.type}</div></td>
        <td class="paradigm-config-cell"><div class="paradigm-config-descriptor">Shape</div><div class="paradigm-config-field">{$data.shape}</div></td>
        <td class="paradigm-config-cell"><div class="paradigm-config-descriptor">Mongo ID</div><div class="paradigm-config-field">{$data.id}</div></td>
    </tr>
    <tr style="height: 30px">
        <td class="paradigm-config-cell"><div class="paradigm-config-descriptor">Namespace</div><div class="paradigm-config-field">{$data.namespace}</div></td>
        <td class="paradigm-config-cell"><div class="paradigm-config-descriptor">Component</div><div class="paradigm-config-field">{$data.component}</div></td>
        <td class="paradigm-config-cell"><div class="paradigm-config-descriptor">Method</div><div class="paradigm-config-field">{$data.method}</div></td>
    </tr>
    <tr>
        <td colspan="3" align="center" valign="middle">
            <form name="config-remoteupdate-form" id="config-remoteupdate-form-{$data.id}" onsubmit="return false">
                <input type="hidden" name="id" id="id_{$data.id}" value="{$data.id}" />
                <input type="hidden" name="windowId" id="windowId_{$data.id}" value="{$windowId}" />
                <fieldset style="padding: 10px; width: 600px; text-align: left"><legend>Instructions</legend>
                    You can choose to set the remote eHealth status to a fixed value or you can pull the value to set the remote status from a field in the event,
                    but you also need to identify the field on the event where the application data is stored<br /><br />
                
                    App Field: <input class='paradigm-config-form-field' type="text" name="appfield" id="appfield_{$data.id}" value="{if (isset($data.appfield))}{$data.appfield}{/if}" /><br /><br >    
                    <input type="radio" name="status_source" {if (isset($data.status_source) && ($data.status_source == 'value'))}checked="checked"{/if} id="status_source_value-{$windowId}" value="value" /> Value: 
                    <input class='paradigm-config-form-field' type="text" name="status" id="status_{$data.id}" value="{if (isset($data.status))}{$data.status}{/if}" /><br /><br >
                    <input type="radio" name="status_source" {if (isset($data.status_source) && ($data.status_source == 'field'))}checked="checked"{/if} id="status_source_field-{$windowId}" value="field" /> Field: 
                    <input class='paradigm-config-form-field' type="text" name="field" id="status_field{$data.id}" value="{if (isset($data.field))}{$data.field}{/if}" /><br /><br >
                    <br /><input type="submit" value=" Save " />
                </fieldset>
            </form>
        </td>
    </tr>
</table>
<script type="text/javascript">
    //Form.intercept(Form Reference,MongoDB ID,optional URL or just FALSE,Dynamic WindowID to Close After Saving);
    Form.intercept($('#config-remoteupdate-form-{$data.id}').get(),'{$data.id}','/paradigm/element/update',"{$windowId}");
</script>
