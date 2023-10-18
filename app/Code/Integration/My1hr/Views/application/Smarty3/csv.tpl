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
            <form name="config-extract-field-form" id="config-extract-field-form-{$data.id}" onsubmit="return false">
                <input type="hidden" name="id" id="id_{$data.id}" value="{$data.id}" />
                <input type="hidden" name="windowId" id="windowId_{$data.id}" value="{$windowId}" />
                <fieldset style="padding: 10px; width: 600px; text-align: left"><legend>Instructions</legend>
                    <br />
                    This is the configuration for the workflow element that retrieves memberdata from the My1HR CSV and throws an EVENT of the name specified below with that information.  Please identify the field below that has the CSV information on it. <br />
                    <br />
                    <table>
                        <tr>
                            <td>CSV Field:</td>
                            <td><input class='paradigm-config-form-field' type="text" name="csv_field" id="csv_field_{$data.id}" value="{if (isset($data.csv_field))}{$data.csv_field}{/if}" /></td>
                        </tr>
                        <tr><td colspan="2">&nbsp;</td></tr>
                        <tr>
                            <td>Event Name:</td>
                            <td><input class='paradigm-config-form-field' type="text" name="event_name" id="csv_event_name_{$data.id}" value="{if (isset($data.event_name))}{$data.event_name}{/if}" /></td>                            
                        </tr>
                        <tr><td colspan="2">&nbsp;</td></tr>
                        <tr>
                            <td>Member Field:</td>
                            <td><input class='paradigm-config-form-field' type="text" name="member_field" id="csv_member_field_{$data.id}" value="{if (isset($data.member_field))}{$data.member_field}{/if}" /></td>                            
                        </tr>                        
                    </table>
                    <br /><br />

                    <input type="submit" value=" Save " />
                </fieldset>
            </form>
        </td>
    </tr>
</table>
<script type="text/javascript">
    //Form.intercept(Form Reference,MongoDB ID,optional URL or just FALSE,Dynamic WindowID to Close After Saving);
    Form.intercept($('#config-extract-field-form-{$data.id}').get(),'{$data.id}','/paradigm/element/update',"{$windowId}");
</script>


