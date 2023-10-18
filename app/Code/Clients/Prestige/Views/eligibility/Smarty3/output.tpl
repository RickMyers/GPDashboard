{assign var=data value=$element->load()}
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
            <form name="config-output-form" id="config-output-form-{$data.id}" onsubmit="return false">
                <input type="hidden" name="id" id="id_{$data.id}" value="{$data.id}" />
                <input type="hidden" name="windowId" id="windowId_{$data.id}" value="{$windowId}" />
                <fieldset style="padding: 10px; width: 600px; text-align: left"><legend>Instructions</legend>
                    Please identify the field on the EVENT that has the member information, and whether you want to expose all the information or just the Eligibility information.<br /><br />
                    <table>
                        <tr>
                            <td>Field:&nbsp;</td>
                            <td><input class='paradigm-config-form-field' type="text" name="field" id="config_output_field_{$data.id}" value="{if (isset($data.field))}{$data.field}{/if}" /></td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-bottom: 5px"><br/>Expose How Much Data?</td>
                        </tr>
                        <tr>
                            <td align="center"><input type="radio" name="expose" id="expose_eligibility_{$data.id}" value="eligibility" {if (isset($data.expose) && ($data.expose == "eligibility"))} checked="checked"  {/if} /></td>
                            <td>Just Eligibility...</td>
                        </tr>
                        <tr>
                            <td align="center"><input type="radio" name="expose" id="expose_all_{$data.id}" value="all" {if (isset($data.expose) && ($data.expose == "all"))} checked="checked"  {/if} /></td>
                            <td>All Data...</td>
                        </tr>
                    </table>
                    <br /><br /><input type="submit" value=" Save " />
                </fieldset>
            </form>
        </td>
    </tr>
</table>
<script type="text/javascript">
    //Form.intercept(Form Reference,MongoDB ID,optional URL or just FALSE,Dynamic WindowID to Close After Saving);
    Form.intercept($('#config-output-form-{$data.id}').get(),'{$data.id}','/paradigm/element/update',"{$windowId}");
</script>
