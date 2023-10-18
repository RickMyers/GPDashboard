<style type='text/css'>
    .consultation_form {
        padding: 5px
    }
    .narrow_width {
        width: 15%;
    }
    .medium_width {
        width: 25%
    }
    .wide_width {
        width: 50%
    }
    .full_width{
        width: 100%;
    }
    .nc_row {
        min-width: 600px; overflow: hidden; white-space: nowrap
    }
    .nc_cell {
        padding: 2px; display: inline-block; background-color: rgba(202,202,202,.2); margin-right: 2px; margin-bottom: 1px; overflow: hidden; min-width: 120px
    }
    .nc_desc {
        font-family: monospace; font-size: .8em; letter-spacing: 2px; color: #333
    }
    .nc_field {
        font-family: sans-serif; color: black; font-size: 1em; padding-left: 15px
    }
</style>
{assign var=members value=$contacts->details()}
{assign var=first value=true}
<form name='hedis-contact-form' id='hedis-contact-form-{$window_id}'>
    <div class='consultation_form'>
    {foreach from=$members item=member}
        {if ($first)}
            {if ($member.status == 'D')}
            <div style="background-color: #990000; padding: 10px; color: white; font-size: 1.3em; font-weight: bold">
                Do Not Call
            </div>
            {/if}
            <fieldset><legend>Location Information</legend>
                <input type='hidden' name='contact_id' id='contact_id-{$window_id}' value='{$member.contact_id}' />
                <input type='hidden' name='campaign_id' id='campaign_id-{$window_id}' value='{$member.campaign_id}' />
                <div class='nc_row'>

                    <div class='nc_cell' style='width: 40%'>
                        <div class='nc_desc'>
                            Address
                        </div>
                        <div class='nc_field'>
                            {$member.address}
                        </div>
                    </div>
                    <div class='nc_cell'  style='width: 20%'>
                        <div class='nc_desc'>
                            City
                        </div>
                        <div class='nc_field'>
                            {$member.city}
                        </div>
                    </div>
                    <div class='nc_cell'  style='width: 20%'>
                        <div class='nc_desc'>
                            State
                        </div>
                        <div class='nc_field'>
                            {$member.state}
                        </div>
                    </div>
                    <div class='nc_cell'  style='width: 20%'>
                        <div class='nc_desc'>
                            ZIP Code
                        </div>
                        <div class='nc_field'>
                           &nbsp; {$member.zip_code}
                        </div>
                    </div>

                </div>

                <div class='nc_row'>
                    <div class='nc_cell' style='min-width: 230px; width: 20%'>
                        <div class='nc_desc'>
                            Assigned
                        </div>
                        <div class='nc_field'>
                            <select name="assigned" style="padding: 2px; background-color: lightcyan; border: 1px solid #aaf" id='assignee-{$window_id}'>
                                <option value=''></option>
                                {foreach from=$hygenists->getUsersByRoleName() item=hygenist}
                                    <option value='{$hygenist.user_id}'>{$hygenist.first_name} {$hygenist.last_name}</option>
                                {/foreach}
                            </select>
                            <input type='button' value='Assign' id="assign-button-{$window_id}" class='settingsbutton' />
                        </div>
                    </div>
                    <div class='nc_cell ' style='width: 19%; margin-right: .1%'>
                        <div class='nc_desc'>
                            Phone Number
                        </div>
                        <div class='nc_field'>
                            {if ($member.phone_number)}
                                <b>{$member.phone_number}</b>
                            {else}
                                <span style="color: red; font-weight: bold">N/A</span>
                            {/if}
                        </div>
                    </div>                    
                    <div class='nc_cell' style='width: 19%'>
                        <div class='nc_desc'>
                            Working Number
                        </div>
                        <div class='nc_field'>
                            {if ($member.working_number == 'Y')}Yes{elseif ($member.working_number == 'N')}No{else}N/A{/if}
                        </div>
                    </div>
                    <div class='nc_cell'  style='width: 19%'>
                        <div class='nc_desc'>
                            Wrong Number
                        </div>
                        <div class='nc_field'>
                            {if ($member.wrong_number == 'Y')}Yes{elseif ($member.wrong_number == 'N')}No{else}N/A{/if}
                        </div>
                    </div>
                    <div class='nc_cell'  style='width: 19%'>
                        <div class='nc_desc'>
                            Left Message
                        </div>
                        <div class='nc_field'>
                            {if ($member.left_message == 'Y')}Yes{elseif ($member.left_message == 'N')}No{else}N/A{/if}
                        </div>
                    </div>
                </div>
            </fieldset>
            <br /><br />
            <fieldset><legend>Member Information</legend>
            {/if}
            <div class='nc_row'>
                <div class='nc_cell ' style='width: 10%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Campaign
                    </div>
                    <div class='nc_field'>
                        {$member.campaign_id}
                    </div>
                </div>                
                <div class='nc_cell ' style='width: 10%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Member ID
                    </div>
                    <div class='nc_field'>
                        {$member.member_id}
                    </div>
                </div>

                <div class='nc_cell' style='width: 10%; margin-right: .1%'>
                    <div class='nc_desc'>
                        First Name
                    </div>
                    <div class='nc_field'>
                        {$member.first_name}
                    </div>
                </div>
                <div class='nc_cell' style='width: 10%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Last Name
                    </div>
                    <div class='nc_field'>
                        {$member.last_name}
                    </div>
                </div>
                <div class='nc_cell' style='width: 10%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Phone Number
                    </div>
                    <div class='nc_field'>
                        {$member.phone_number}&nbsp;
                    </div>
                </div>                    
                <div class='nc_cell' style='width: 12%; margin-right: .1%'>
                    <div class='nc_desc'>
                        DOB
                    </div>
                    <div class='nc_field'>
                        {$member.date_of_birth|date_format:"%m/%d/%Y"}
                    </div>
                </div>
                <div class='nc_cell' style='width: 12%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Counseling Completed
                    </div>
                    <div class='nc_field'>
                        {if ($member.counseling_completed == 'Y')}<b>Yes</b>{elseif ($member.counseling_completed == 'N')}<b>No</b>{else}N/A{/if}
                    </div>
                </div>                      
                <div class='nc_cell' style='width: 12%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Appointment Requested
                    </div>
                    <div class='nc_field'>
                        {if ($member.requested_appointment == 'Y')}<b>Yes</b>{elseif ($member.requested_appointment == 'N')}<b>No</b>{else}N/A{/if}
                    </div>
                </div>
                <div class='nc_cell' style='width: 12%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Yearly Dental Visit
                    </div>
                    <div class='nc_field'>
                        {if ($member.yearly_dental_visit == 'Y')}<b>Yes</b>{elseif ($member.yearly_dental_visit == 'N')}<b>No</b>{else}N/A{/if}
                    </div>
                </div>
            </div>
            {assign var=first value=false}
        {/foreach}
        </fieldset>

        <br /><br />

        <fieldset><legend>Additional Comments</legend>
            {foreach from=$logs->fullComments() item=log}
                <div class='nc_row' style="background-color: rgba(202,202,202,{cycle values=".1,.3"})" style="overflow: visible">
                    <div class='nc_cell full_width' style="overflow: visible">
                        <div class='nc_desc'>
                            {assign var=avatar value='../images/argus/avatars/'|cat:$log.user_id|cat:'.jpg'}
                            {if ($file->exists($avatar))}
                                <img src="/images/argus/avatars/{$log.user_id}.jpg" style="height: 50px; float: left; margin-right: 4px" />
                            {else}
                                <img src="/images/argus/placeholder-{$log.gender}.png" style="height: 50px; float: left; margin-right: 4px" />
                            {/if}                            
                            {$log.modified|date_format:'m/d/Y'}: {$log.first_name} {$log.last_name}
                            {if ($log.attempt)}
                                Attempt #{$log.attempt}
                            {/if}
                        </div>                        
                        <div class='nc_field' style="padding: 10px; white-space: normal">
                            {$log.comments}
                        </div>
                    </div>
                </div>
                <div style="clear: both; margin-top: 2px; margin-bottom: 2px"></div>                        
            {/foreach}
        </fieldset>


    </div>
</form>
<script type='text/javascript'>
    $('#assignee-{$window_id}').val('{$member.assignee}');
    $('#assign-button-{$window_id}').on('click',function (evt) {
        (new EasyAjax('/dental/hedis/reassign')).add('assignee',$('#assignee-{$window_id}').val()).add('contact_id','{$member.contact_id}').then(function (response) {
            Desktop.window.list['{$window_id}']._close();
        }).post();
    });
    Desktop.window.list['{$window_id}']._scroll(true);
</script>
