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
    .full_width {
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
    .call_attempted {
    }
</style>
{assign var=call_id value=$call->save()}
{assign var=contacts value=$contact->details()}
{assign var=first value=true}
<form name='hedis-contact-form' id='hedis-contact-form-{$window_id}'>    
    <input type="hidden" name="status_save" id="status_save-{$window_id}" value="" />
    <div class='consultation_form'>
    {foreach from=$contacts item=participant}
        {if ($first)}
            <input type="hidden" name="status" id="status-{$window_id}" value="{$participant.status}" />
        <fieldset><legend title="Contact ID: {$participant.contact_id}">Location Information</legend>
            <input type='hidden' name='contact_id' id='contact_id-{$window_id}' value='{$participant.contact_id}' />
            <input type='hidden' name='campaign_id' id='campaign_id-{$window_id}' value='{$participant.campaign_id}' />
            <input type='hidden' name='call_id' id='call_id-{$window_id}' value='{$call_id}' />
            <div class='nc_row'>

                <div class='nc_cell' style='width: 40%'>
                    <div class='nc_desc'>
                        Address
                    </div>
                    <div class='nc_field'>
                        {$participant.address}
                    </div>
                </div>
                <div class='nc_cell'  style='width: 19%'>
                    <div class='nc_desc'>
                        City
                    </div>
                    <div class='nc_field'>
                        {$participant.city}
                    </div>
                </div>
                <div class='nc_cell'  style='width: 19%'>
                    <div class='nc_desc'>
                        State
                    </div>
                    <div class='nc_field'>
                        {$participant.state}
                    </div>
                </div>  
                <div class='nc_cell'  style='width: 19%'>
                    <div class='nc_desc'>
                        ZIP Code
                    </div>
                    <div class='nc_field'>
                       &nbsp; {$participant.zip_code}
                    </div>
                </div> 

            </div>
               
            <div class='nc_row'>
                <div class='nc_cell' style='width: 19%'>
                    <div class='nc_desc'>
                        Call Attempted [Time]
                    </div>
                    <div class='nc_field'>
                        <input type='checkbox' name='call_attempted' id='call_attempted-{$window_id}' value='Y'  />
                        <input type='hidden' name='time_of_call' id='time_of_call-{$window_id}' value='{$smarty.now|date_format:"%I:%M %p"}' />
                        [{$smarty.now|date_format:"%I:%M %p"}]
                    </div>
                </div>     
                <div class='nc_cell ' style='width: 19%;'>
                    <div class='nc_desc'>
                        Phone Number
                    </div>
                    <div class='nc_field'>
                        <b>{$participant.phone_number}</b>&nbsp;
                    </div>
                </div>                       
                <div class='nc_cell' style='width: 19%'>
                    <div class='nc_desc'>
                        Working Number
                    </div>
                    <div class='nc_field'>
                        <input type='radio' disabled='true' value='Y' name='working_number' id='working_number_yes-{$window_id}' {if ($participant.working_number =='Y')}checked="true"{/if} /> Yes
                        <input type='radio' disabled='true' value='N' name='working_number' id='working_number_no-{$window_id}' {if ($participant.working_number =='N')}checked="true"{/if} /> No
                    </div>
                </div>                  
                <div class='nc_cell'  style='width: 19%'>
                    <div class='nc_desc'>
                        Wrong Number
                    </div>
                    <div class='nc_field'>
                        <input type='radio' disabled='true' value='Y' name='wrong_number' id='wrong_number_yes-{$window_id}' {if ($participant.wrong_number =='Y')}checked="true"{/if} /> Yes
                        <input type='radio' disabled='true' value='N' name='wrong_number' id='wrong_number_no-{$window_id}' {if ($participant.wrong_number =='N')}checked="true"{/if}  /> No
                    </div>
                </div>    
                <div class='nc_cell'  style='width: 19%'>
                    <div class='nc_desc'>
                        Left Message
                    </div>
                    <div class='nc_field'>
                        <input type='radio' disabled='true' value='Y' name='left_message' id='left_message_yes-{$window_id}' {if ($participant.left_message =='Y')}checked="true"{/if} /> Yes
                        <input type='radio' disabled='true' value='N' name='left_message' id='left_message_no-{$window_id}' {if ($participant.left_message =='N')}checked="true"{/if} /> No
                        <input type='radio' disabled='true' value=''  name='left_message' id='left_message_na-{$window_id}' {if ($participant.working_number =='')}checked="true"{/if} /> N/A
                    </div>
                </div>   
        </fieldset>
        <br /><br />
    
        {assign var=warning value=false}
        <fieldset><legend>Member Information </legend>
            <div id="contact_warning_{$contact->getId()}" style="color: red; display: none; font-size: 1.3em">One or more members have been found in an earlier campaign.  Please carefully review the data to see if contacting them is still necessary</div>
            {/if}
            {assign var=mem value=$participant.member_id}
            {assign var=eligibility value=$elig->setMemberId($mem)->getPrestigeEligibilityStatus()|json_decode}
            {if ($participant.results_campaign_id && ($participant.results_campaign_id != $campaign_id))}
                {assign var=warning value=true}
            {/if}
            {assign var=eligible value=true}
            {if ($eligibility)}
                {assign var=eligible value=$eligibility->active}
            {/if}
            {*  I HAVE REVERSED THE ELIGIBILITY CALL TO MAKE EVERYONE ELIGIBLE, CHANGE BELOW WHEN THE CALL IS WORKING AGAIN *}
            <div class="nc_row" style="background-color: rgba({if (!$eligible)}255,189,189,.4{else}202,202,202,.2{/if}); margin-bottom: 10px; padding-top: 4px">
                <div style="min-width: 900px; width: 80%; clear: both;">
                    {$participant.first_name} {$participant.last_name} <div style="float: right">{if ($eligible && (isset($eligibility->effective_start_date)))}Eligible: [{$eligibility->effective_start_date|date_format:"m/d/Y"} - {$eligibility->effective_end_date|date_format:"m/d/Y"}]{else}<b><i>Eligibility Unknown</i></b>{/if}</div>
                </div>
                <div class='nc_cell ' style='width: 10%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Member ID
                    </div>
                    <div class='nc_field'>
                        {$participant.member_id}<br />
                        
                    </div>
                </div>
                <div class='nc_cell' style='width: 10%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Phone Number
                    </div>
                    <div class='nc_field'>
                        <b>{$participant.phone_number}</b>&nbsp;
                    </div>
                </div>                    
                <div class='nc_cell' style='width: 10%; margin-right: .1%'>
                    <div class='nc_desc'>
                        DOB
                    </div>
                    <div class='nc_field'>
                        {$participant.date_of_birth|date_format:"%m/%d/%Y"}
                    </div>
                </div>
                <div class='nc_cell' style='width: 4%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Age
                    </div>
                    <div class='nc_field'>
                        {$date->age($participant.date_of_birth)}
                    </div>
                </div>      
                <div class='nc_cell' style='width: 13%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Counseling Completed
                    </div>
                    <div class='nc_field'>
                        <input type='radio' disabled='true' value='Y' name='counseling_completed_{$participant.member_id}' {if ($participant.counseling_completed =='Y')}checked="true"{/if} id='counseling_completed_yes-{$window_id}_{$participant.member_id}' /> Yes
                        <input type='radio' disabled='true' value='N' name='counseling_completed_{$participant.member_id}' {if ($participant.counseling_completed =='N')}checked="true"{/if} id='counseling_completed_no-{$window_id}_{$participant.member_id}'  /> No
                        <input type='radio' disabled='true' value='' name='counseling_completed_{$participant.member_id}' {if ($participant.counseling_completed =='')}checked="true"{/if} id='counseling_completed_na-{$window_id}_{$participant.member_id}' /> N/A
                    </div>
                </div>                      
                <div class='nc_cell' style='width: 13%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Appointment Requested
                    </div>
                    <div class='nc_field'>
                        <input type='radio' disabled='true' value='Y' name='appt_requested_{$participant.member_id}' {if ($participant.requested_appointment =='Y')}checked="true"{/if} id='appt_requested_yes-{$window_id}_{$participant.member_id}' /> Yes
                        <input type='radio' disabled='true' value='N' name='appt_requested_{$participant.member_id}' {if ($participant.requested_appointment =='N')}checked="true"{/if} id='appt_requested_no-{$window_id}_{$participant.member_id}'  /> No
                        <input type='radio' disabled='true' value=''  name='appt_requested_{$participant.member_id}' {if ($participant.requested_appointment =='')}checked="true"{/if} id='appt_requested_na-{$window_id}_{$participant.member_id}'  /> N/A
                    </div>
                </div>  
                <div class='nc_cell' style='width: 13%; margin-right: .1%'>
                    <div class='nc_desc'>
                        Yearly Dental Visit?
                    </div>
                    <div class='nc_field'>
                        <input type='radio' disabled='true' value='Y' name='yearly_dental_visit_{$participant.member_id}' {if ($participant.yearly_dental_visit =='Y')}checked="true"{/if} id='yearly_dental_visit_yes-{$window_id}_{$participant.member_id}' /> Yes
                        <input type='radio' disabled='true' value='N' name='yearly_dental_visit_{$participant.member_id}' {if ($participant.yearly_dental_visit =='N')}checked="true"{/if} id='yearly_dental_visit_no-{$window_id}_{$participant.member_id}'  /> No
                        <input type='radio' disabled='true' value=''  name='yearly_dental_visit_{$participant.member_id}' {if ($participant.yearly_dental_visit =='')}checked="true"{/if} id='yearly_dental_visit_na-{$window_id}_{$participant.member_id}'  /> N/A
                    </div>
                </div>  
            </div>        
            {assign var=first value=false}
        {/foreach}
        </fieldset>
        <br />
            
        <fieldset><legend>Contact Status</legend>
            <div style="position: relative; width: 600px; margin-left: auto; margin-right: auto;">
                <div id="contact-status-{$window_id}">

                </div>
            </div>            
        </fieldset>
        <br /><br />
        <fieldset><legend>Additional Comments</legend>
            <div class='nc_row'>
                <div class='nc_cell full_width'>
                    <div class='nc_field'>
                        <textarea name='additional_comments' id='additional_comments-{$window_id}' style='width: 100%; height: 80px; background-color: lightcyan'></textarea>
                    </div>
                </div>        
            </div>        
        </fieldset>

        <div class='nc_row'>
            <div style='float: right; margin-right: 5px'>
                <input type='submit' value="Log Call Activity"  name='log-activity-button' id="log-activity-button-{$window_id}"/>
            </div>
        </div>
    
    </div>
    <br />
    <fieldset><legend>Comment Log</legend>
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
    <br /><br /><br />
</form>
<script type="text/javascript">
    {if ($warning)}
        $('#contact_warning_{$contact->getId()}').css('display','block');
    {/if}
    $('#call_attempted-{$window_id}').on('click',function (evt) {
        var form    = $E('hedis-contact-form-{$window_id}');
        var status  = evt.target.checked;
        $('.call_attempted').attr('disabled',!status);
        for (var i=0; i<form.elements.length; i++) {
            if (form.elements[i].type && (form.elements[i].type == 'radio')) {
                form.elements[i].disabled = !status;
            }
        }
        if (status) {
            (new EasyAjax('/dental/hedis/increment')).add('id','{$participant.contact_id}').add('call_id','{$call_id}').then(function (response) {
            }).post();
        }
    });
    Desktop.window.list['{$window_id}']._scroll(true);
    var slider = new Slider('contact-status-{$window_id}',600,16,"contact-status-slider-{$window_id}");
    slider.setInclusive(true);
    slider.addStop("cs100-{$window_id}","Open","A");
    slider.addStop("cs200-{$window_id}","Returned","R");
    slider.addStop("cs300-{$window_id}","On-Hold","H");
    slider.addStop("cs400-{$window_id}","Do Not Call",'D');
    slider.addStop("cs500-{$window_id}","Completed",'C');
    slider.setOnSlideStart(function (slider,slide,fromLeft) {
        var amt = Sliders[slide.id].getValue();
        if (amt) {
            $('#status_save-{$window_id}').val(amt);
        }        
    });
    slider.setOnSlide(function (slider,slide,fromLeft) {
        if (fromLeft <= 75) {
            slide.style.backgroundColor="#d0d0d0";
        } else if (fromLeft <= 225) {
            slide.style.backgroundColor="black";
        } else if (fromLeft <= 375) {
            slide.style.backgroundColor="blue";
        } else if (fromLeft <= 525) {
            slide.style.backgroundColor="red";
        } else {
            slide.style.backgroundColor="green";
        }            
    });
    slider.setOnSlideStop(function (slider,slide,fromLeft) {
        var amt = Sliders[slide.id].getValue();
        if (amt==='C') {
            if (!confirm("Are you sure you want to close this contact?")) {
                return false;
            }
        }
        if (amt) {
            $('#status-{$window_id}').val(amt);
        }
    });
    slider.setSlideRanges(true).setRangeDirection("right");
    slider.setSlideClass("contact-slider");
    slider.addPointer("cs_arrow-{$window_id}","/images/dental/slider3.png",'','contact-slider-pointer');
    slider.setLabelClass('contact-slider-stop');
    slider.setSnap(true);
    slider.render();    
    slider.setSliderToValue('{$participant.status}');
    //Form.intercept(Form Reference,MongoDB ID,optional URL or just FALSE,Dynamic WindowID to Close After Saving);
    Form.intercept($('#hedis-contact-form-{$window_id}').get(),false,'/dental/hedis/update',"{$window_id}",function (response) { Desktop.window.list['{$window_id}']._close(); });    
</script>
<style type="text/css">
    .contact-slider {
        background-color: #d0d0d0; border-radius: 3px; border: 1px solid #333
    }
    .contact-slider-stop {
        color: red; margin-top: 20px
    }
    .contact-slider-pointer {
        height: 20px;
    }
</style>