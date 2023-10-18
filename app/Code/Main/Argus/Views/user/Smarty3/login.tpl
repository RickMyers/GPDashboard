{assign var=data value=$element->load()}
<!--
    INSTRUCTIONS:

    This template makes setting up a configuration page for a workflow element pretty simple.
    
    You can leave most of this "as-is".  You can also tailor the template.tpl file to your liking.

    First you will need to copy this template to your configuration view file.

    In the FORM SECTION below, you will need to *ONLY* add the HTML input fields and field descriptions,
    along with any instructions for the person filling out the configuration page.  Also perform a change all
    on the 'standard-login' placeholder with a unique name for the form element you are configuring.

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
            <form name="config-standard-login-form" id="config-standard-login-form-{$data.id}" onsubmit="return false">
                <input type="hidden" name="id" id="id_{$data.id}" value="{$data.id}" />                 <!-- Leave this As-Is -->
                <input type="hidden" name="windowId" id="windowId_{$data.id}" value="{$windowId}" />    <!-- Leave this As-Is -->
                <fieldset style="padding: 10px; width: 600px; text-align: left"><legend>Instructions</legend>
                    Enter the name of the field that will contain the value to use to use and the name of the password field to check for a matched password.  The 'node' field
                    below is for the event field that contains the actual information from our database that should have been loaded in a previous step<br /><br />
                    <table>
                        
                    
                    <tr><td style='text-align: right; padding-right: 5px; padding-bottom: 10px'>Source Field: </td><td style='padding-bottom: 10px'><input class='paradigm-config-form-field' type="text" name="source_field" id="source_field_{$data.id}" value="{if (isset($data.source_field))}{$data.source_field}{/if}" /></td></tr>
                    <tr><td style='text-align: right; padding-right: 5px; padding-bottom: 10px'>Password Field: </td><td style='padding-bottom: 10px'><input class='paradigm-config-form-field' type="text" name="password_field" id="password_field_{$data.id}" value="{if (isset($data.password_field))}{$data.password_field}{/if}" /></td></tr>
                    <tr><td style='text-align: right; padding-right: 5px; padding-bottom: 10px'>User Node: </td><td style='padding-bottom: 10px'><input class='paradigm-config-form-field' type="text" name="node_field" id="node_field_{$data.id}" value="{if (isset($data.node_field))}{$data.node_field}{/if}" /></td></tr>
                    </table>
                    <br /><input type="submit" value=" Save " />
                </fieldset>
            </form>
            <!-- ########################## END FORM SECTION ####################################-->                
        </td>
    </tr>
</table>
<script type="text/javascript">
    //Example of intercepting the save event and redirecting to a specified URL.  This does the form magic.
    //Form.intercept(Form Reference,MongoDB ID,optional URL or just FALSE,Dynamic WindowID to Close After Saving);
    Form.intercept($('#config-standard-login-form-{$data.id}').get(),'{$data.id}','/paradigm/element/update',"{$windowId}");
</script>

