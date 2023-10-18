{assign var=data value=$element->load()}
<!--
    INSTRUCTIONS:

    This template makes setting up a configuration page for a workflow element pretty simple.
    
    You can leave most of this "as-is".  You can also tailor the template.tpl file to your liking.

    First you will need to copy this template to your configuration view file.

    In the FORM SECTION below, you will need to *ONLY* add the HTML input fields and field descriptions,
    along with any instructions for the person filling out the configuration page.  Also perform a change all
    on the 'attach-details' placeholder with a unique name for the form element you are configuring.

    Some common examples of HTML form fields are below as aids in designing your confiruation page.

    The framework handles everything else.  Also note the examples below on how you add default values and
    provide values from the `data` array.  The data array contains the current information on how the element
    is currently configured.

-->
<!-- ################################ HEADER SECTION ############################################--> 
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
<!-- ################################ END HEADER SECTION ########################################-->    
    <tr>
        <td colspan="3" align="center" valign="middle">
            <!-- ########################## FORM SECTION ########################################-->
            <form name="config-attach-details-form" id="config-attach-details-form-{$data.id}" onsubmit="return false">
                <input type="hidden" name="id" id="id_{$data.id}" value="{$data.id}" />                 <!-- Leave this As-Is -->
                <input type="hidden" name="windowId" id="windowId_{$data.id}" value="{$windowId}" />    <!-- Leave this As-Is -->
                <fieldset style="padding: 10px; width: 600px; text-align: left"><legend>Instructions</legend>
                    Specify below the event field that contains the event ID (ID of the actual screening/scanning event) and the name of
                    the event field to attach that data to:<br /><br />
                    <table>
                        <tr>
                            <td>Event ID Field: </td><td><input class='paradigm-config-form-field' type="text" name="event_id_field" id="event_id_field_{$data.id}" value="{if (isset($data.event_id_field))}{$data.event_id_field}{/if}" /></td>
                        </tr>
                        <tr>
                            <td>Attach Field: </td><td><input class='paradigm-config-form-field' type="text" name="attach_field" id="attach_field_{$data.id}" value="{if (isset($data.attach_field))}{$data.attach_field}{/if}" /></td>
                        </tr>
                    </table>
                    <br /><br >
                    <input type="submit" value=" Save " />
                </fieldset>
            </form>
            <!-- ########################## END FORM SECTION ####################################-->                
        </td>
    </tr>
</table>
<script type="text/javascript">
    //Example of intercepting the save event and redirecting to a specified URL.  This does the form magic.
    //Form.intercept(Form Reference,MongoDB ID,optional URL or just FALSE,Dynamic WindowID to Close After Saving);
    Form.intercept($('#config-attach-details-form-{$data.id}').get(),'{$data.id}','/paradigm/element/update',"{$windowId}");
</script>

