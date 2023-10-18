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
            <form name="config-user-ip-address" id="config-user-ip-address-{$data.id}" onsubmit="return false">
                <input type="hidden" name="id" id="id_{$data.id}" value="{$data.id}" />
                <input type="hidden" name="windowId" id="windowId_{$data.id}" value="{$windowId}" />
                <fieldset style="padding: 10px; width: 600px; text-align: left"><legend>Instructions</legend>
                    We are going to try to record the IP address of the person logging in.<br /><br />
                    Please identify the source of the User ID and the IP address below:<br /><br />
                    <table>
                        <tr>
                            <td>User ID Source: </td>
                            <td>
                                <input {if (isset($data.user_id_source) && ($data.user_id_source == 'SESSION'))}checked="checked"{/if} class="paradigm-config-form-field" type="radio" name="user_id_source" id="user_id_source_session" value='SESSION' /> Session &nbsp;&nbsp;&nbsp;
                                <input {if (isset($data.user_id_source) && ($data.user_id_source == 'field'))}checked="checked"{/if} class="paradigm-config-form-field" type="radio" name="user_id_source" id='user_id_source_field' value='field' /> Field: <input class="paradigm-config-form-field" type='text' name='user_id_source_field' id='user_id_source_field-{$data.id}' value="{if (isset($data.user_id_source_field))}{$data.user_id_source_field}{/if}" />                          
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">&nbsp;</td>
                        </tr>
                        <tr>
                            <td>IP Address Source: </td>
                            <td>
                                <input {if (isset($data.ip_address_source) && ($data.ip_address_source == 'SERVER'))}checked="checked"{/if} class="paradigm-config-form-field" type="radio" name="ip_address_source" id="ip_address_source_server" value='SERVER' /> Server &nbsp;&nbsp;&nbsp;
                                <input {if (isset($data.ip_address_source) && ($data.ip_address_source == 'field'))}checked="checked"{/if}class="paradigm-config-form-field" type="radio" name="ip_address_source" id='ip_address_source_field' value='field' /> Field: <input class="paradigm-config-form-field" type='text' name='ip_address_source_field' id='ip_address_source_field-{$data.id}' value="{if (isset($data.ip_address_source_field))}{$data.ip_address_source_field}{/if}" />
                            </td>
                        </tr>

                    </table>
                    
                    
                    
                    
                <br /><input type="submit" value=" Save " />
                </fieldset>
            </form>
        </td>
    </tr>
</table>
<script type="text/javascript">
    //Form.intercept(Form Reference,MongoDB ID,optional URL or just FALSE,Dynamic WindowID to Close After Saving);
    Form.intercept($('#config-user-ip-address-{$data.id}').get(),'{$data.id}','/paradigm/element/update',"{$windowId}");
</script>

