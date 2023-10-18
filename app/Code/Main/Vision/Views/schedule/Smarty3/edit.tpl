{assign var=event_id value=$event->getId()}
{assign var=event value=$event->details()}
{assign var=client value=$client->setId($event.client_id)->load()}
<style type="text/css">
    .scheduler-event-row {
        white-space: nowrap; overflow: hidden; width: 100%; margin: 0px; line-height: normal
    }
    .scheduler-event-cell {
        display: inline-block;  overflow: hidden; margin-right: 2px; border-right: 1px solid silver; background-color: rgba(202,202,202,.6)
    }
    .scheduler-event-header {
        font-family: monospace; font-size: .9em; letter-spacing: 2px; padding-left: 4px; overflow: hidden
    }
    .scheduler-event-field {
        font-family: sans-serif; font-size: 1em;  padding-left: 20px; overflow: hidden
    }
    .screening-new-attendee {
        width: 100%; background-color: lightcyan; border: 1px solid silver; padding: 2px; border-radius: 2px
    }
    .screening-stats-field {
        width: 60px; text-align: center; background-color: lightcyan; border: 1px solid #aaf; padding: 2px; margin-right: 15px;
    }
    .half       { width: 49.5% }
    .quarter    { width: 24.5% }
    .third      { width: 32.5% }
    .full       { width: 99.5% }
    .twothird   { width: 65.5% }
    .threefourth{ width: 74.5% }
    .fifth      { width: 19.5% }
    .twofifth   { width: 39.5% }
    .threefifth { width: 59.5% }
    .sixth      { width: 14% }
    .tenth      { width: 9.5%  }
    .seventh    { width: 12.5% }
</style>

    <div id="event-tabs-{$event_id}">
    </div>
    <div id="event-attachments-{$event_id}">
        <form onsubmit="return false">
            <div>
                <div id="event_attachments_header_{$event_id}" style="position: relative; background-color: rgba(202,202,242,.3); font-family: sans-serif; font-size: 1.1em; letter-spacing: 2px; padding: 2px">
                    Attachments
                </div>
                <div style="position: relative; border: 1px solid silver; padding: 2px 5px; height: 250px" id="event_attachments_{$event_id}">
                </div>
                <div style="position: relative; padding: 2px" id="event_attachments_upload_{$event_id}">
                    <input type="file" name="attachment" id="event_attachment_{$event_id}" style="background-color: lightcyan; border: 1px solid silver; width: 100%" placeholder="Attachment..."/>
                </div>            
            </div>
        </form>
        <script>
            $('#event_attachment_{$event_id}').on('change',function (evt) {
                if (confirm('Would you like to upload this attachment now?')) {
                    var description = prompt("Please enter an optional file description");
                    (new EasyAjax('/vision/event/attachment')).add('event_id',"{$event_id}").add('description',description).addFiles("attachment",$E('event_attachment_{$event_id}')).then(function (response) {
                        $('#event_attachments_{$event_id}').html(response);
                    }).post();
                }
            });
        </script>                
    </div>     
    <div id="event-details-{$event_id}" style="margin-bottom: 50px">
        <form onsubmit="return false" name="schedule-event-edit-form" id="schedule-event-edit-form-{$event_id}">        
        <div class="scheduler-event-row">
            <div class="scheduler-event-cell twofifth">
                <div class="scheduler-event-header">
                    Event Type
                </div>
                <div class="scheduler-event-field">
                    [{$event.namespace|ucfirst}] {$event.type}&nbsp; -- {$event.event_type|strtoupper}
                </div>
            </div>
            <div class="scheduler-event-cell fifth">
                <div class="scheduler-event-header">
                    Start Time
                </div>
                <div class="scheduler-event-field">
                    {$event.start_date} @ {$event.start_time}&nbsp;
                </div>
            </div>
            <div class="scheduler-event-cell fifth">
                <div class="scheduler-event-header">
                    End Time
                </div>
                <div class="scheduler-event-field">
                   {$event.end_date} {$event.end_time}&nbsp;
                </div>
            </div>
            <div class="scheduler-event-cell fifth">
                <div class="scheduler-event-header">
                    Health Plan
                </div>
                <div class="scheduler-event-field">
                    {if (isset($client.client))}{$client.client}{else}N/A{/if}&nbsp;
                </div>
            </div>                    
        </div><div class="scheduler-event-row">
            <div class="scheduler-event-cell half">
                <div class="scheduler-event-header">
                    Business Name
                </div>
                <div class="scheduler-event-field">
                  {$event.ipa_id_combo} - {$event.location_id_combo}&nbsp;
                </div>
            </div>
            <div class="scheduler-event-cell half">
                <div class="scheduler-event-header">
                    Location
                </div>
                <div class="scheduler-event-field">
                    {$event.address_id_combo}&nbsp;
                </div>
            </div>
        </div><div class="scheduler-event-row">
            <div class="scheduler-event-cell twofifth">
                <div class="scheduler-event-header">
                    Contact Name
                </div>
                <div class="scheduler-event-field">
                    {if (isset($event.contact_name))}{$event.contact_name}{/if}&nbsp;
                </div>
            </div>
            <div class="scheduler-event-cell fifth">
                <div class="scheduler-event-header">
                    Contact Phone
                </div>
                <div class="scheduler-event-field">
                    {if (isset($event.contact_phone))}{$event.contact_phone}{/if}&nbsp;
                </div>
            </div>
            <div class="scheduler-event-cell fifth">
                <div class="scheduler-event-header">
                    Contact E-mail
                </div>
                <div class="scheduler-event-field">
                    {if (isset($event.contact_email))}{$event.contact_email}{/if}&nbsp;
                </div>
            </div>        
            <div class="scheduler-event-cell fifth">
                <div class="scheduler-event-header">
                    Location NPI
                </div>
                <div class="scheduler-event-field">
                    {if (isset($event.npi_id_combo))}{$event.npi_id_combo}{/if}&nbsp;
                </div>
            </div>     
        </div>
        <div class="scheduler-event-row">
            <div class="scheduler-event-cell third">
                <div class="scheduler-event-header">
                    Technician
                </div>
                <div class="scheduler-event-field">
                    <select class="screening-new-attendee" id='screening_technician_{$event_id}' name='screening_technician'>
                        <option value=''> </option>
                        {foreach from=$users->getUsersByRoleName('PCP Staff') item=user}
                            <option value='{$user.user_id}'>{$user.last_name}, {$user.first_name}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="scheduler-event-cell third">
                <div class="scheduler-event-header">
                    O.D.
                </div>
                <div class="scheduler-event-field">
                    <select class="screening-new-attendee" id='screening_od_{$event_id}' name='screening_od'>
                        <option value=''> </option>
                        {foreach from=$users->getUsersByRoleName('O.D.') item=user}
                            <option value='{$user.user_id}'>{$user.last_name}, {$user.first_name}</option>
                        {/foreach}    
                    </select>
                </div>
            </div>   
            <div class="scheduler-event-cell third">
                <div class="scheduler-event-header">
                    Equipment
                </div>
                <div class="scheduler-event-field">
                    <select class="screening-new-attendee" id='screening_equipment_{$event_id}' name='screening_equipment'>
                        <option value=''> </option>
                        <option value='Volk'>Volk</option>
                        <option value='Welsh/Allyn'>Welch/Allyn</option>
                        <option value='Other'>Other</option>
                    </select>            
                </div>
            </div>     
        </div>        
        <div class="scheduler-event-row">
            <div class="scheduler-event-cell full">
                <div class="scheduler-event-header">
                    Attendees
                </div>
                <div class="scheduler-event-field">
                    <div id="new-event-member-list" style="background-color: lightcyan; overflow: auto; height: 120px; border: 1px solid silver">

                    </div>
                </div>
            </div>  
        </div></form><div style="border: 1px solid silver; padding: 2px">
            <form name="vision_screening_new_attendee" id="vision_screening_new_attendee_{$event_id}" onsubmit="return false;"><div class="scheduler-event-row">
            <input type="hidden" name="health_plan" id="health_plan_{$event_id}" value="{if (isset($client.client))}{$client.client}{/if}" />
            <input type="hidden" name="event_id" id="event_id_{$event_id}" value="{$event_id}" />
            <div class="scheduler-event-row">
                <div class="scheduler-event-cell">
                    <div class="scheduler-event-header">
                        Add Member
                    </div>        
                    <div class="scheduler-event-field">
                        <input type="button" id="add_member_button_{$event_id}" name="add_member_button" style="font-weigh: bold; font-size: 1.2em" value=" + " /><br />
                    </div>
                </div>
                <div class="scheduler-event-cell sixth">
                    <div class="scheduler-event-header">
                        Member ID
                    </div>
                    <div class="scheduler-event-field">
                        <input type="text" id="member_number_{$event_id}" name="member_number" class="screening-new-attendee" />
                    </div>
                </div>
                <div class="scheduler-event-cell sixth">
                    <div class="scheduler-event-header">
                        HBA1C
                    </div>
                    <div class="scheduler-event-field">
                        <input type="text" id="member_hba1c_{$event_id}" name="member_hba1c" class="screening-new-attendee" />
                    </div>
                </div>        
                <div class="scheduler-event-cell sixth">
                    <div class="scheduler-event-header">
                        HBA1C Date
                    </div>
                    <div class="scheduler-event-field">
                        <input type="text" id="member_hba1c_date_{$event_id}" name="member_hba1c_date" class="screening-new-attendee" placeholder="MM/DD/YYYY" />
                    </div>
                </div> 
                <div class="scheduler-event-cell sixth">
                    <div class="scheduler-event-header">
                        FBS
                    </div>
                    <div class="scheduler-event-field">
                        <input type="text" id="member_fbs_{$event_id}" name="member_fbs" class="screening-new-attendee" />
                    </div>
                </div>   
                <div class="scheduler-event-cell sixth">
                    <div class="scheduler-event-header">
                        FBS Date
                    </div>
                    <div class="scheduler-event-field">
                        <input type="text" id="member_fbs_date_{$event_id}" name="member_fbs_date" class="screening-new-attendee"  placeholder="MM/DD/YYYY" />
                    </div>
                </div>              
  
                <div class="scheduler-event-cell sixth">
                    <div class="scheduler-event-header">
                        Diabetes Type
                    </div>
                    <div class="scheduler-event-field">
                        <input type="radio" name="diabetes_type" id="diabetes_type_1_{$event_id}" value="1" /> Type 1
                        <input type="radio" name="diabetes_type" id="diabetes_type_2_{$event_id}" value="2" /> Type 2
                    </div>
                </div>        
            </div>              
                
            <div class="scheduler-event-row">
                <div class="scheduler-event-cell full">
                    <div class="scheduler-event-header">
                        Member List
                    </div>
                    <div class="scheduler-event-field">
                        <input type="file" id="member_list_{$event_id}" name="member_list" class="screening-new-attendee" />
                    </div>
                </div>          
            </div>
            </div>
          </form>
        </div>  
        
        <div class="scheduler-event-row">
            <div class="scheduler-event-cell full">
                <div class="scheduler-event-field" style='text-align: right; float: right'>
                    <img title="Generate Forms" src="/images/vision/gears.png" style="cursor: pointer; height: 30px; margin-right: 5px" onclick="Argus.vision.consultation.generate.forms('{$event_id}')" />
                    <img title="Create Reports" src="/images/vision/create_reports.png" style="cursor: pointer; height: 30px; margin-right: 5px" onclick="Argus.vision.consultation.generate.reports('{$event_id}')" />
                    <img title="Cancel Event" src="/images/vision/cancel.png" style="cursor: pointer; height: 30px; margin-right: 5px" onclick="Argus.vision.event.cancel('{$event_id}')" />
                </div>                
                <div style="white-space: nowrap; float: left; padding-top: 5px">
                    <form name="event_stats_form" id="event_stats_form_{$event_id}" onsubmit="return false">
                    Eligible: <input type="text" readonly="readonly" name="event_eligible" id="event_eligible_{$event_id}" class="screening-stats-field" value="0" />
                    Actual: <input type="text" readonly="readonly" name="event_actual" id="event_actual_{$event_id}" class="screening-stats-field" value="0"/>
                    Gaps: <input type="text" readonly="readonly" name="event_actual" id="event_gaps_{$event_id}" class="screening-stats-field" value="0" />
                    </form>
                </div>
            </div>
        </div>
</div>
<div id="event-recap-{$event_id}" style="margin-bottom: 50px">
</div>
<script type='text/javascript'>
    (new EasyAjax('/vision/schedule/listmembers')).add('event_id','{$event_id}').then(function (response) {
        $('#new-event-member-list').html(response);
    }).post();
    (function () {
        var tabs = new EasyTab('event-tabs-{$event_id}',160);
        tabs.add('Event Details',null,'event-details-{$event_id}');
        var ff = function () {
            (new EasyAjax('/vision/event/recap')).add('event_id',"{$event_id}").then(function (response) {
                $('#event-recap-{$event_id}').html(response);
            }).post();
        };
        tabs.add('Recap',ff,'event-recap-{$event_id}');
        var f = function () {
            (new EasyAjax('/vision/event/attachments')).add('event_id',"{$event_id}").then(function (response) {
                $('#event_attachments_{$event_id}').html(response);
            }).post();
        };
        tabs.add('Attachments',f,'event-attachments-{$event_id}');
        tabs.tabClick(0);
        var ee = new EasyEdits(null,"vision_schedule_add_member_form_{$event_id}");
        ee.fetch("/edits/vision/addmember");
        ee.process(ee.getJSON().replace(/&&event_id&&/g,'{$event_id}'));
        $('#vision_screening_new_attendee_{$event_id}').on('change',function (evt) {
            if (evt.target.id === 'member_list_{$event_id}') {
                var win = Desktop.whoami('schedule-event-edit-form-{$event_id}');
                Desktop.window.list[win].splashScreen(Humble.template('vision/MemberUploadWait'));
                var ao = new EasyAjax('/vision/events/upload');
                ao.add('health_plan','{$client.client}').add('client_id','{$event.client_id}').addFiles('member_list',$E('member_list_{$event_id}')).add('event_id','{$event_id}').then(function (response) {
                    $('#new-event-member-list').html(response);
                    Desktop.window.list[win].splashScreen(false);
                }).post();
            }            
        });
        $('#schedule-event-edit-form-{$event_id}').on('change',function (evt) {
            var field_name = evt.target.name;
            var field_value = $(evt.target).val();
            (new EasyAjax('/vision/event/update')).add(field_name,field_value).add('event_id','{$event_id}').then(function (response) {
                (new EasyAjax('/vision/event/notifications')).add(field_name,field_value).add('event_id','{$event_id}').then(function (response) {
                   console.log(response);
                }).post();
            }).post();
        });
        Desktop.window.list[Desktop.whoami('event-tabs-{$event_id}')]._title('Event {$event_id} Details')
    })();
    {foreach from=$event item=stuff key=other}
        {if ($other != 'geocode_location')}
        if ($E('{$other}_{$event_id}')) {
            $('#{$other}_{$event_id}').val("{$stuff}");
        }
        {/if}
    {/foreach}
</script>
        
