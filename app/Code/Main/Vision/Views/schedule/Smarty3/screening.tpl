{assign var=details value=$event->load()}
<style type="text/css">
    .scheduler-row {
        white-space: nowrap; overflow: hidden; margin-bottom: 2px; 
    }
    .scheduler-field-cell {
        margin-right: .1%;  background-color: rgba(202,202,202,.2); display: inline-block
    }
    .scheduler-field-header {
        font-size: .85em; letter-spacing: 2px; font-style: monospace; color: #333;
    }
    .scheduler-field-value {
        padding-left: 20px; font-family: sans-serif; font-size: 1em; color: #333
    }
    .quarter {
        width: 24.5%;
    }
    .half {
        width: 49.5%;
    }
    .third {
        width: 33.3%;
    }
    .fifth {
        width: 19.5%
    }
    .full {
        width: 99.5%
    }
    .threequarters {
        width: 74.5%
    }
    #new-event-details-form input, #new-event-details-form select {
        width: 95%; background-color: lightcyan; padding: 2px; border: 1px solid silver
    }
</style>
<div style="font-size: 1.5em; padding-bottom: 5px; margin-bottom: 5px; border-bottom: 1px solid #333">Event <b>#{$event_id}</b> Details</div>
<form name="new-event-details-form" id="new-event-details-form" onsubmit="return false" nohref>
    <input type="hidden" name="event_id" id="scheduler_event_id" value="{$event_id}"
    <div class="scheduler-row">
        <div class="scheduler-field-cell fifth">
            <div class="scheduler-field-header">
                Client
            </div>
            <div class="scheduler-field-value">
                <select name="client_id" id="client_id">
                    <option value="">Choose from below</option>
                    {foreach from=$clients->fetch() item=client} 
                        <option value="{$client.id}">{$client.client}</option>
                    {/foreach}
                </select>
            </div>        
        </div>    
        <div class="scheduler-field-cell" style="width: 29.5%">
            <div class="scheduler-field-header">
                IPA
            </div>
            <div class="scheduler-field-value">
                <select name="ipa_id" id="ipa_id">
                    <option value=""></option>
                </select>
                <input type="text" name="ipa_id_combo" id="ipa_id_combo" placeholder="IPA Name" value="" />            
            </div>        
        </div>
        <div class="scheduler-field-cell fifth">
            <div class="scheduler-field-header">
                Event Type
            </div>
            <div class="scheduler-field-value">
                <select name="event_type" id="event_type">
                    <option value=""></option>
                    <option value="local">Local</option>
                    <option value="remote">Remote</option>
                </select>
            </div>        
        </div>    
        <div class="scheduler-field-cell" style="width: 29%">
            <div class="scheduler-field-header">
                Event Starts/Event Ends
            </div>
            <div class="scheduler-field-value">
                <input type="text" readonly="readonly" value="{$details.start_date|date_format:"m/d/Y"} @ {$details.start_time|date_format:"H:i"} / {$details.end_date|date_format:"m/d/Y"} @ {$details.end_time|date_format:"H:i"}" />
            </div>        
        </div>                    
    </div>
    <div class="scheduler-row">
        <div class="scheduler-field-cell half">
            <div class="scheduler-field-header">
                Business Name
            </div>
            <div class="scheduler-field-value">
                <select name="location_id" id="location_id" >
                    <option value=""></option>
                </select>
            </div>
            <input type="text" name="location_id_combo" id="location_id_combo" value="" />            
        </div>    
        <div class="scheduler-field-cell half">
            <div class="scheduler-field-header">
                Address
            </div>
            <div class="scheduler-field-value">
                <select name="address_id" id="address_id" >
                    <option value="">Choose from below or type a new location into this box </option>
                </select>
                <input type="text" name="address_id_combo" id="address_id_combo" placeholder="Street Address, City, State, ZIP" value="" />
            </div>        
        </div>   
    </div>            
    <div class="scheduler-row">
        <div class="scheduler-field-cell quarter">
            <div class="scheduler-field-header">
                Contact Name
            </div>
            <div class="scheduler-field-value">
                <input type="text" name="contact_name" id="contact_name"   />
            </div>        
        </div>    
        <div class="scheduler-field-cell quarter">
            <div class="scheduler-field-header">
                Contact E-Mail
            </div>
            <div class="scheduler-field-value">
                <input type="text" name="contact_email" id="contact_email"   />
            </div>        
        </div>   
        <div class="scheduler-field-cell quarter">
            <div class="scheduler-field-header">
                Contact Phone
            </div>
            <div class="scheduler-field-value">
                <input type="text" name="contact_phone" id="contact_phone"  />
            </div>        
        </div>   
        <div class="scheduler-field-cell quarter">
            <div class="scheduler-field-header">
                Location NPI
            </div>
            <div class="scheduler-field-value">
                <select name="npi_id" id="npi_id" >
                    <option value="">Choose from below or type enter a new NPI </option>
                </select>
                <input type="text" name="npi_id_combo" id="npi_id_combo" placeholder="##########" value="" />
            </div>        
        </div>           
    </div>
            
    <div class="scheduler-row">
        <div class="scheduler-field-cell full">
            <div class="scheduler-field-header">
                Members
            </div>
            <div class="scheduler-field-value">
                <div id="new-event-member-list" style="background-color: lightcyan; overflow: auto; height: 120px; border: 1px solid silver">
                    <table cellspacing="1" cellpadding="2" style="width: 100%">
                        <tr>
                            <th>Name</th>
                            <th>Member ID</th>
                            <th>Address</th>
                            <th>Date Of Birth</th>
                            <th>HBA1C</th>
                            <th>HBA1C Date</th>
                            <th>FBS</th>
                            <th>FBS Date</th>
                        </tr>
                    {foreach from=$members->setEventId($event_id)->eventParticipants() item=member}
                        <tr style="background-color: rgba(155,155,155,{cycle values=".2,.35"})">
                            <td>{$member.last_name}, {$member.first_name}</td>
                            <td>{$member.member_number}</td>
                            <td>{if isset($member.address)} {$member.address}, {$member.city}, {$member.state}, {$member.zip_code} {else} {/if}</td>
                            <td>{if isset($member.date_of_birth)} {$member.date_of_birth|date_format:"m/d/Y"}{else} {/if} </td>
                            <td>{if isset($member.hba1c)} {$member.hba1c} {else} {/if}</td>
                            <td>{if isset($member.hba1c_date)} {$member.hba1c_date|date_format:"m/d/Y"} {else} {/if}</td>
                            <td>{if isset($member.fbs)} {$member.fbs} {else} {/if}</td>
                            <td>{if isset($member.fbs_date)} {$member.fbs_date|date_format:"m/d/Y"} {else}  {/if}</td>
                        </tr>    
                    {/foreach}
                    </table>                    
                </div>
                <div style="float: right; width: 45%; text-align: left" class="scheduler-field-header">Test Format Event Schedule</div>
                <div style="display: inline-block;" class="scheduler-field-header">Event Schedule</div>
                <div style="clear: both"></div>
                <input type="file" name="event_schedule" id="event_schedule" value="Test Schedule" style="width: 45%; float: right"/>
                <input type="file" name="event_member_list" id="event_member_list" value="Upload Member List" style="width: 45%;"/>
            </div>        
        </div>    
    </div>
    <div class="scheduler-row">
        <div class="scheduler-field-cell full">
            <div class="scheduler-field-header">
                Comments
            </div>
            <div class="scheduler-field-value">
                <textarea id="new_event_comment" name="new_event_comment" style="background-color: lightcyan; overflow: auto; height: 80px; width: 100%; border: 1px solid silver"></textarea>
            </div>        
        </div>    
    </div>              
    <div class="scheduler-row" style="margin-bottom: 50px">
        <div class="scheduler-field-cell full">
            <button name="new_event_confirm_button" id="new_event_confirm_button" onclick="return false" style="float: right; margin-right: 5px" > Confirm Event </button>
            <button name="new_event_cancel_button" id="new_event_cancel_button" onclick="return false" style=" margin-left: 20px"> Cancel Event </button>
            <div style="clear: both"></div>
        </div>    
    </div>              
    
</form>
<script type="text/javascript">
    $('#event_schedule').on('change',function (evt) {
        (new EasyAjax('/vision/schedule/test')).addFiles('schedule',$E('event_schedule')).then(function (response) {
            alert(response);
        }).post();
    });
    $('#new_event_confirm_button').on('click',function () {
        if (Edits['new-vision-screening-event'].validate()) {
            var win = Desktop.whoami('new-event-details-form');
            Desktop.window.list[win].splashScreen(Humble.template('vision/EventCreateWait'));            
            (new EasyAjax('/scheduler/event/confirm')).add('event_id',$('#scheduler_event_id').val()).then(function (response) {
                var win_id = Desktop.whoami($E('new-event-details-form'));
                Desktop.window.list[win].splashScreen(false);
                Desktop.window.list[win_id]._close();
            }).post();
        }
    });
    $('#new-event-details-form').on('change',function (evt) {
        if (evt.target.id === 'screening_location_combo') {
            if ($('#address_id_combo').val().split(',').length !== 4) {
                alert('Please enter the address in the comma delimited form of\n\nStreet Address, City, State, Zipcode');
            } else {
                (new EasyAjax('/scheduler/event/save')).add('id','{$event_id}').add('screening_location',$(evt.target).val()).add(evt.target.id,$(evt.target).val()).then(function (response) {
                }).post();                    
            }
        } else if (evt.target.id === 'event_member_list') {
            var win = Desktop.whoami('new-event-details-form');
            Desktop.window.list[win].splashScreen(Humble.template('vision/MemberUploadWait'));
            (new EasyAjax('/vision/events/upload')).add('client_id',$('#client_id').val()).addFiles('member_list',$E('event_member_list')).add('event_id',$('#scheduler_event_id').val()).then(function (response) {
                $('#new-event-member-list').html(response);
                Desktop.window.list[win].splashScreen(false);
            }).post();
        } else {
            (new EasyAjax('/scheduler/event/save')).add('id','{$event_id}').add(evt.target.name,$(evt.target).val()).then(function (response) {
            }).post();
        }
    });
    (function () {
        var xx = new EasyEdits('/edits/vision/screening','new-vision-screening-event');
        var win_id = Desktop.whoami($E('new-event-details-form'));
        if (win_id) {
            Desktop.window.list[win_id].resize = function () {
                EasyEdits.resetCombos(xx);
            }
        }
    })();
    {foreach from=$details item=value key=field}
        {assign var=value value=$value|regex_replace:"/[\n]/": "\\n"}
        {assign var=value value=$value|regex_replace:'/["]/':'\"'}
        Argus.tools.value.set('new-event-details-form','{$field}','{$field}',"{$value}");
    {/foreach}
</script>
                