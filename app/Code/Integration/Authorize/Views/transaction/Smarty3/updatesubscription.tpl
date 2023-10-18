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
            <form name="config-subscriber-form" id="config-subscriber-form-{$data.id}" onsubmit="return false">
                <input type="hidden" name="id" id="id_{$data.id}" value="{$data.id}" />
                <input type="hidden" name="windowId" id="windowId_{$data.id}" value="{$windowId}" />
                <fieldset style="padding: 10px; width: 600px; text-align: left"><legend>Instructions</legend>
                    We are looking for three fields on the event that contain information we need to update the subscription with the Aldera Member ID.
                    First please identify the field that holds the application data in the extracted (common) format. Then please identify the name of the field on the event that has Aldera Member ID.  Next we need the name of the event field that has the subscription ID.
                    Finally we need the name of the event field that the results from trying to modify the subscription will be attached.<br /><br />
                    <table>
                        <tr>
                            <td colspan='2'>Authentication</td>
                        </tr>
                        <tr>
                            <td style='padding-left: 20px'>Merchant ID</td>
                            <td>
                                <input class='paradigm-config-form-field' type="text" name="merchant_id" id="config_merchant_id_field_{$data.id}" value="{if (isset($data.merchant_id))}{$data.merchant_id}{/if}" />
                            </td>
                        </tr>
                        <tr>
                            <td style='padding-left: 20px'>Transaction Key</td>
                            <td>
                                <input class='paradigm-config-form-field' type="text" name="transaction_key" id="config_transaction_key_field_{$data.id}" value="{if (isset($data.transaction_key))}{$data.transaction_key}{/if}" />
                            </td>
                        </tr>    
                        <tr><td colspan="2">&nbsp;</td></tr>
                        <tr><td>Application Field </td><td>&nbsp;<input class='paradigm-config-form-field' type="text" name="appextract" id="config_extract_field_{$data.id}" value="{if (isset($data.appextract))}{$data.appextract}{/if}" /><br /><br ></td></tr>
                        <tr><td>Aldera Results Field </td><td>&nbsp;<input class='paradigm-config-form-field' type="text" name="field" id="config_aldera_field_{$data.id}" value="{if (isset($data.field))}{$data.field}{/if}" /><br /><br ></td></tr>
                        <tr><td>Subscription Field&nbsp;</td><td>&nbsp;<input class='paradigm-config-form-field' type="text" name="subscription" id="config_subscription_field_{$data.id}" value="{if (isset($data.subscription))}{$data.subscription}{/if}" /><br /><br ></td></tr>
                        <tr><td>Update Results Field </td><td>&nbsp;<input class='paradigm-config-form-field' type="text" name="result" id="config_result_field_{$data.id}" value="{if (isset($data.result))}{$data.result}{/if}" /><br /></td></tr>
                    </table>
                    <br />
                    <br /><input type="submit" value=" Save " />
                </fieldset>
            </form>
        </td>
    </tr>
</table>
<script type="text/javascript">
    //Form.intercept(Form Reference,MongoDB ID,optional URL or just FALSE,Dynamic WindowID to Close After Saving);
    Form.intercept($('#config-subscriber-form-{$data.id}').get(),'{$data.id}','/paradigm/element/update',"{$windowId}");
</script>
