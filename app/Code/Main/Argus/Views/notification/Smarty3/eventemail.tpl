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
            <form name="config-event-email-form" id="config-event-email-form-{$data.id}" onsubmit="return false">
                <input type="hidden" name="id" id="id_{$data.id}" value="{$data.id}" />
                <input type="hidden" name="windowId" id="windowId_{$data.id}" value="{$windowId}" />
                <fieldset style="padding: 10px; width: 600px; text-align: left"><legend>Instructions</legend>
                    This stage will send an email using fields from the event to populate key components of the email, please specify the Event Fields that will 
                    contain the information needed to construct the email<br /><br />
                    <table>
                        <tr>
                            <td style="padding: 2px">Event Node: </td>
                            <td style="padding: 2px"><input class='paradigm-config-form-field' type="text" name="event_node" id="config_event_node_{$data.id}" value="{if (isset($data.event_node))}{$data.event_node}{/if}" /></td>
                        </tr>                        
                        <tr>
                            <td style="padding: 2px">Recipients Field: </td>
                            <td style="padding: 2px"><input class='paradigm-config-form-field' type="text" name="recipients" id="config_recipients_{$data.id}" value="{if (isset($data.recipients))}{$data.recipients}{/if}" /></td>
                        </tr>
                        <tr>
                            <td style="padding: 2px">Subject Field: </td>
                            <td style="padding: 2px"><input class='paradigm-config-form-field' type="text" name="subject" id="config_subject_{$data.id}" value="{if (isset($data.subject))}{$data.subject}{/if}" /></td>
                        </tr>
                        <tr>
                            <td style="padding: 2px">Email Body: </td>
                            <td style="padding: 2px"><input class='paradigm-config-form-field' type="text" name="body" id="config_body_{$data.id}" value="{if (isset($data.body))}{$data.body}{/if}" /></td>
                        </tr>
                        <tr>
                            <td style="padding: 2px">Attachment: </td>
                            <td style="padding: 2px"><input class='paradigm-config-form-field' type="text" name="attachment" id="config_attachment_{$data.id}" value="{if (isset($data.attachment))}{$data.attachment}{/if}" /></td>
                        </tr>
                        <tr>
                            <td><br /></td>
                            <td><input type="submit" value=" Save " /></td>
                        </tr>

                    </table>    
                </fieldset>
            </form>
        </td>
    </tr>
</table>
<script type="text/javascript">
    //Form.intercept(Form Reference,MongoDB ID,optional URL or just FALSE,Dynamic WindowID to Close After Saving);
    Form.intercept($('#config-event-email-form-{$data.id}').get(),'{$data.id}','/paradigm/element/update',"{$windowId}");
</script>
