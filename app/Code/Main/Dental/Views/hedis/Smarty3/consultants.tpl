    <style type='text/css'>
        .cons_row {
            overflow: hidden; white-space: nowrap; min-width: 800px; position: relative; 
        }
        .cons_cell {
            display: inline-block; height: 50px; margin-right: 1px; margin-bottom: 1px; vertical-align: bottom
        }
        .cons_field_desc {
            font-family: monospace; font-size: .8em; height: 25px
        }
        .cons_field {
            padding-left: 15px; font-family: sans-serif; font-size: 1em; 
        }
        .cons_text {
           color: #333;  background-color: lightcyan; border: 1px solid #aaf; padding: 2px; border-radius: 2px; width: 45px; text-align: center; font-family: courier new, serif; font-size: .9em
        }
    </style>
    {assign var=campaign_id value=$campaigns->getId()}
    {assign var=total_contacts value=$contacts->campaignUnassignedContacts()}
    <div id="configuration-top" style="position: relative">
        <hr style='opacity: .4' />
        <div style="float: right; font-size: .9em;"><span style="cursor: pointer" onclick="Argus.dashboard.home()">home</span> | <span onclick="Argus.help.home()" style="cursor: pointer">help</span></div><span style='font-size: 1.2em; '><i style="font-size: 1.4em; margin-right: 5px" class="glyphicons glyphicons-family"></i> HEDIS ASSIGNMENTS - {$campaigns->getCampaign()}</span> 
        <hr style='opacity: .4' />
        <form name="consultant-assignments-form" id="consultant-assignments-form"  >
            <input type='hidden' name='campaign_id' id='campaign_id' value='{$campaign_id}' />
        <table width="100%">
            <tr>
                <td>Number of Consultants: <input readonly='readonly' class='cons_text' type="text" name="number_of_consultants" id="number_of_consultants" value='0'/></td>
                <td>Active Consultants: <input readonly='readonly' class='cons_text' type="text" name="active_consultants" id="active_consultants" value='0'/></td>
                <td>Contacts to Assign: 
                    <input class='cons_text' type="text" name="number_of_contacts" id="number_of_contacts"  value='{$total_contacts}' />/<b>{$total_contacts}</b>
                </td>
                <td>Accomodated: <input readonly='readonly' class='cons_text' type="text" name="contacts_accomodated" id="contacts_accomodated"  value='0' /></td>
                <td>Contacts/Consultant: <input class='cons_text' type="text" name="contacts_per_consultant" id="contacts_per_consultant" value='0' /></td>
                <td align='center'>
                    
                    <input type='button' class='blueButton' value='Distribute Evenly' style='text-align: center; visibility: hidden; padding: 3px 0px; font-size: 1.1em' id='even_distribution_button' />
                    <table id="working-spinner" style="float: left; display:none"><tr><td><img src="/images/argus/spinner.gif" height="35" style="float: left" /></td><td>&nbsp;<i><b>Working...</b></i></td></tr></table>                    
                    <input type='submit' class='blueButton' value='Assign Calls' style='text-align: center; width: 150px; padding: 3px 0px; font-size: 1.1em' id='assignment_button' />
                    
                </td>
            </tr>
        </table>
        <div style='clear: both'></div>
        {assign var=consultant_ctr value=0}
        <hr style='opacity: .4' />
        {assign var=workloads value=$contacts->HEDISWorkloads()}
        <div style="background-color: rgba(202,202,202,.5" class='cons_row'>
            <div class="cons_field">
                <input type="checkbox" id="global-hygenist-select" name="global-hygenist-select" checked="checked" /> Toggle to select/deselect all Hygenists
            </div>
        </div>
        {foreach from=$hygenists->getUsersByRoleName() item=hygenist}
            {assign var=consultant_ctr value=$consultant_ctr+1}
            <input type='hidden' name='hygenist-{$consultant_ctr}' value='{$hygenist.user_id}' />
            <div style="background-color: rgba(202,202,202,{cycle values=".2,.4"})" class='cons_row'>
                <div class="cons_cell" style='min-width: 150px'>
                    <div class="cons_field_desc">
                        <img src="/images/dental/return2.png" onclick="Argus.dental.hedis.hygenist.returnContacts('{$campaign_id}','{$hygenist.user_id}','{$hygenist.first_name} {$hygenist.last_name}')" style="float: right; cursor: pointer; margin-right: 5px; height: 20px"/>
                        Active Status
                    </div>
                    <div class="cons_field">
                        <input type="checkbox" name="consultant_{$hygenist.user_id}" id="hedis_consultant_{$consultant_ctr}" value="Y" checked="true" />
                    </div>
                </div>
              
                <div class="cons_cell" style="width: 55px; height: 55px; position: relative; overflow: hidden;  ">
                   {assign var=avatar value='../images/argus/avatars/'|cat:$hygenist.user_id|cat:'.jpg'}
                   {if ($file->exists($avatar))}
                        <img src="/images/argus/avatars/{$hygenist.user_id}.jpg" style=" vertical-align: middle; " onload="  Argus.tools.image.align(this)"/>
                    {else}
                        <img src="/images/argus/placeholder-{$hygenist.gender}.png" style=" vertical-align: middle " onload=" Argus.tools.image.align(this)"/>
                    {/if}
                </div>
                <div class="cons_cell" style='min-width: 150px'>
                    <div class="cons_field_desc">
                        Last name
                    </div>
                    <div class="cons_field">
                        {$hygenist.last_name}
                    </div>
                </div>
                <div class="cons_cell" style='min-width: 150px'>
                    <div class="cons_field_desc">
                        First Name
                    </div>
                    <div class="cons_field">
                        {$hygenist.first_name}
                    </div>
                </div>
                <div class="cons_cell" style='min-width: 150px'>
                    <div class="cons_field_desc">
                        Committed
                    </div>
                    <div class="cons_field">
                       
                        <input class="cons_text" onchange="Argus.dental.hedis.hygenist.commitment('{$hygenist.user_id}',this)" type="text" name="hours_committed" id="hours_committed-{$hygenist.user_id}" value="{if (isset($hygenist.hours_committed))} {$hygenist.hours_committed} {else} 0 {/if}" />
                         Hours
                    </div>
                </div> 
                <div class="cons_cell" style='min-width: 100px'>
                    <div class="cons_field_desc">
                        Workload
                    </div>
                    <div class="cons_field">
                        <div id="hygenist_{$hygenist.user_id}_workload_indicator" style="float: left; margin-right: 5px; padding: 5px; border-radius: 5px; background-color: white"></div>
                        &nbsp;
                    </div>
                </div>                            
                <div class="cons_cell" style='min-width: 150px'>
                    <div class="cons_field_desc">
                        Current Assignment
                    </div>
                    <div class="cons_field">
                    
                                <input class='cons_text' type="text" name="hygenist_contacts_{$hygenist.user_id}" id="consultant_contacts_{$consultant_ctr}" value="0" style="" />
                                <b> /{if (isset($workloads[$hygenist.user_id]))}
                                    {$workloads[$hygenist.user_id]}
                                {else}
                                    0
                                    {/if}</b>
                    </div>
                </div>
                <div class="cons_cell" style='min-width: 150px'>
                    <div class="cons_field_desc">
                        Languages
                    </div>
                    <div class="cons_field" style="white-space: nowrap">
                        <input type="checkbox" {if (isset($hygenist.english) && ($hygenist.english == 'Y'))}checked="checked"{/if} name="english" id="language_english_{$hygenist.user_id}" value="Y" onclick="Argus.dental.hedis.hygenist.language('{$hygenist.user_id}',this)" /> English &nbsp;&nbsp;
                        <input type="checkbox" {if (isset($hygenist.spanish) && ($hygenist.spanish == 'Y'))}checked="checked"{/if} name="spanish" id="language_spanish_{$hygenist.user_id}" value="Y" onclick="Argus.dental.hedis.hygenist.language('{$hygenist.user_id}',this)" /> Spanish &nbsp;&nbsp;
                        <input type="checkbox" {if (isset($hygenist.french) && ($hygenist.french == 'Y'))}checked="checked"{/if} name="french" id="language_french_{$hygenist.user_id}" value="Y" onclick="Argus.dental.hedis.hygenist.language('{$hygenist.user_id}',this)" /> French &nbsp;&nbsp;
                        <input type="checkbox" {if (isset($hygenist.german) && ($hygenist.german == 'Y'))}checked="checked"{/if} name="german" id="language_german_{$hygenist.user_id}" value="Y" onclick="Argus.dental.hedis.hygenist.language('{$hygenist.user_id}',this)" /> German &nbsp;&nbsp;
                        <input type="checkbox" {if (isset($hygenist.german) && ($hygenist.german == 'Y'))}checked="checked"{/if} name="portuguese" id="language_portuguese_{$hygenist.user_id}" value="Y" onclick="Argus.dental.hedis.hygenist.language('{$hygenist.user_id}',this)" /> portuguese &nbsp;
                    </div>
                </div>                            
            </div>
        {/foreach}

        </form>
    </div>
    <script type="text/javascript">
        (function () {
            Argus.dental.hygenists = {$consultant_ctr};                         //First set number of consultants
            $('#number_of_consultants').val(Argus.dental.hygenists);                                                   
            $('#active_consultants').change(function (evt) {                                                //Recalculate calls per consultant when active consultants changeds
                if (+evt.target.value > 0) {
                    $('#contacts_per_consultant').val(Math.ceil(+$('#number_of_contacts').val() / evt.target.value));
                    $('#even_distribution_button').click();
                }
            });    
            $('#global-hygenist-select').on("click",function (e) {
                var status = e.target.checked;
                for (var i=1; i<=Argus.dental.hygenists; i++) {
                    $E('hedis_consultant_'+i).checked = status;
                }
                if (status) {
                    $('#active_consultants').val(Argus.dental.hygenists);
                } else {
                    $('#active_consultants').val(0);
                }
            });
            $('#active_consultants').val(Argus.dental.hygenists).change();                                             //Now trigger the number of active consultants change method
            for (var i=1; i<=Argus.dental.hygenists; i++) {                                                            //Register a handler for when someone clicks on the checkbox
                $('#hedis_consultant_'+i).on('click',function (evt) {
                    $('#active_consultants').val(
                        +$('#active_consultants').val() + (evt.target.checked ? 1 : -1)
                    ).change();
                });
            }
            for (var i=1; i<=Argus.dental.hygenists; i++) {                                                            //Register handlers that sum up the number of accomodated calls
                $('#consultant_contacts_'+i).change(function (evt) {
                    var tot = 0;
                    for (var j=1; j<=Argus.dental.hygenists; j++) {
                       tot += +$E('consultant_contacts_'+j).value;
                    }
                    $E('contacts_accomodated').value = tot;
                });
            }
            $('#number_of_contacts').on('change',function (evt) {
                if (+$('#active_consultants').val() > 0) {
                    $('#contacts_per_consultant').val(Math.ceil(+$('#number_of_contacts').val() / $('#active_consultants').val()));
                    $('#even_distribution_button').click();
                }
            });
            $('#even_distribution_button').on('click',function (evt) {
                var contacts_to_make = $('#contacts_per_consultant').val();
                for (var i=1; i<=Argus.dental.hygenists; i++) {
                    $('#consultant_contacts_'+i).val(0);                    
                }
                for (var i=1; i<=Argus.dental.hygenists; i++) {
                    if ($E('hedis_consultant_'+i).checked) {
                        $('#consultant_contacts_'+i).val(contacts_to_make).change();
                    }
                }
            });
            $('#even_distribution_button').click();
        })();
        $('#assignment_button').on('click',function () {
            $('#assignment_button').css('display','none');
            $('#working-spinner').fadeIn();
        });
        Form.intercept($('#consultant-assignments-form').get(),false,'/dental/hedis/assignments',false,function (response) { $('#container').html(response) } );
        </script>