{assign var=data value=$element->load()}
<style type="text/css">
    .argus-config-descriptor {
        font-size: .8em; font-family: serif; letter-spacing: 2px;
    }
    .argus-config-field {
        font-size: 1em; font-family: sans-serif; text-align: right; padding-right: 4px;
    }
    .argus-config-cell {
        width: 33%; margin: 1px; background-color: #e8e8e8;  border: 1px solid #d0d0d0; padding-left: 2px
    }
    .email-add-button {
        background-color: red; font-size: 1.5em; font-weight: bold; padding: 0px 4px; border: 1px solid red; border-radius: 4px; color: white; font-weight: bold
    }
    .email-dropdown {
        width: 325px; padding: 3px 5px; border: 1px solid #aaf; border-radius: 3px;
    }
    .email-dropdown-description {
    }
    .email-input-box {
        padding: 2px; color: #333; background-color: lightcyan; border: 1px solid #aaf; border-radius: 2px; font-size: 1.3em; width: 90%
    }
</style>
<table style="width: 100%; height: 100%">
    <tr style="height: 30px">
        <td class="argus-config-cell"><div class="argus-config-descriptor">Type</div><div class="argus-config-field">{$data.type }</div></td>
        <td class="argus-config-cell"><div class="argus-config-descriptor">Shape</div><div class="argus-config-field">{$data.shape }</div></td>
        <td class="argus-config-cell"><div class="argus-config-descriptor">Mongo ID</div><div class="argus-config-field">{$data.id }</div></td>
    </tr>
    <tr style="height: 30px">
        <td class="argus-config-cell"><div class="argus-config-descriptor">Namespace</div><div class="argus-config-field">{if ($data.namespace)}{$data.namespace}{else}N/A{/if}</div></td>
        <td class="argus-config-cell"><div class="argus-config-descriptor">Component</div><div class="argus-config-field">{if ($data.component)}{$data.component}{else}N/A{/if}</div></td>
        <td class="argus-config-cell"><div class="argus-config-descriptor">Method</div><div class="argus-config-field">{if ($data.method)}{$data.method}{else}N/A{/if}</div></td>
    </tr>
        <tr>

            <td colspan=3 align='center' valign='middle' style="position: relative">
                <div style="min-width: 500px; width: 90%; padding: 20px; position: relative; color: #33; border-radius: 20px; border: 1px solid #333; text-align: left;">
                    <div style="font-size: 2em; font-family: sans-serif; ">Send An Email</div>
                    <hr />
                    <form onsubmit="return false">

                        <input value="{if (isset($data.recipients))}{$data.recipients} {/if}" type="text" name="recipients" id="recipients-{$data.id}" placeholder="Recipient List..." class="email-input-box" /><br /><br />
                        
                        <input value="{if (isset($data.subject))}{$data.subject} {/if}" type="text" name="subject" id="subject-{$data.id}" placeholder="Subject..." class="email-input-box" /><br /><br />
                        
                        
                        <div class="email-dropdown-description">Email Template</div>
                        <div>
                            <a href="#" style="color: white" onclick="$('#new-email-template-area-{$data.id}').slideToggle(); return false">New Template</a>
                        </div>
                        <div id="new-email-template-area-{$data.id}" style="display: none; padding: 20px 0px 10px 0px" >
                            <input type="text" name="new-email-template" id="new-email-template-{$data.id}" /><br />
                            <div class="email-dropdown-description">New Email Description</div>
                        </div>
                        <textarea name='email-editor' id='email-editor-{$data.id}'>{if (isset($data.email_template))}{$data.email_template}{/if}</textarea><br /><br />
                        <div style="float: right">
                            Attachment Event Field: <input value="{if (isset($data.attachment_event_field))}{$data.attachment_event_field} {/if}" type="text" name="attachment_event_field" id="attachment_event_field-{$data.id}" class="email-input-box" style="width: 200px" />
                        </div>
                        <input type='button' name='email-template-save' id='email-template-save-{$data.id}' value=" Save "/>
                    </form>
                </div>
            </td>
        </tr>

</table>

    <form name="config-email-template-form" id="config-email-template-form-{$data.id}">
        <input type="hidden" name="email_template" id="email_template_{$data.id}" value="" />
        <input type="hidden" name="id" id="id_{$data.id}" value="{$data.id}" />
        <input type="hidden" name="subject" id="subject_{$data.id}" value="" />
        <input type="hidden" name="recipients" id="recipients_{$data.id}" value="" />
        <input type="hidden" name="attachment_event_field" id="attachment_event_field_{$data.id}" value="" />
        <input type='hidden' name='windowId' id='windowId_{$data.id}' value='{$window_id}' />
    </form>
    <script type="text/javascript">
        CKEDITOR.replace('email-editor-{$data.id}');
        Form.intercept($('#config-email-template-form-{$data.id}').get(),'{$data.id}','/paradigm/element/update',"{$window_id}");
        $('#email-template-save-{$data.id}').on('click',function () {
            //if (Edits['email_template_form_{$data.id}'].validate()) {
                var template    = CKEDITOR.instances['email-editor-{$data.id}'].getData();
                $('#email_template_{$data.id}').val(template);
                $('#subject_{$data.id}').val($('#subject-{$data.id}').val());
                $('#recipients_{$data.id}').val($('#recipients-{$data.id}').val());
                $('#attachment_event_field_{$data.id}').val($('#attachment_event_field-{$data.id}').val());
                $('#config-email-template-form-{$data.id}').submit();
            //}
        });
    </script>
