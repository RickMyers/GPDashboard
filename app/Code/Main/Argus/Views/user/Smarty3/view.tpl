<style type="text/css">
    .user-desc-column {
        text-align: right; padding-right: 10px; 
    }
    .user-value-column {
        padding-bottom: 2px;
    }
    .user-field {
        padding: 2px; border: 1px solid #aaf; background-color: lightcyan;
    }
</style>
{assign var=data value=$user->userData()}
{assign var=appl value=$appellation->load(true)}
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style=" width: 800px; margin-left: auto; margin-right: auto">
                <fieldset><legend>Basic Information [{if ($permissions->getSuperUser()=="Y")}<a href="/app/cheat.php?uid={$user->getUserId()}" title="Switch To User">{$data.user_name}</a>{else}{$data.user_name} {/if}]</legend>
                    <div style="width: 49%; float: left;">
                        <form name="user-update-form" id="user-update-form-{$window_id}" onsubmit="return false">
                            <input type="hidden" name="user_id" id="user_id-{$window_id}" value="{$user->getUserId()}" />

                        <table>
                            <tr>
                                <td class="user-desc-column">E-Mail</td>
                                <td class="user-value-column">
                                    <input type="text" name="email" id="email-{$window_id}" class="user-field" value="{$data.email}" />
                                </td>
                            </tr>                            
                            <tr>
                                <td class="user-desc-column">
                                    Account Status
                                </td>
                                <td class="user-value-column">
                                    <select class="user-field" name="account_status" id="account_status-{$window_id}" style="color: inherit">
                                        <option style="color: green" value="">Ok</option>
                                        <option style="color: red" value="L">Locked</option>
                                    </select>
                                        <a href='#' onclick='Argus.admin.reset.password("{$data.id}")' >Reset Password</a>
                                </td>
                            </tr>
                            <tr>
                                <td class="user-desc-column">Appellation</td>
                                <td class="user-value-column">
                                    <select name="appellation_id" id="appellation_id-{$window_id}" class="user-field">
                                        <option value=""></option>
                                        {foreach from=$appellations->fetch() item=appellation}
                                            <option value="{$appellation.id}"> {$appellation.appellation} </option>
                                        {/foreach}
                                    </select>
                                </td>
                            </tr>   
                            <tr>
                                <td class="user-desc-column">Entity Name</td>
                                <td class="user-value-column">
                                    <input type="text" name="entity_name" readonly="readonly" id="entity_name-{$window_id}" class="user-field" value="{$data.entity_name}" />
                                </td>
                            </tr>                            
                            <tr>
                                <td class="user-desc-column">First Name</td>
                                <td class="user-value-column">
                                    <input type="text" name="first_name" id="first_name-{$window_id}" class="user-field" value="{$data.first_name}" />
                                </td>
                            </tr>
                            <tr>
                                <td class="user-desc-column">Last Name</td>
                                <td class="user-value-column">
                                    <input type="text" name="last_name" id="last_name-{$window_id}" class="user-field" value="{$data.last_name}" />
                                </td>
                            </tr>
                            <tr>
                                <td class="user-desc-column">Middle Name</td>
                                <td class="user-value-column">
                                    <input type="text" name="middle_name" id="middle_name-{$window_id}" class="user-field" value="{$data.middle_name}" />
                                </td>
                            </tr>
                            <tr>
                                <td class="user-desc-column">Preferred Name</td>
                                <td class="user-value-column">
                                    <input type="text" name="preferred_name" id="preferred_name-{$window_id}" class="user-field" value="{$data.preferred_name}" />
                                </td>
                            </tr>
                            <tr>
                                <td class="user-desc-column">Date of Birth</td>
                                <td class="user-value-column">
                                    <input type="text" name="date_of_birth" id="date_of_birth-{$window_id}" class="user-field" value="{$data.date_of_birth}" />
                                </td>
                            </tr>
                            <tr>
                                <td class="user-desc-column">Gender</td>
                                <td class="user-value-column">
                                    <select name="gender" id="gender-{$window_id}" class="user-field">
                                        <option value=""> </option>
                                        <option value="M"> Male </option>
                                        <option value="F"> Female </option>
                                    </select>
                                </td>
                            </tr>
                            {if (isset($pcp['npi']))} 
                            <tr>
                                <td class="user-desc-column">Physician NPI</td>
                                <td class="user-value-column">
                                    <b>{$pcp['npi']}</b>
                                </td>
                            </tr>                                
                            {/if}
                            <tr style="padding-bottom: 5px">
                                <td class="user-desc-column">Last Login</td>
                                <td class="user-value-column">
                                    <b>{if ($data.logged_in)}{$data.logged_in|date_format:"F j, Y, g:i a"}{else}Never{/if}</b>
                                </td>
                            </tr>                            
                            <tr>
                                <td class="user-desc-column"></td>
                                <td class="user-value-column"><input type="submit" value="  Update  " /></td>
                            </tr>
                        </table>
                        </form>
                    </div>
                    <div style="display: inline-block; width: 49%; margin-left: .5%">
                        <div style="">
                            <form name="user-entity-associations-form" id="user-entity-associations-form" onsubmit="return false">
                                <select name="entity_type" id="entity_type-{$window_id}" class="user-field" style="width: 250px">
                                    <option value=""></option>
                                    {foreach from=$entity_types->fetch() item=entity_type}
                                        <option value="{$entity_type.id}">{$entity_type.type} - {$entity_type.description}</option>
                                    {/foreach}
                                </select><br />
                                Entity Type<br /><br />
                                <select name="entity" id="entity-{$window_id}" class="user-field" style="width: 250px">
                                    <option value=""> </option>
                                </select><br />          
                                Available Entities<br /><br />
                                <input type="button" name="associate_button" id="associate_button-{$window_id}" value=" Associate " />
                                &nbsp;&nbsp;&nbsp;
                                <input type="text" class="user-field" style="width: 80px" name="effective_start_date" id="effective_start_date-{$window_id}" placeholder="Start Date" />&nbsp;
                                <input type="text" class="user-field" style="width: 80px" name="effective_end_date" id="effective_end_date-{$window_id}" placeholder="End Date" />
                                <br /><br />
                                <div style="">
                                    Current Associations
                                    <ul>
                                        <div id="associate_list-{$window_id}">
                                            {foreach from=$associations->fetch() item=association}
                                                <li>
                                                    <a href="">X</a>
                                                    {$association.entity} - {$association.effective_start_date|date_format:"m/d/Y"} - {$association.effective_end_date|date_format:"m/d/Y"}
                                                </li>    
                                            {/foreach}
                                        </div>
                                    </ul>
                                </div>
                            </form>
                        </div>
                    </div>
                    </fieldset>
                    <div style='clear: both'>
                        <br />
                        <form name='additional_information' id='additional_information' onsubmit='return false'>
                            <fieldset style='padding: 0px 10px 10px 10px'><legend style='font-size: 1.2em'>Additional Information</legend>
                                <ul>
                                <a href='#' onclick='$("#new_field_input-{$window_id}").slideToggle(); return false'>Add Additional Field...</a>
                                <div id='new_field_input-{$window_id}' style='display: none'>
                                    <table cellpadding='2' cellspacing='1'>
                                        <tr>
                                            <td style='padding: 2px'><input type='text' name='new_field' id='new_field-{$window_id}' class='user-field' style='width: 200px;' placeholder='Field Name'/></td>
                                            <td style='padding: 2px'><input type='text' name='new_field_value' id='new_field_value-{$window_id}' class='user-field' style='width: 200px;' placeholder='Field Value'/></td>
                                            <td style='padding: 2px'><button id='new_field_submit-{$window_id}' style='width: 40px'>Add</button></td>
                                        </tr>
                                    </table>
                                </div>
                                {foreach from=$additional->load(true) item=value key=field}
                                    {if (($field != 'id') && ($field!='modified') && ($field!='user_id') && ($field != 'window_id'))}
                                        <li style='background-color: rgba(50,50,50,{cycle values=".5,.2"}); font-size: 1.2em'><b>{$field}</b> - {$value}</li>
                                    {/if}
                                {/foreach}
                                </ul>
                            </fieldset>
                        </form>        
                    </div>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    Desktop.window.list['{$window_id}']._title("{$data.first_name} {$data.last_name}");
    $('#new_field_submit-{$window_id}').on('click',function () {
        var field = $('#new_field-{$window_id}').val();
        var val   = $('#new_field_value-{$window_id}').val();
        if (field) {
            (new EasyAjax('/argus/user/additional')).add('window_id','{$window_id}').add(field,val).add('user_id','{$data.id}').then(function (response) {
                Desktop.window.list['{$window_id}'].set(response);
            }).post();
        }
    });
    {if ($appl && isset($appl.appellation_id))}
        $('#appellation_id-{$window_id}').val('{$appl.appellation_id}');
        $('#appellation-{$window_id}').val('{$appl.appellation_id}');
    {/if}
    $('#account_status-{$window_id}').val('{$data.account_status}');
    $('#gender-{$window_id}').val('{$data.gender}');
    
    //Form.intercept(Form Reference,MongoDB ID,optional URL or just FALSE,Dynamic WindowID to Close After Saving,callback);
    Form.intercept($('#user-update-form-{$window_id}').get(),false,'/argus/user/update','{$window_id}',function (response) { 
        Desktop.window.list['{$window_id}']._close();
    } );
    $("#entity_type-{$window_id}").on('change',function (evt) {
        var val = $(evt.target).val();
        if (val) {
            (new EasyAjax('/argus/entity/list')).add('entity_type_id',val).then(function (response) {
                var options = JSON.parse(response);
                var sel     = $E('entity-{$window_id}');
                sel.options.length = 0;
                sel.options[sel.options.length] = new Option('','');
                if (options) {
                    for (var i=0; i<options.length; i++) {
                        sel.options[sel.options.length] = new Option(options[i].entity,options[i].id);
                    }
                }
            }).post();
        } else {
            var sel     = $E('entity-{$window_id}');
            sel.options.length = 0;
            sel.options[sel.options.length] = new Option('','');
        }
    });
    $('#associate_button-{$window_id}').on('click',function (evt) {
        (new EasyAjax('/argus/entity/associate')).add('effective_start_date',$('#effective_start_date-{$window_id}').val()).add('effective_end_date',$('#effective_end_date-{$window_id}').val()).add('user_id','{$data.id}').add('entity_id',$('#entity-{$window_id}').val()).then(function (response) {
            $('#associate_list-{$window_id}').html(response);
        }).post();
    });
    $('#effective_start_date-{$window_id}').datepicker();
    $('#effective_end_date-{$window_id}').datepicker();
</script>