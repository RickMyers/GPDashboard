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
        font-family: monospace; font-size: .9em; letter-spacing: 2px; color: #333
    }
    .nc_field {
        font-family: sans-serif; color: black; font-size: 1.2em; padding-left: 15px; height: 25px
    }
</style>
{assign var=participant value=$result->details()}
<div class='consultation_form'>
    <fieldset><legend>Location Information</legend>
        <input type='hidden' name='contact_id' id='contact_id-{$window_id}' value='{$participant.contact_id}' />
        <input type='hidden' name='campaign_id' id='campaign_id-{$window_id}' value='{$participant.campaign_id}' />
        <div class='nc_row'>

            <div class='nc_cell' style='width: 40%'>
                <div class='nc_desc'>
                    Address
                </div>
                <div class='nc_field'>
                    {$participant.address}
                </div>
            </div>
            <div class='nc_cell'  style='width: 20%'>
                <div class='nc_desc'>
                    City
                </div>
                <div class='nc_field'>
                    {$participant.city}
                </div>
            </div>
            <div class='nc_cell'  style='width: 20%'>
                <div class='nc_desc'>
                    State
                </div>
                <div class='nc_field'>
                    {$participant.state}
                </div>
            </div>
            <div class='nc_cell'  style='width: 20%'>
                <div class='nc_desc'>
                    ZIP Code
                </div>
                <div class='nc_field'>
                   &nbsp; {$participant.zip_code}
                </div>
            </div>

        </div>

        <div class='nc_row'>
            <div class='nc_cell' style='width: 25%'>
                <div class='nc_desc'>
                    Assigned
                </div>
                <div class='nc_field'>
                    {assign var=avatar value='../images/argus/avatars/'|cat:$participant.assignee|cat:'.jpg'}
                    {if ($file->exists($avatar))}
                        <img src="/images/argus/avatars/{$participant.assignee}.jpg" style="height: 25px; float: left; margin-right: 5px" />
                    {else}
                        <img src="/images/argus/placeholder-{$participant.assignee_gender}.png" style="height: 25px; float: left; margin-right: 5px" />
                    {/if}                    
                    {$participant.assignee_first_name} {$participant.assignee_last_name}
                </div>
            </div>
                <div class='nc_cell ' style='width: 20%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Phone Number
                    </div>
                    <div class='nc_field'>
                        <b>{$participant.phone_number}</b>
                    </div>
                </div>                
            <div class='nc_cell' style='width: 20%'>
                <div class='nc_desc'>
                    Working Number
                </div>
                <div class='nc_field'>
                    {if ($participant.working_number == 'Y')}Yes{elseif ($participant.working_number == 'N')}No{else}N/A{/if}
                </div>
            </div>
            <div class='nc_cell'  style='width: 20%'>
                <div class='nc_desc'>
                    Wrong Number
                </div>
                <div class='nc_field'>
                    {if ($participant.wrong_number == 'Y')}Yes{elseif ($participant.wrong_number == 'N')}No{else}N/A{/if}
                </div>
            </div>
            <div class='nc_cell'  style='width: 20%'>
                <div class='nc_desc'>
                    Left Message
                </div>
                <div class='nc_field'>
                    {if ($participant.left_message == 'Y')}Yes{elseif ($participant.left_message == 'N')}No{else}N/A{/if}
                </div>
            </div>

        </div>
        </fieldset>
        <br /><br />


        <fieldset><legend>Member Information</legend>

            <div class='nc_row'>
                <div class='nc_cell ' style='width: 14%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Member ID
                    </div>
                    <div class='nc_field'>
                        {$participant.member_id}
                    </div>
                </div>

                <div class='nc_cell' style='width: 14%; margin-right: .1%'>
                    <div class='nc_desc'>
                        First Name
                    </div>
                    <div class='nc_field'>
                        {$participant.first_name}
                    </div>
                </div>
                <div class='nc_cell' style='width: 14%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Last Name
                    </div>
                    <div class='nc_field'>
                        {$participant.last_name}
                    </div>
                </div>
                <div class='nc_cell' style='width: 14%; margin-right: .1%'>
                    <div class='nc_desc'>
                        DOB
                    </div>
                    <div class='nc_field'>
                        {$participant.date_of_birth|date_format:"%m/%d/%Y"}
                    </div>
                </div>
                <div class='nc_cell' style='width: 14%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Counseling Completed
                    </div>
                    <div class='nc_field'>
                        {if ($participant.counseling_completed == 'Y')}Yes{elseif ($participant.counseling_completed == 'N')}No{else}N/A{/if}
                    </div>
                </div>                     
                <div class='nc_cell' style='width: 14%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Appointment Requested
                    </div>
                    <div class='nc_field'>
                        {if ($participant.requested_appointment == 'Y')}Yes{elseif ($participant.requested_appointment == 'N')}No{else}N/A{/if}
                    </div>
                </div>
                <div class='nc_cell' style='width: 14%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Yearly Dental Visit
                    </div>
                    <div class='nc_field'>
                        {if ($participant.yearly_dental_visit == 'Y')}Yes{elseif ($participant.yearly_dental_visit == 'N')}No{else}N/A{/if}
                    </div>
                </div>

        </fieldset>
        <br /><br />
        
        <fieldset><legend>Additional Comments</legend>
            {foreach from=$logs->fullComments($participant.contact_id) item=log}
                <div class='nc_row' style="background-color: rgba(202,202,202,{cycle values=".1,.3"}); overflow: visible">
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
                        <div class='nc_field' style="padding: 10px; white-space: normal; overflow: visible">
                            {$log.comments}
                        </div>
                    </div>
                </div>
                <div style="clear: both; margin-top: 2px; margin-bottom: 2px"></div>                        
            {/foreach}
        </fieldset>   
        <br /><br /><br /><br />
</div>