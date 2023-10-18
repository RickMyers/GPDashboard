<style type="text/css">
    .outreach-contact-header {
        font-size: 1.5rem; margin-bottom: 10px; margin-top: 20px; white-space: nowrap; overflow: hidden
    }
    .outreach-contact-row {
        overflow: hidden; white-space: nowrap; box-sizing: border-box; margin-bottom: 3px
    }
    .outreach-contact-cell {
        display: inline-block; border-right: 1px solid #d7d7d7; min-width: 120px; margin: 0px; background-color: rgba(33,33,33,.1); padding: 2px
    }
    .outreach-contact-desc {
        font-family: monospace; letter-spacing: 2px; font-size: .9em; color: #333
    }
    .outreach-contact-field {
        font-family: sans-serif; font-size: 1em; padding-left: 20px;
    }
    .outreach-contact-log {
        width: 95%; padding: 5px; border-radius: 5px; border: 1px solid #aaf; color: #333; height: 90px; background-color: lightcyan; font-family: monospace
    }
    .outreach-log-entry {
        border: 1px solid #333; margin-bottom: 2px
    }
    .outreach-log-heading {
        font-weight: bolder; font-family: monospace; letter-spacing: 1px; font-size: .9em; padding: 5px; background-color: #aaa; color: #333
    }
    .outreach-log-body {
        padding: 10px; font-family: sans-serif; font-size: .95em; background-color: #d5d5d5; color: #333;
    }
    .outreach-icon {
          cursor: pointer; height: 35px; display: inline-block; 
    }
    .outreach-icon:hover {
        background-color: rgba(202,202,202,.3)
    }
    .outreach-return-icon {
      
    }
    .outreach-complete-icon {
        
    }
    .outreach-assignee {
        padding: 2px; border: 1px solid #aaf; background-color: lightcyan; color: #333
    }
</style>

    <div class="outreach-contact-header">
        <div style='float: right; padding: 5px ; border-radius: 40px; background-color: cornsilk; border: 1px solid #333; margin-right: 10px'>
            <img src='/images/outreach/return_contact.png' style='cursor: pointer' class='outreach-icon outreach-return-icon' contact_id='{$contact_id}' campaign_id='{$contact.campaign_id}'  title='Return Contact' onclick='Argus.outreach.contact.return()' member='{$contact.member_name}' window_id='{$window_id}' />
            <img src='/images/outreach/make_call.png' style='cursor: pointer' class='outreach-icon outreach-call-icon' contact_id='{$contact_id}' campaign_id='{$contact.campaign_id}' title='Make Call' onclick='Argus.outreach.contact.attempt()' member='{$contact.member_name}' window_id='{$window_id}' />
            <img src='/images/outreach/close_gap.png' style='cursor: pointer' class='outreach-icon outreach-complete-icon' contact_id='{$contact_id}' campaign_id='{$contact.campaign_id}' title='Complete Outreach' onclick='Argus.outreach.contact.complete()' member='{$contact.member_name}' window_id='{$window_id}' />
        </div>
        Member Information
    </div>

    <div class="outreach-contact-row">
        <div class="outreach-contact-cell" style="width: 20%">
            <div class="outreach-contact-desc">
                Member Number
            </div>
            <div class="outreach-contact-field">
                {$contact.member_number}&nbsp;
            </div>
        </div>
        <div class="outreach-contact-cell" style="width: 40%">
            <div class="outreach-contact-desc">
                Member Name
            </div>
            <div class="outreach-contact-field">
                {$contact.member_name}&nbsp;
            </div>
        </div>
        <div class="outreach-contact-cell" style="width: 20%">
            <div class="outreach-contact-desc">
                DOB
            </div>
            <div class="outreach-contact-field">
                {$contact.date_of_birth}&nbsp;
            </div>
        </div>
        <div class="outreach-contact-cell" style="width: 15%">
            <div class="outreach-contact-desc">
                Phone #
            </div>
            <div class="outreach-contact-field">
                {$contact.member_phone}&nbsp;
            </div>
        </div>
        <div class="outreach-contact-cell" style="width: 5%">
            <div class="outreach-contact-desc">
                Attempts
            </div>
            <div class="outreach-contact-field" id="outreach_attempts-{$window_id}">
                {$contact.attempts}&nbsp;
            </div>
        </div>            
    </div>
    <div style="clear: both"></div>
    <div class="outreach-contact-row">
        <div class="outreach-contact-cell" style="width: 40%">
            <div class="outreach-contact-desc">
                Member Address
            </div>
            <div class="outreach-contact-field">
                {$contact.member_address}&nbsp;
            </div>
        </div>
        <div class="outreach-contact-cell" style="width: 20%">
            <div class="outreach-contact-desc">
                Contact Added
            </div>
            <div class="outreach-contact-field">
                {$contact.date_added}&nbsp;
            </div>
        </div>
        <div class="outreach-contact-cell" style="width: 20%">
            <div class="outreach-contact-desc">
                Gap Closed
            </div>
            <div class="outreach-contact-field">
                {$contact.gap_closed_date}&nbsp;
            </div>
        </div>                    
        <div class="outreach-contact-cell" style="width: 20%">
            <div class="outreach-contact-desc">
                Assignee
            </div>
            <div class="outreach-contact-field">
                <select name='assignee' class="outreach-assignee" id="outreach_assignee_{$contact_id}" contact_id="{$contact_id}">
                    <option value=""> </option>
                    {foreach from=$roles->usersWithRoleName('outreach') item=user}
                        <option value="{$user.user_id}"> {$user.last_name}, {$user.first_name} </option>
                    {/foreach}
                </select>
            </div>
        </div>               
    </div>
    <div class="outreach-contact-header">PCP Information <div  style='float: right; margin-right: 10px'>Follow Up: <input onclick='Argus.outreach.contact.followup()' type='checkbox' class='outreach-follow-up' contact_id='{$contact_id}' value='Y' {if ($contact.follow_up == "Y")}checked='checked'{/if}/></div></div>
    <div class="outreach-contact-row">
        <div class="outreach-contact-cell" style="width: 20%">
            <div class="outreach-contact-desc">
                PCP Name
            </div>
            <div class="outreach-contact-field">
                {$contact.pcp_name}&nbsp;
            </div>
        </div>
        <div class="outreach-contact-cell" style="width: 20%">
            <div class="outreach-contact-desc">
                PCP NPI
            </div>
            <div class="outreach-contact-field">
                {$contact.pcp_npi}&nbsp;
            </div>
        </div>
        <div class="outreach-contact-cell" style="width: 60%">
            <div class="outreach-contact-desc">
                PCP Address
            </div>
            <div class="outreach-contact-field">
                {$contact.pcp_address}&nbsp;
            </div>
        </div>                           
    </div>
<div class="outreach-contact-header">Contact Log</div>
<textarea class="outreach-contact-log" contact_id="{$contact_id}" window_id="{$window_id}" onkeypress='Argus.outreach.contact.log()'></textarea>
{foreach from=$logs->review() item=log}
    <div class="outreach-log-entry">
        <div class="outreach-log-heading">
            {$log.author} @ {$log.log_date|date_format:'m/d/Y H:i:s'}
        </div>
        <div class="outreach-log-body">
            {$log.log}
        </div>
    </div>
{/foreach}
<br /><br /><br /><br /><br /><br />
<script type="text/javascript">
    (function () {
        let data = { 'user_id': Branding.id,
                     "member": "{$contact.member_name}",
                     'message': 'outreachContactOpened'};
        Argus.dashboard.socket.emit('messageRelay',data);        
        $('#outreach_assignee_{$contact_id}').on('change',function (evt) {
            (new EasyAjax('/outreach/contacts/assign')).add('contact_id',evt.target.getAttribute('contact_id')).add('assignee'.$(evt.target).val()).then(function (response) {
            }).post();
        });
        $('#outreach_assignee_{$contact_id}').val({$contact.assignee});
        Desktop.window.list['{$window_id}'].close = function () { 
            let data = { "contact_id": '{$contact_id}',"user_id": Branding.id, 'message': 'outreachContactClosed' }
            Argus.dashboard.socket.emit('messageRelay',data);
            return true;
        };        
    })();

</script>
        