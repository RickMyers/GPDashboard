<div style='width: 700px; display: inline-block; white-space: nowrap'>
    <div style='clear: both'></div>
        <input campaign_id='{$campaign_id}' type="checkbox" value='Y' {if ($campaign->getActive() == 'Y')}checked='checked'{/if} name='active' id='outreach_campaign_active' /> Active Campaign
    <div style='clear: both'></div>        
    <div style="width: 49.9%; height: 200px; float: right">
        <div style=" background-color: rgba(202,202,202,.3); text-align: center">Current Campaign Progress [<span title='Remaining contacts to complete'>{$contacts->totalContacts($campaign_id,'C')}</span>/<span title='Total contacts in campaign'>{$contacts->totalContacts()}</span>]</div>
        <canvas style="width: 310px; height: 180px;" id="outreach_campaign_progress"></canvas>
    </div>      
    <div style='width: 50%; text-align: center; display: inline-block'>
        <div style=" background-color: rgba(202,202,202,.3)">&nbsp;</div>    
        <div style='font-size: 2em; color: #333; padding: 10px'>
        {$campaign->getCampaign()}<br />{$campaign->getDescription()}
        </div>
    </div>

</div>
<table>
    <tr>
        <th style='text-align: center; min-width: 120px'>Coordinator</th>
        <th style='text-align: center; min-width: 120px'>Roles</th>
        <th style='text-align: center; min-width: 120px'>Campaign Contacts</th>
        <th style='text-align: center; min-width: 120px'>Total Contacts</th>
        <th style='text-align: center; min-width: 120px'>Assignment</th>
    </tr>
    {assign var=roleset value=$roles->loadRoles($campaign_id)}
    {foreach from=$participants->usersWithRoleName('outreach') item=user}
        {assign var=role value=$roleset->participantRoles($user.user_id)}
        <tr style="background-color: rgba(202,202,202,{cycle values=".1,.3"})">
            <td style='padding-right: 10px'>{$user.last_name}, {$user.first_name}</td>
            <td>
                <input type="checkbox" class="outreach-manager-user-role participant-manager-{$user.user_id}" participant_id="{$user.user_id}" {if ($role.manager)}checked="checked"{/if} /> Manager&nbsp;&nbsp;&nbsp;
                <input type="checkbox" class="outreach-coordinator-user-role participant-coordinator-{$user.user_id}" participant_id="{$user.user_id}" {if ($role.coordinator)}checked="checked"{/if} /> Coordinator
            </td>
            <td style='text-align: center'>
                {$contacts->assignments($user.user_id,$campaign_id,false,'C')}
            </td>
            <td style='text-align: center'>
                {$contacts->assignments($user.user_id,false,false,'C')}
            </td>
            <td style='text-align: center'>
                <input type="text" class="outreach-coordinator-contact-assignment assignments-{$user.user_id}" participant_id="{$user.user_id}" {if (!($role.manager || $role.coordinator))}readonly='readonly' style='background-color: #bbb'{/if} /> 
            </td>
        </tr>
    {/foreach}
</table>
<script type="text/javascript">
    (function () {
        $('#outreach_campaign_active').on('click',function (evt) {

            let val = evt.target.checked ? 'Y' : 'N';
            let state = (val=='Y') ? 'Enable' : 'Disable';
            if (confirm(state+' the Campaign?')) {
                (new EasyAjax('/outreach/campaign/status')).add('campaign_id',evt.target.getAttribute('campaign_id')).add('active',val).then(function (response) {
                    EasyTabs['outreach_tabs'].click('Administration');
                }).post();
            }
        });
        $('.outreach-coordinator-contact-assignment').on('change',function (evt) {
            let user_id = evt.target.getAttribute('participant_id');
            if ($(evt.target).val()) {
                (new EasyAjax('/outreach/contacts/assign')).add('campaign_id',$('#outreach_admin_campaign').val()).add('user_id',user_id).add('contacts',$(evt.target).val()).then(function (response) {
                    $('#current_campaign_assignments').html(response);
                    Argus.dashboard.socket.emit('userMessageRelay',{ 'message': 'coordinator'+evt.target.getAttribute('participant_id')+'Campaign'+$('#outreach_admin_campaign').val()+'ContactsAssigned' });
                }).post();
            }
        });
        $('.outreach-manager-user-role').on('click',function (evt) {
            let user_id = evt.target.getAttribute('participant_id');
            (new EasyAjax('/outreach/assign/manager')).add('campaign_id',$('#outreach_admin_campaign').val()).add('user_id',user_id).add('manager',(evt.target.checked ? 'Y' : '')).then(function (response) {
            }).post();
            $('.assignments-'+user_id).prop('readonly',(!($('.participant-manager-'+user_id).prop('checked') || $('.participant-coordinator-'+user_id).prop('checked'))));
            $('.assignments-'+user_id).css('background-color',($('.assignments-'+user_id).prop('readonly') ? '#bbb' : 'lightcyan'));
        });
        $('.outreach-coordinator-user-role').on('click',function (evt) {
            let user_id = evt.target.getAttribute('participant_id');            
            (new EasyAjax('/outreach/assign/coordinator')).add('campaign_id',$('#outreach_admin_campaign').val()).add('user_id',evt.target.getAttribute('participant_id')).add('coordinator',(evt.target.checked ? 'Y' : '')).then(function (response) {
            }).post();
            $('.assignments-'+user_id).prop('readonly',(!($('.participant-manager-'+user_id).prop('checked') || $('.participant-coordinator-'+user_id).prop('checked'))));
            $('.assignments-'+user_id).css('background-color',($('.assignments-'+user_id).prop('readonly') ? '#bbb' : 'lightcyan'));
        });
        let options = {
            labels: {
                fontColor: '#ffffff'
            },            
            legend: {
                labels: {
                    fontColor: '#ffffff'
                }
            }
        };
        (function () {
            let data = [
                {
                    value: '{$contacts->assignments(false,$campaign_id,'C')}',
                    color:"Blue",
                    highlight: "#AAAAFF",
                    label: "Completed"
                },            
                {
                    value: '{$contacts->assignments(false,$campaign_id,'N')}',
                    color:"Grey",
                    highlight: "#CCCCCC",
                    label: "Unassigned"
                },
                {
                    value: '{$contacts->assignments(false,$campaign_id,'A')}',
                    color:"Green",
                    highlight: "#AAFFAA",
                    label: "In Progress"
                },
                {
                    value: '{$contacts->assignments(false,$campaign_id,'R')}',
                    color:"#333333",
                    highlight: "#777777",
                    label: "Returned"
                }
            ];
            (new Chart($("#outreach_campaign_progress").get(0).getContext("2d")).Pie(data,options));
        })();
    })();
</script>
                    
