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
            <form name="config-payment-form" id="config-payment-form-{$data.id}" onsubmit="return false">
                <input type="hidden" name="id" id="id_{$data.id}" value="{$data.id}" />
                <input type="hidden" name="windowId" id="windowId_{$data.id}" value="{$windowId}" />
                <fieldset style="padding: 10px; width: 600px; text-align: left"><legend>Instructions</legend>
                    Please specify the field on the event that has the data necessary to perform a payment authorization check.  This field
                    should have data that conforms to the companion document for this process.<br /><br />
                    While in development or testing, choose the Sandbox option and Authorize Only.  In production set it to Production and Capture.
                    <br /><br />
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
                        <tr>
                            <td><br /><br/></td>
                            
                            <td></td>
                        </tr>
                        <tr>
                            <td>Application Field</td>
                            <td><input class='paradigm-config-form-field' type="text" name="field" id="config_payment_field_{$data.id}" value="{if (isset($data.field))}{$data.field}{/if}" /></td>
                        </tr>                        
                        <tr>
                            <td colspan='2'>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan='2'><div style="display: inline-block; width: 100px;">Action:</div>
                                <input class='paradigm-config-form-field' type="radio" name="action" id="config_payment_recurring_{$data.id}" value="auth" {if (isset($data.action) && ($data.action == 'auth'))}checked="checked"{/if} /> Authorize&nbsp;Only&nbsp;&nbsp;&nbsp;&nbsp;
                                <input class='paradigm-config-form-field' type="radio" name="action" id="config_payment_capture_{$data.id}" value="capture" {if (isset($data.action) && ($data.action == 'capture'))}checked="checked"{/if} /> Capture
                            </td>
                        </tr>                        
                    </table>
                    <br /><br >
                    <input type="submit" value=" Save " />
                </fieldset>
            </form>
        </td>
    </tr>
</table>
<script type="text/javascript">
    //Form.intercept(Form Reference,MongoDB ID,optional URL or just FALSE,Dynamic WindowID to Close After Saving);
    Form.intercept($('#config-payment-form-{$data.id}').get(),'{$data.id}','/paradigm/element/update',"{$windowId}");
</script>