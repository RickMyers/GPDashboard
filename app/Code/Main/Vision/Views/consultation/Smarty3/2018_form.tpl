
{assign var=doctor          value=$role->userHasRole('O.D.')}
{assign var=print           value=$form->getPrint()}
{assign var=pcp             value=$role->userHasRole('Primary Care Physician')}
{assign var=IPA             value=$role->userHasRole('IPA')}
{assign var=current_user    value=$role->getUserId()}
{assign var=hedis_manager   value=$role->userHasRole('HEDIS Manager')}
{assign var=pcp_staff       value=$role->userHasRole('PCP Staff')}
{assign var=tag             value=$form->getTag()}
{assign var=data            value=$form->reset()->setTag($tag)->load(true)}
{assign var=form_id         value=$data.id}
{assign var=form_type       value=$form->getFormType()}
{assign var=reviewer        value=$form->getReviewer()}
{assign var=status          value=$form->getStatus()}
{if (!$print)}
    {assign var=feedback        value=$form_feedback->reset()->setFormId($form_id)->load(true)}
{/if}
{if (!isset($window_id))}
    {assign var=window_id value=''}
{/if}

<style type="text/css">
    .block {
        display: inline-block; color: #333
    }
    .field-block {
        white-space: nowrap; margin-right: 2px; margin-bottom: 2px; display: inline-block; overflow: hidden; user-select: true
    }
    .form-field {
        background-color: #dfdfdf; border: 1px solid transparent; padding: 2px;  border-bottom-color: #999; width: 100%; text-transform: uppercase; user-select: true
    }
    .form-field:focus {
        background-color: lightcyan; border-bottom-color: #333; user-select: true
    }
    .diagnosis_codes_header {
        text-align: center; font-weight: bolder; text-decoration: underline
    }
    .diagnosis_codes_cell {
        overflow: hidden;; user-select: true
    }
    input[type=number]::-webkit-inner-spin-button, input[type=number]::-webkit-outer-spin-button { 
        -webkit-appearance: none; -moz-appearance: none; appearance: none; margin: 0; 
    }
    input[type=number] {
        -moz-appearance:textfield;
    }
   .numberremover {
        -moz-appearance:textfield; -webkit-appearance: none; -moz-appearance: none; appearance: none; margin: 0;     
    }
    .modal {
        text-align: center; display: none; position: absolute; z-index: 1; left: 0; top: 0; width: 100%; height: 100%; overflow: auto;    
    }
    .modal-content {
        font-size: 15px; font-weight: bold; text-align: center; background-color: #fefefe; margin: auto; padding: 20px; border: 1px solid #888; width: 80%; 
    }
    .close {
        color: #aaaaaa; float: right; font-size: 28px; font-weight: bold;
    }
    .close:hover,.close:focus {
        color: #000; text-decoration: none; cursor: pointer;
    }
    .modaltwo {
        text-align:center; display: none; position:absolute; z-index: 1; padding-top: 100px; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; 
    }
    .modaltwo-contenttwo {
        font-size:15px; font-weight: bold; text-align:center; background-color: #fefefe; margin: auto; padding: 20px; border: 1px solid #888; width: 80%; top: 100px;
    }
    .aligncenter{
        text-align: center;
    }
    .form-active {
        background-color: rgba(202,202,0,.2)
    }
    .form-row {
        display: block; overflow: hidden; width: 100%; clear: both; white-space: nowrap
    }
    .form-cell {
        display: inline-block; margin-right: 1px; margin-bottom: 1px; width: 20%; background-color: rgba(202,202,202,.2); user-select: true
    }
    .form-cell-header {
        letter-spacing: 2px; font-family: monospace; font-size: .75em; user-select: true
    }
    .form-cell-field {
        padding-left: 10px; overflow: hidden; user-select: true
    }
    .lookups {
        display: none; float: left; margin-right: 3px
    }
    .form_text {
        text-transform: uppercase;
    }
</style>
{if (!$print)}
<div id='checkboxdata' style="position: relative; z-index: 3; display: none"></div>

<!-- ############################################################################### -->

<div id="checkmodal" class="modaltwo" style="display:none">
    <div class="modaltwo-contenttwo">
        <p>Are you sure you want to submit without a scan?</p>
        <input type="button" class="" style="" value="  NO  " onclick="closer('N')" />
        <input type="button" class="" style="" value="  YES  " onclick="closer('Y')" />
        <br />
    </div>
</div>

<!-- ############################################################################### -->

<div id="myModal" class="modal" style="position: absolute; top: 0px; left: 0px; width: 100%; height: 100%; z-index: 999; background-color: rgba(50,50,50,.2)">
    <table style="width: 100%; height: 100%">
        <tr>
            <td>
                <div class="modal-content">
                    <span id="closebtn" class="close">&times;</span>
                    <div id="ddselect">
                        <p>Please Select a value for</p>
                        <p id="thecbname"></p><!--the value of the checkbox -->
                        <br />
                        <select id="eyeselect" name="eyeselect">
                            <option value="" selected="true" disabled="true">Please Select A Value</option>
                            <option value="1">1 (OD/Right)</option>
                            <option value="2">2 (OS/Left)</option>
                            <option value="3">3 (OU/Both)</option>
                            <option value="9">9 (Unspecific)</option>
                      </select>
                    </div>
                </div>
            </td>
        </tr>
    </table>
</div>
                        
<!-- ############################################################################### -->

<div style="display: none; position: absolute; top: 0px; left: 0px; width: 100%; height: 100%; z-index: 999; background-color: rgba(50,50,50,.2)" id="form-comment-layer">
    <table style='width: 100%; height: 100%;'>
        <tr>
            <td style='background-color: rgba(77,77,77,.3)'>
                <div style='width: 500px; padding: 10px; border-radius: 10px; border: 1px solid #aaf; background-color: ghostwhite; margin-left: auto; margin-right: auto'>
                    <form name='comment-attach-form' id='comment-attach-form' onsubmit='return false'>
                        <fieldset style='padding: 10px'>
                            <legend>Instructions</legend>
                            Please add your comment below<br /><br />
                            <textarea id="vision_form_comments" placeholder='New Comment...' style='overflow-y: auto; overflow-x: hidden; width: 100%; height: 100px; background-color: lightcyan; border: 1px solid #aaf'></textarea>
                            <input type='button' value='Attach' style='float: right' id='comment_attach_button' onclick='this.style.visibility="hidden"; Argus.vision.comment.post("{$form_id}","{$window_id}")' />
                            <input type='button' value='Cancel' onclick="$('#form-comment-layer').css('display','none')" />
                        </fieldset>
                    </form>
                </div>
            </td>
        </tr>
    </table>
</div>   
                                
<!-- ############################################################################### -->

<div id="vision-form-tabs" style='padding-bottom: 4px; border-bottom: 1px solid #333; '></div>
{/if}
<!-- ############################################################################### -->

<div id="vision-package" style="overflow: scroll">
    {if (!$print)}
    <div id="vision-form-images-tab">
        <div style="display: none; position: absolute; top: 0px; left: 0px; width: 100%; height: 100%; z-index: 999; background-color: rgba(50,50,50,.2)" id="scan_upload_layer">
            <table style='width: 100%; height: 100%;'>
                <tr>
                    <td style='background-color: rgba(77,77,77,.3)'>
                        <div style='width: 500px; padding: 10px; border-radius: 10px; border: 1px solid #aaf; background-color: ghostwhite; margin-left: auto; margin-right: auto'>
                            <form name='vision-attach-scan-form' id='vision-attach-scan-form' onsubmit='return false'>
                                <fieldset style='padding: 10px'>
                                    <legend>Instructions</legend>
                                    Please use the file selection box below to select an image to attach to this form, and then click 'Attach', otherwise click 'Cancel' to close this window<br /><br />
                                    <input type='file' multiple="true" name='form-scan-image' id='form-scan-image' style='background-color: lightcyan; padding: 3px; border: 1px solid #aaf; border-radius: 3px; width: 300px' placeholder='Scanned Image' /><br /><br />
                                    <div id="upload-controls}">
                                        <input type='button' value='Attach' style='float: right' onclick='Argus.vision.scan.attach("{$form_id}","{$window_id}")' />
                                        <input type='button' value='Cancel' onclick="$('#scan_upload_layer').css('display','none')" />
                                    </div>
                                    <div id="upload-controls-spinner" style="display: none; font-size: 1.3em; text-align: center; font-style: italic; color: #333">
                                        <img src="/images/argus/inprogress.gif" height="40" align="middle" /> &nbsp;&nbsp; Uploading, please wait...
                                    </div>
                                </fieldset>
                            </form>
                        </div>
                    </td>
                </tr>
            </table>
        </div>    
        <div>
            <div style='clear: both'></div>
            <div style='height: 10px; background-color: #333;'></div>
            <div style='color: #333; font-size: 1.8em; padding-left: 10px' id="form-scan-patient-id"></div>
            <div style='height: 10px; background-color: #333;'></div>
            <div id='form-scan-list'></div>
            <div style='margin-top: 10px; padding-left: 10px'>
                <input type='button' id='add_scan_button' value='Add Scan' />
            </div>        
        </div>                            
    </div>
    {/if}
        
<!-- ############################################################################### -->

<div id="vision-form-tab" style="position: relative">
    <form name="new-retina-consultation-form" id="new-retina-consultation-form" onsubmit="return false">
        <input type="hidden" name="pcp_staff_signature" id="pcp_staff_signature" value="" />
        <input type="hidden" name="od_signature" id="od_signature1" value="" />
        <input type="hidden" name="od_signed_date" id="od_signed_date" value="" />
        <input type="hidden" name="od_signed_time" id="od_signed_time" value="" />
        <input type="hidden" name="active_diagnosis_code" id="active_diagnosis_code" value="" />
        <input type="hidden" name="form_locked" id="form_locked" value="Y" />
        
        <div style="width: 885px; padding-left: 5px; padding-right: 5px; margin-left: 10px;  border-right-style: solid; display: inline-block">
            <div style="width: 100%; border-right: 2px; border-right-color: #999;">
                <div style="padding-bottom: 3px; padding-top: 6px; background-color: rgba(202,202,202,1); font-size: 1.2em; color: #333;">
                    <div style="float: right; margin-right: 2px; white-space: nowrap; vertical-align: top">
                            <div id="refer_for_administration" onclick="Argus.vision.consultation.refer()" title="Refer for Administration" style="display: none; vertical-align: middle; cursor: pointer; border: 1px solid #0877BA; border-radius: 20px; margin-right: 8px; overflow: hidden">
                                <img src="/images/vision/refer_admin.png" style="height: 20px" />
                            </div>
                            <img id="return_referral" src="/images/vision/return_to.png" style="height: 22px; margin-right: 8px; display: none; cursor: pointer" onclick="Argus.vision.consultation.returnReferral()" title="Return form" />
                            Form #: {$form_id}<div style="display: inline-block" id="form-version-number"></div>
                    </div>
                    <img src="/images/vision/lock.png" onclick="Argus.vision.consultation.lock.toggle(this)" title="Lock/Unlock Fields" style="width: 14px; cursor: pointer; float: left; margin-right: 3px" /><b>Diabetic  <span id="form_type_label" value="Scanning"></span> Form</b>
                    <img src="/images/vision/print.png" onclick="Argus.vision.consultation.print('{$form_id}')" style="cursor: pointer; width: 18px" title="Print Form" />
                </div>
                <div id="header_section_1">                   
                    <div class="form-row">
                        <div class="form-cell" style="width: 10%">
                            <div class="form-cell-header">
                                <img src="/images/vision/member_lookup.png" class="lookups" style="height: 12px; cursor: pointer;" onclick=" Argus.vision.event.search()" /> Event ID
                            </div>
                            <div class="form-cell-field ">
                                <div class="form_input">
                                    <input type="text" class="form-field" style="font-weight: bold;" name="event_id" id="event_id"  />
                                </div>
                                <div class="form_text">
                                    {if isset($data.event_id)}{$data.event_id}{else}N/A{/if}
                                </div>
                            </div>
                        </div><div class="form-cell" style="width: 22%">
                            <div class="form-cell-header" style="">
                                Health Plan
                            </div>
                            <div class="form-cell-field ">
                                <div id="screening_client_select" class='form_input' style="display: none">{*if (($pcp_staff) || ($doctor) || ($hedis_manager))*}
                                    <select class="form-field" style="" name="client_id" id="client_id">
                                        <option value=""></option>
                                        {foreach from=$clients->fetch() item=client}
                                            <option value="{$client.id}">{$client.client}</option>
                                        {/foreach}
                                    </select>
                                </div>
                                <div id="screening_client_text" class='form_text' style="display: none">
                                    {if (isset($data.screening_client))}{$data.screening_client}{else}N/A{/if}
                                </div>
                            </div>
                        </div><div class="form-cell" style="width: 23%">
                            <div class="form-cell-header" style="">
                                IPA
                            </div>
                            <div class="form-cell-field ">
                                <div id="ipa_box_select" class='form_input' style="display: none">
                                    <select class="form-field" style="" name="ipa_id" id="ipa_id">
                                        <option value=""></option>
                                        <!-- Do something here with the IPA -->
                                    </select><input type="text" name="ipa_id_combo" id="ipa_id_combo" />
                                </div>
                                <div id="ipa_box_text" class='form_text' style="display: none">
                                    {if (isset($data.ipa_id_combo))}{$data.ipa_id_combo}{else}N/A{/if}
                                </div>                                
                            </div>
                        </div><div class="form-cell" style="width: 23%">
                            <div class="form-cell-header" style="">
                                Business Name
                            </div>
                            <div class="form-cell-field ">
                                <div id="location_id_input" class='form_input' style="display: none">
                                   <select class="form-field" style="" name="location_id" id="location_id">
                                        <option value=""></option>
                                    </select><input type="text" name="location_id_combo" id="location_id_combo" />                                    
                                </div>
                                <div id="location_id_text" class='form_text' style="display: none">
                                    {if (isset($data.location_id_combo))}{$data.location_id_combo}{else}N/A{/if}
                                </div>
                            </div>
                        </div><div class="form-cell" style="width: 22%">
                            <div class="form-cell-header" style="">
                                Form Type
                            </div>
                            <div class="form-cell-field ">
                                <div id="form_type_input" class='form_input' style="display: none">
                                    {$data.form_type|ucfirst}
                                   <div style="display: none"> <input type="radio" value="screening" readonly="readonly"  name="form_type" id="form_type_screening" /> Screening&nbsp;&nbsp;&nbsp;
                                       <input type="radio" checked="true" readonly="readonly"  value="scanning" name="form_type" id="form_type_scranning" /> Scanning</div>
                                </div>
                                <div id="form_type_text" class='form_text' style="display: none">
                                    {if (isset($data.form_type))}{$data.form_type|ucfirst}{else}N/A{/if}
                                </div>
                            </div>
                        </div>                            
                    </div>                            
                    <div class="form-row">
                        <div class="form-cell" style="width: 35%">
                            <div class="form-cell-header">
                                Member Name
                            </div>
                            <div class="form-cell-field ">
                                <div id="member_name_input" class='form_input' style="display: none">
                                    <input type="text" placeholder="Last, First" style="font-family: serif; text-transform: uppercase" class="form-field pcp_staff" name="member_name" id="member_name" />
                                </div>
                                <div id="member_name_text" class='form_text' style="display: none; font-family: serif; text-transform: uppercase; font-weight: bolder">
                                    {if (isset($data.member_name))}{$data.member_name}{else}N/A{/if}
                                </div>
                            </div>
                        </div><div class="form-cell" style="width: 15%">
                            <div class="form-cell-header" style="">
                                Member ID#
                            </div>
                            <div class="form-cell-field ">
                                <div id="member_id_input" class='form_input' style="display: none">
                                    <input type="text" style="font-family: serif; text-transform: uppercase" class="form-field pcp_staff" name="member_id" id="member_id" />
                                </div>
                                <div id="member_id_text" class='form_text' style="display: none; font-family: serif; text-transform: uppercase; font-weight: bolder">
                                    {if (isset($data.member_id))}{$data.member_id}{else}N/A{/if}
                                </div>
                            </div>
                        </div><div class="form-cell" style="width: 15%">
                            <div class="form-cell-header" style="padding-left: 5px">
                                DOB
                            </div>
                            <div class="form-cell-field ">
                                <div id="date_of_birth_input" class='form_input' style="display: none">
                                    <input type="text" class="form-field pcp_staff" style="" name="date_of_birth"    id="date_of_birth" placeholder="MM/DD/YYYY" />
                                </div>
                                <div id="date_of_birth_text" class='form_text' style="display: none">
                                    {if (isset($data.date_of_birth) && ($data.date_of_birth))}{$data.date_of_birth|date_format:'m/d/Y'}{else}N/A{/if}
                                </div>
                            </div>
                        </div><div class="form-cell" style="width: 15%">
                            <div class="form-cell-header" style="">
                                &nbsp;&nbsp;Gender
                            </div>
                            <div class="form-cell-field ">
                                <div id="gender_select" class='form_input' style="display: none">
                                    <select name="gender" id="gender" class="form-field pcp_staff" style="">
                                        <option value=""> </option>
                                        <option value="M"> Male </option>
                                        <option value="F"> Female </option>
                                    </select>
                                </div>
                                <div id="gender_text" class='form_text' style="display: none">
                                    {if (isset($data.gender))}{$data.gender}{else}N/A{/if}
                                </div>
                            </div>
                        </div><div class="form-cell" style="width: 20%">    
                            <div class="form-cell-header">
                                Age
                            </div>
                            <div class="form-cell-field " id="age" style="padding-left: 20px">
                                N/A
                            </div>
                        </div>
                    </div><div class="form-row">
                        <div class="form-cell" style="width: 35%">
                            <div class="form-cell-header" style="">
                                Member Address
                            </div>
                            <div class="form-cell-field ">
                                <div id="member_address_input" class='form_input' style="display: none">
                                    <input placeholder="Address Street, City, State, Zip" type="text" class="form-field pcp_staff"  name="member_address" id="member_address" />
                                </div>
                                <div id="member_address_text" class='form_text' style="display: none">
                                    {if (isset($data.member_address))}{$data.member_address}{else}N/A{/if}
                                </div>
                            </div>
                        </div><div class="form-cell" style="width: 35%">
                            <div class="form-cell-header" style="padding-left: 1px">
                                Primary Care Physician (PCP)
                            </div>
                            <div class="form-cell-field ">
                                <div id="primary_doctor_input" class='form_input' style="display: none">
                                    Dr. <select style="width: 90%" class="form-field pcp_staff"  name="primary_doctor" id="primary_doctor" ><option value=""> </option></select><input type="text" name="primary_doctor_combo" id="primary_doctor_combo" class="form-field pcp_staff" placeholder="Last, First" />
                                </div>
                                <div id="primary_doctor_text" class='form_text' style="display: none">
                                    {if (isset($data.primary_doctor_combo))}Dr. {$data.primary_doctor_combo}{else}N/A{/if}
                                </div>
                            </div>
                        </div><div class="form-cell" style="width: 30%">
                            <div class="form-cell-header" style="padding-left: 1px">
                                PCP NPI
                            </div>
                            <div class="form-cell-field ">
                                <div id="physician_npi_input" class='form_input' style="display: none">
                                    <select  class="form-field pcp_staff" style="width: 90%" name="physician_npi" id="physician_npi" ><option value=""></option></select><input type="text" name="physician_npi_combo" id="physician_npi_combo" class="form-field pcp_staff"  placeholder="NPI ###" />
                                </div>
                                <div id="physician_npi_text" class='form_text' style="display: none">
                                    {if (isset($data.physician_npi_combo))}{$data.physician_npi_combo}{else}N/A{/if}
                                </div>
                            </div>
                        </div>
                    </div><div class="form-row">
                        <div class="form-cell" style="width: 20%">
                            <div class="form-cell-header">
                                Event Date:
                            </div>
                            <div class="form-cell-field ">
                                <div id="event_date_input" class='form_input' style="display: none">
                                    <input placeholder="MM/DD/YYYY" type="text" class="form-field pcp_staff" name="event_date" id="event_date" />
                                </div>
                                <div id="event_date_text" class='form_text' style="display: none">
                                    {if (isset($data.event_date))}{$data.event_date|date_format:"m/d/Y"}{else}N/A{/if}
                                </div>
                            </div>
                        </div><div class="form-cell" style="width: 55%">
                            <div class="form-cell-header" style="">
                                Event Location:
                            </div>
                            <div class="form-cell-field ">
                                <div id="address_id_input" class='form_input' style="display: none">
                                    <select name="address_id" id="address_id" class="form-field pcp_staff">
                                        <option value=""></option>
                                    </select>
                                    <input placeholder="Address Street, City, State, Zip" type="text" class="form-field pcp_staff" name="address_id_combo" id="address_id_combo" />
                                </div>
                                <div id="address_id_text" class='form_text' style="display: none">
                                    {if (isset($data.address_id_combo))}
                                        {$data.address_id_combo}
                                    {else}
                                            N/A
                                    {/if}
                                </div>
                            </div>                            
                        </div><div class="form-cell" style="width: 25%">                                    
                            <div class="form-cell-header">
                                Event Location NPI#:
                            </div>
                            <div class="form-cell-field ">
                                <div id="npi_id_input" class='form_input' style="display: none">
                                    
                                    <select class="form-field pcp_staff" style="width: 90%" name="npi_id" id="npi_id" >
                                        <option value=''></option>
                                    </select>
                                    <input type="text" class="form-field pcp_staff" name="npi_id_combo" id="npi_id_combo" />
                                </div>
                                <div id="npi_id_text" class='form_text' style="display: none">
                                    {if (isset($data.npi_id_combo))}{$data.npi_id_combo}{else}N/A{/if}
                                </div>
                            </div>
                        </div>
                    </div>
                            
                </div>
                                
                <!-- ######################################################################################################################### -->
                
                <div style="background-color: rgba(202,202,202,.2); position: relative; padding: 10px; font-size: 1.2em; color: black;">
                    <b><u>Patient Understanding, Acknowledgement, and Consent</u>:</b>&nbsp;<span style="font-size: .9em">
                        This service is ONLY a screening for diabetic eye disease and is NOT a comprehensive eye examination.
                        It is strongly recommended that you contact your ECP (eye care professional) and 
                         schedule your annual routine/comprehensive eye exam to fully assess the health of your eyes and determine the need for glasses.</span>
                    <span id="additional_consent"> I consent to pupil dilation with drops by the optometrist (vision technicians do not dilate the pupils with drops).</span>
                        <div style="height: 5px"></div>
                        <u style="font-size: .9em"><b>THIS SCREENING DOES NOT USE YOUR ANNUAL BENEFIT FOR YOUR ROUTINE, COMPREHENSIVE EYE EXAMINATION</b></u>.
                </div>
                <div class="field-block" style="white-space: nowrap; overflow: hidden; float: right">
                    <div class="" style="float: right; margin-left: 10px; width: 200px; border-bottom: 1px solid #333" id="technician_signature">
                        &nbsp; <input type="button" value=" Preparer Sign " style="display: none;float: right; font-size: 1em;" id="preparer_sign_button" name="preparer_sign_button" />
                    </div>
                    <div class="block" style="padding-left: 10px" id="header_signature_field">
                    </div>
                </div>                   
                <div class="block" style="padding-left: 10px; font-size: 1.1em; color: black;">
                    <input type="checkbox" name="patient_agreement" id="patient_signature" value="Y" /> By checking this box, patient consents to this screening service
                </div>
                <!--/div-->
                <div style="width: 100%; border-bottom: 3px solid #333; margin-top: 5px; clear: both"></div>
                <div id="highlight_block_1" style="background-color: rgba(202,202,0,.2)">
                    <div style=" text-align: center; margin-bottom: 10px; margin-top: 10px; font-size: 1.1em; padding-top: 5px">
                        <b><u>ATTENTION PCP staff - Please confirm this section PRIOR to member screening</u></b>
                    </div>
                    <table style="width: 100%; border-collapse: separate; border: 2px solid ghostwhite">
                    <tr>
                        <td style="background-color: rgba(202,202,202,.2); width: 20%">
                            <div class="field-block">
                                <div class="block" style="padding-left: 20px">
                                    FBS
                                </div>
                                <div class="block">
                                    <input type="text" class="form-field pcp_staff" style="width: 65px" name="fbs" id="fbs" />
                                </div>
                            </div>
                        </td>
                        <td style="background-color: rgba(202,202,202,.2)">
                            <div class="field-block">
                                <div class="block">
                                    Date
                                </div>
                                <div class="block">
                                    <input type="text" class="form-field pcp_staff" style="width: 90px" name="fbs_date" id="fbs_date" placeholder="MM/DD/YYYY" />
                                </div>
                            </div>
                        </td>
                        <td colspan="2">
                            <table style="width: 95%; border-collapse: separate; border: 2px solid ghostwhite">
                                <tbody> 
                                    <tr>
                                        <td style="background-color: rgba(202,202,202,.2)">
                                            <div class="field-block">
                                                <div class="block">
                                                    <input type="radio" value='t1' style="" class="pcp_staff" name="type_dm" id="type_1diab" /> Type 1 DM
                                                </div>
                                            </div>
                                        </td>
                                        
                                        <td style="background-color: rgba(202,202,202,.2)">
                                            <div class="field-block">
                                                <div class="block">
                                                    <input type="radio" value='t2' style="" class="pcp_staff" name="type_dm" id="type_2diab" /> Type 2 DM
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                        <td colspan="3"> 
                            <table style="width: 95%; border-collapse: separate; border: 2px solid ghostwhite">
                                <tbody>
                                    <tr>
                                        <td style="background-color: rgba(202,202,202,.2)">
                                            <div class="field-block">
                                                <div class="block">
                                                    <input type="radio" value="controlled" class="pcp_staff" style="" name="dm_alltype" id="dm_alltype_controlled" /> Controlled
                                                </div>
                                            </div>
                                        </td>
                                        <td style="background-color: rgba(202,202,202,.2)">
                                            <div class="field-block">
                                                <div class="block">
                                                    <input type="radio" value="uncontrolled" class="pcp_staff" style="" name="dm_alltype" id="dm_alltype_uncontrolled" /> Uncontrolled
                                                </div>
                                            </div>
                                        </td>
                                        <td style="background-color: rgba(202,202,202,.2)">
                                            <div class="field-block">
                                                <div class="block">
                                                    <input type="radio" value="unknown" class="pcp_staff" style="" name="dm_alltype" id="dm_alltype_unknown" /> Unknown
                                                </div>
                                            </div>
                                        </td> 
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                        <td style="background-color: rgba(202,202,202,.2)">
                            <div class="field-block">
                                <div class="block">
                                    x
                                </div>
                                <div class="block">
                                    <input type="text" class="form-field pcp_staff numberremover" style="width: 40px" name="type_yrs" id="type_yrs" /> yrs
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" style="background-color: rgba(202,202,202,.2)"></td>
                    </tr>
                    <tr>
                        <td style="background-color: rgba(202,202,202,.2); width: 20%">
                            <div class="field-block">
                                <div class="block" style="padding-left: 5px">
                                    HbA1c
                                </div>
                                <div class="block">
                                    <input type="text" class="form-field pcp_staff" style="width: 65px" name="hba1c" id="hba1c" />
                                </div>
                            </div>
                        </td>
                        <td style="background-color: rgba(202,202,202,.2)">
                            <div class="field-block">
                                <div class="block">
                                    Date
                                </div>
                                <div class="block">
                                    <input type="text" class="form-field pcp_staff" style="width: 90px" name="hba1c_date" id="hba1c_date" placeholder="MM/DD/YYYY" />
                                </div>
                            </div>
                        </td>
                        <td colspan="3">
                            <table style="width: 95%; border-collapse: separate; border: 2px solid ghostwhite">
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="field-block">
                                                <div class="block">
                                                    <input type="checkbox" style="" class="pcp_staff block" name="type_oral" id="type_oral" /> Oral
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="field-block">
                                                <div class="block">
                                                    <input type="checkbox" style="" class="pcp_staff" name="type_injected" id="type_injected" /> Injected
                                                </div>
                                            </div>
                                        </td>                                        
                                        <td>
                                            <div class="field-block">
                                                <div class="block">
                                                    <input type="checkbox" style="" class="pcp_staff" name="type_diet" id="type_diet" /> Diet
                                                </div>
                                            </div>
                                        </td>  
                                        <td>                                        <td>
                                            <div class="field-block">
                                                <div class="block">
                                                    <input type="checkbox" style="" class="pcp_staff" name="type_insulin" id="type_insulin" /> Insulin
                                                </div>
                                            </div>
                                        </td>   
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                        <td>
                            <div class="field-block">
                                <div class="block">
                                    <div class="block">BMI:</div>
                                    <div class="block">
                                        <input type="text" class="form-field pcp_staff " style="width: 65px; " name="bmi" id="bmi" />
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                </div>
                <div style="width: 100%; border-bottom: 3px solid #333"></div>
                <div style=" text-align: center; margin-bottom: 5px; margin-top: 5px; font-size: 1.1em">
                    <b>REMAINDER OF THIS FORM TO BE COMPLETED BY THE O.D. <label id="lblextra" value=""></label> </b>
                </div>
                <div id="highlight_block_2">
                    <table style="width: 100%">
                        <tr>
                            <td style="background-color: rgba(202,202,202,.2); width: 15%">
                                <div class="field-block">
                                    <div class="block">
                                        DV s <input type="radio" value="s"  name="sorc" id="sorc_s" class="doctor_field" />  /c <input type="radio" value="c"  name="sorc" id="sorc_c" class="doctor_field" /> Rx:
                                    </div>
                                </div>
                            </td>
                            <td style="background-color: rgba(202,202,202,.2); width: 20%">
                                <div class="field-block">
                                    <div class="block">
                                        OD:
                                    </div>
                                    <div class="block">
                                        <label class="" id='odlabel' name='odlabel' value='20/'>20/</label>
                                        <div style="display: inline-block; position: relative">
                                            <select id="dv_od" name="odlist" class="form-field doctor_field"  style="width: 60px">
                                               <option value='' ></option>
                                                <option value='15'>15</option>
                                                <option value='20'>20</option>
                                                <option value='25'>25</option>                                            
                                                <option value='30'>30</option>
                                                <option value='40'>40</option>
                                                <option value='50'>50</option>
                                                <option value='60'>60</option>
                                                <option value='70'>70</option>
                                                <option value='80'>80</option>
                                                <option value='100'>100</option>
                                                <option value='200'>200</option>
                                                <option value='400'>400</option>
                                                <option value='FC'>FC</option>
                                                <option value='HM'>HM</option>
                                                <option value='L Proj'>L Proj</option>
                                                <option value='LP'>LP</option>
                                                <option value='NLP'>NLP</option>
                                            </select>
                                            <input type="text" name="dv_od_combo" id="dv_od_combo" class="form-field doctor_field" />
                                            <select name="fcvals_od" id="fcvals_od"  class="form-field doctor_field" style="visibility: hidden; width:50px">
                                                <option value='' ></option>
                                                <option value='1'>1 ft</option>
                                                <option value='2'>2 ft</option>
                                                <option value='3'>3 ft</option>
                                                <option value='4'>4 ft</option>
                                                <option value='5'>5 ft</option>
                                                <option value='6'>6 ft</option>
                                                <option value='10'>10 ft</option>
                                                <option value='HM' >HM</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td style="background-color: rgba(202,202,202,.2)">
                                <div class="field-block">
                                    <div class="block">
                                        OS:
                                    </div>
                                    <div class="block">
                                        <label class="" id='oslabel' name='oslabel' value='20/'>20/</label>
                                        <div style="display: inline-block; position: relative">
                                            <select id="dv_os" name='dv_os' class="form-field doctor_field"  style="width: 60px">
                                               <option value='' ></option>
                                                <option value='15'>15</option>
                                                <option value='20'>20</option>
                                                <option value='25'>25</option>                                            
                                                <option value='30'>30</option>
                                                <option value='40'>40</option>
                                                <option value='50'>50</option>
                                                <option value='60'>60</option>
                                                <option value='70'>70</option>
                                                <option value='80'>80</option>
                                                <option value='100'>100</option>
                                                <option value='200'>200</option>
                                                <option value='400'>400</option>
                                                <option value='FC'>FC</option>
                                                <option value='HM'>HM</option>
                                                <option value='L Proj'>L Proj</option>
                                                <option value='LP'>LP</option>
                                                <option value='NLP'>NLP</option>
                                            </select>
                                            <input type="text" class="form-field doctor_field" name="dv_os_combo" id="dv_os_combo" />
                                            <select name="fcvals_os" id="fcvals_os"  class="form-field doctor_field" style="visibility: hidden; width:50px">
                                                <option value='' ></option>
                                                <option value='1' >1 ft</option>
                                                <option value='2' >2 ft</option>
                                                <option value='3' >3 ft</option>
                                                <option value='4' >4 ft</option>
                                                <option value='5' >5 ft</option>
                                                <option value='6' >6 ft</option>
                                                <option value='10' >10 ft</option>
                                                <option value='HM' >HM</option>
                                        </select>
                                        </div>
                                    </div>
                                </div>
                            </td>                            
                            <td style="background-color: rgba(202,202,202,.2)">
                                <div class="field-block">
                                    <div class="block">
                                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Last Eye Exam:
                                    </div>
                                    <div class="block">
                                        <input type="text" class="form-field" style="width: 90px" name="last_exam_date" id="last_exam_date" placeholder="MM/DD/YYYY" />
                                        <img  src="/images/vision/event.png" style="float: right; margin-left: 5px; height: 20px; cursor: pointer" id="last_exam_date_btn" value="" />
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table style="width: 100%; margin-top: 2px">
                        <tr>
                            <td style="background-color: rgba(202,202,202,.2); width: 15%">
                                <div class="field-block">
                                    <div class="block">
                                        IOP:
                                    </div>
                                </div>
                            </td>
                            <td style="background-color: rgba(202,202,202,.2); width: 20%">
                                <div class="field-block">
                                    <div class="block">
                                        OD:
                                    </div>
                                    <div class="block">
                                        <input type="text" name="iop_od" id="iop_od"  style="width: 60px" class="form-field doctor_field">
                                        mmHg
                                    </div>
                                </div>
                            </td>
                            <td style="background-color: rgba(202,202,202,.2)">
                                <div class="field-block">
                                    <div class="block">
                                        OS:
                                    </div>
                                    <div class="block">
                                        <input type="text" name="iop_os" id="iop_os"  style="width: 60px" class="form-field doctor_field">
                                        mmHg
                                    </div>
                                </div>
                            </td>
                            <td style="background-color: rgba(202,202,202,.2)">
                                <div class="field-block">
                                    <div class="block">
                                       @
                                    </div>
                                    <div class="block">
                                        <input type="text" class="form-field doctor_field" style="width: 80px" name="exam_time" id="exam_time" />
                                        <select name="exam_time_ampm" id="exam_time_ampm" class="form-field doctor_field" style="width: 50px">
                                            <option value=""> </option>
                                            <option value="AM"> am </option>
                                            <option value="PM"> pm </option>
                                        </select>
                                    </div>
                                </div>
                                <div class="field-block">
                                    <div class="block" style="padding-left: 20px">
                                        <select name="ta_tp" id="ta_tp" class="form-field doctor_field" style="width: 150px">
                                            <option value=""> </option>
                                            <option value="fluress"> Ta (Fluress) </option>
                                            <option value="fluorocaine"> Ta (Fluorocaine) </option>
                                            <option value="tp"> Tp </option>
                                            <option value="iCare"> iCare </option>
                                        </select>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table style="width: 100%; margin-top: 2px">
                        <tr>
                            <td style="background-color: rgba(202,202,202,.2); width: 15%">
                                <div class="field-block">
                                    <div class="block">
                                        Angles:
                                    </div>
                                </div>
                            </td>
                            <td style="background-color: rgba(202,202,202,.2); width: 42%">
                                <div class="field-block">
                                    <div class="block">
                                        OD:
                                    </div>
                                    <div class="block">
                                        <input class="doctor_field" type="radio" name="od_pupil" id="od_pupil_none" value="0" checked='true' style='visibility: hidden' />
                                        <input class="doctor_field" type="radio" name="od_pupil" id="od_pupil_1" value="1" /> 1 &nbsp;
                                        <input class="doctor_field" type="radio" name="od_pupil" id="od_pupil_2" value="2" /> 2 &nbsp;
                                        <input class="doctor_field" type="radio" name="od_pupil" id="od_pupil_3" value="3" /> 3 &nbsp;
                                        <input class="doctor_field" type="radio" name="od_pupil" id="od_pupil_4" value="4"/> 4 &nbsp;
                                        <select name="angle_od" id="angle_od" class='form-field doctor_field' style="width: 90px">
                                            <option value=""></option>
                                            <option value="open"> Open </option>
                                            <option value="moderate"> Moderate </option>
                                            <option value="narrow"> Narrow </option>
                                        </select> &nbsp;&nbsp;
                                    </div>
                                </div>
                            </td>
                            <td style="background-color: rgba(202,202,202,.2)">
                                <div class="field-block">
                                    <div class="block">
                                        OS:
                                    </div>
                                    <div class="block">
                                        <input class="doctor_field" type="radio" name="os_pupil" id="os_pupil_none" value="0" checked='true' style='visibility: hidden' />
                                        <input class="doctor_field" type="radio" name="os_pupil" id="os_pupil_1" value="1" /> 1 &nbsp;
                                        <input class="doctor_field" type="radio" name="os_pupil" id="os_pupil_2" value="2"/> 2 &nbsp;
                                        <input class="doctor_field" type="radio" name="os_pupil" id="os_pupil_3" value="3"/> 3 &nbsp;
                                        <input class="doctor_field" type="radio" name="os_pupil" id="os_pupil_4" value="4"/> 4 &nbsp;
                                        <select name="angle_os" id="angle_os" style="width: 90px" class='form-field doctor_field' >
                                            <option value=""></option>
                                            <option value="open"> Open </option>
                                            <option value="moderate"> Moderate </option>
                                            <option value="narrow"> Narrow </option>
                                        </select> &nbsp;&nbsp;                                        
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table style="width: 100%; margin-top: 2px">
                        <tr>
                            <td style="background-color: rgba(202,202,202,.2); width: 15%">
                                <div class="field-block">
                                    <div class="block">
                                        Dilation:
                                    </div>
                                </div>
                            </td>
                            <td style="background-color: rgba(202,202,202,.2);">
                                <div class="field-block">
                                    <div class="block">
                                        <input class="doctor_field" type='checkbox' name='dilation_none' id='dilation_none' value='Y'/>None&nbsp;&nbsp;
                                        <input class="doctor_field" type='checkbox' name='dilation_fivem' id='dilation_fivem' value='Y'/>0.5% M&nbsp;&nbsp;
                                        <input class="doctor_field" type='checkbox' name='dilation_onem' id='dilation_onem' value='Y'/>1.0% M&nbsp;&nbsp;
                                        <input class="doctor_field" type='checkbox' name='dilation_twentyfiven' id='dilation_twentyfiven' value='Y'/>2.5% N
                                        <input class="doctor_field" type='checkbox' name='dilation_paremyd' id='dilation_paremyd' value='Y'/>Paremyd
                                        
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table style="width: 100%; margin-top: 2px">
                        <tr>
                            <td style="background-color: rgba(202,202,202,.2); width: 15%">
                                <div class="field-block">
                                    <div class="block">
                                        Diabetic Dx:
                                    </div>
                                </div>
                            </td>
                            <td style="background-color: rgba(202,202,202,.2);">
                                <div class="field-block">
                                    <div class="block">
                                        <input class="doctor_field" type='radio' name='retinopathy' id='retinopath_no' value='N' /> No diabetic retinopathy
                                    </div>
                                </div>
                            </td>
                            <td style="background-color: rgba(202,202,202,.2);">
                                <div class="field-block">
                                    <div class="block">
                                        <input class="doctor_field" type='radio' name='retinopathy' id='retinopath_background' value='B' /> Background diabetic retinopathy
                                    </div>
                                </div>
                            </td>
                            <td style="background-color: rgba(202,202,202,.2);">
                                <div class="field-block">
                                    <div class="block">
                                        <input class="doctor_field" type='radio' name='retinopathy' id='retinopath_proliferative' value='P' /> Proliferative diabetic retinopathy
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table style='width: 100%; margin-bottom: 15px'>
                        <tr>
                            <td  width='16%' style="background-color: rgba(202,202,202,.2);">
                                Positive exam findings:&nbsp;
                            </td>
                            <td width='84%'>
                                <input type="text" class="form-field doctor_field" style="width: 100%" name="exam_finding" id="exam_finding" />
                            </td>
                        </tr>
                    </table>
                    <div style="width: 49.5%; float: left;">
                        <u>Diagnosis Codes</u>:
                        <table style='width: 100%'>
                            <tr>
                                <th width='10%' class='diagnosis_codes_header'>T2DM</th>
                                <th width='10%' class='diagnosis_codes_header'>T1DM</th>
                                <th width='30%' class='diagnosis_codes_header'>Description</th>
                            </tr>
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field nodx" type='checkbox' name='diag_code_e11_9' id='diag_code_e11_9' value='Y' style='margin-right: 10px'  /> E 11.9
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field nodx" type='checkbox' name='diag_code_e10_9' id='diag_code_e10_9' value='Y' style='margin-right: 10px' /> E 10.9
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'> DM controlled, no ocular manif.</td>
                            </tr>
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field nodx" type='checkbox' name='diag_code_e11_65' id='diag_code_e11_65' value='Y' style='margin-right: 10px' /> E 11.65
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field nodx" type='checkbox' name='diag_code_e10_65' id='diag_code_e10_65' value='Y' style='margin-right: 10px' /> E 10.65
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'>
                                    DM uncontrolled, no ocular manif.
                                </td>
                            </tr>  
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field backgrounddx" type='checkbox' name='diag_code_e11_39' id='diag_code_e11_39' value='Y' style='margin-right: 10px' /> E 11.39
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field backgrounddx" type='checkbox' name='diag_code_e10_39' id='diag_code_e10_39' value='Y' style='margin-right: 10px' /> E 10.39
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'>
                                    Diabetes with ocular manif.*
                                </td>
                            </tr>  
                            <tr>
                                <td colspan='2' class='diagnosis_codes_cell'>
                                    <input class="doctor_field backgrounddx" type='checkbox' name='other_diabetes' id='other_diabetes' value='Y' style='margin-right: 10px' /> E 13.9
                                </td>
                                <td class='diagnosis_codes_cell'>
                                     Other Diabetes, without complications
                                </td>
                            </tr>   
                            <tr><td colspan="3"><b><u>* If w/ oc manif, <span style="color: blue">MUST ALSO CODE </span>one of the following codes</u></b></td></tr>   
                            <tr><td colspan="3"><b><u>** <span style="color: blue">REQUIRES 7TH DIGIT: </span> 1=OD, 2=OS, 3=OU, 9=Unspecified</u></b></td></tr>  
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field backgrounddx" type='checkbox' name='diag_code_e11_319' id='diag_code_e11_319' value='Y' style='margin-right: 10px' /> E 11.319
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field backgrounddx" type='checkbox' name='diag_code_e10_319' id='diag_code_e10_319' value='Y' style='margin-right: 10px' /> E 10.319
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'>
                                    Unspecified DR, no ME
                                </td>
                            </tr>                          
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field backgrounddx" type='checkbox' name='diag_code_e11_311' id='diag_code_e11_311' value='Y' style='margin-right: 10px' /> E 11.311
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field backgrounddx" type='checkbox' name='diag_code_e10_311' id='diag_code_e10_311' value='Y' style='margin-right: 10px' /> E 10.311
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'>
                                    Unspecified DR, w/ ME 
                                </td>
                            </tr>    
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e11_321' id='diag_code_e11_321' value='Y' style='margin-right: 10px' />  <label  id='lbl_code_e11_321' for='diag_code_e11_321'>E 11.321_</label>
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e10_321' id='diag_code_e10_321' value='Y' style='margin-right: 10px' /> <label  id='lbl_code_e10_321' for='diag_code_e10_321'>E 10.321_</label>
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'>
                                    Nonprolif, mild DR, w/ ME <span style="color: blue; weight: bold">**</span>
                                </td>
                            </tr>      
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e11_329' id='diag_code_e11_329' value='Y' style='margin-right: 10px' /> <label  id='lbl_code_e11_329' for='diag_code_e11_329'>E 11.329_</label>
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e10_329' id='diag_code_e10_329' value='Y' style='margin-right: 10px' /> <label  id='lbl_code_e10_329' for='diag_code_e10_329'>E 10.329_</label>
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'>
                                    Nonprolif, mild DR, no ME <span style="color: blue; weight: bold">**</span>
                                </td>
                            </tr>          
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e11_331' id='diag_code_e11_331' value='Y' style='margin-right: 10px' /> <label  id='lbl_code_e11_331' for='diag_code_e11_331'>E 11.331_</label>
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e10_331' id='diag_code_e10_331' value='Y' style='margin-right: 10px' /> <label  id='lbl_code_e10_331' for='diag_code_e10_331'>E 10.331_</label>
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'>
                                    Nonprolif, mod DR, w/ME <span style="color: blue; weight: bold">**</span>
                                </td>
                            </tr>  
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e11_339' id='diag_code_e11_339' value='Y' style='margin-right: 10px' /> <label  id='lbl_code_e11_339' for='diag_code_e11_339'>E 11.339_</label>
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e10_339' id='diag_code_e10_339' value='Y' style='margin-right: 10px' /> <label  id='lbl_code_e10_339' for='diag_code_e10_339'>E 10.339_</label>
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'>
                                    Nonprolif, mod DR, no ME <span style="color: blue; weight: bold">**</span>
                                </td>
                            </tr>                        
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e11_341' id='diag_code_e11_341' value='Y' style='margin-right: 10px' /> <label  id='lbl_code_e11_341' for='diag_code_e11_341'>E 11.341_</label>
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e10_341' id='diag_code_e10_341' value='Y' style='margin-right: 10px' />  <label  id='lbl_code_e10_341' for='diag_code_e10_341'>E 10.341_</label>
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'>
                                    Nonprolif, severe DR, w/ ME <span style="color: blue; weight: bold">**</span>
                                </td>
                            </tr>                      
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e11_349' id='diag_code_e11_349' value='Y' style='margin-right: 10px' /> <label  id='lbl_code_e11_349' for='diag_code_e11_349'>E 11.349_</label>
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e10_349' id='diag_code_e10_349' value='Y' style='margin-right: 10px' /> <label  id='lbl_code_e10_349' for='diag_code_e10_349'>E 10.349_</label>
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'>
                                    Nonprolif, severe DR, no ME <span style="color: blue; weight: bold">**</span>
                                </td>
                            </tr>
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e11_351' id='diag_code_e11_351' value='Y' style='margin-right: 10px' />  <label  id='lbl_code_e11_351' for='diag_code_e11_351'>E 11.351_</label>
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e10_351' id='diag_code_e10_351' value='Y' style='margin-right: 10px' />  <label  id='lbl_code_e10_351' for='diag_code_e10_351'>E 10.351_</label>
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'>
                                    Proliferative DR, w/ ME <span style="color: blue; weight: bold">**</span>
                                </td>
                            </tr>
                            <tr>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e11_359' id='diag_code_e11_359' value='Y' style='margin-right: 10px' /> <label  id='lbl_code_e11_359' for='diag_code_e11_359'>E 11.359_</label>
                                </td>
                                <td width='10%' class='diagnosis_codes_cell'>
                                    <input class="doctor_field cdbs" type='checkbox' name='diag_code_e10_359' id='diag_code_e10_359' value='Y' style='margin-right: 10px' />  <label  id='lbl_code_e10_359' for='diag_code_e10_359'>E 10.359_</label>
                                </td>
                                <td width='30%' class='diagnosis_codes_cell'>
                                    Proliferative DR, no ME <span style="color: blue; weight: bold">**</span>
                                </td>
                            </tr>
                        </table>
                        <div style="clear: both"></div>
                    </div>
                    <div style="width: 49.5%; display: inline-block;" onchange="">
                        <b><u>Procedure Codes</u></b>: <br />
                        <div style="border: 1px solid #bbb; margin-top: 6px">
                            <div style="padding-bottom: 6px; font-weight: bold">
                                Physician In-person Screening Event*
                            </div>
                            <div style='display: inline-block; margin-right: 2px; width: 20%'>
                                <input class="doctor_field" type='checkbox' name='pc_s3000' id='pc_s3000' value='Y' style='margin-right: 10px' /> S3000
                            </div>
                            <div style='display: inline-block; margin-right: 2px'>
                                Diabetic retinal exam; dilated, bilateral
                            </div>
                            <div style="clear: both"></div>
                            <div style='display: inline-block; margin-right: 2px; width: 20%'>
                                <input class="doctor_field" type='checkbox' name='pc_2022f' id='pc_2022f' value='Y' style='margin-right: 10px' />
                                2022F
                            </div>
                            <div style='display: inline-block; margin-right: 2px'>
                                DFE with retinopathy present 
                            </div>                            
                            <div style="clear: both"></div>                            
                            <div style='display: inline-block; margin-right: 2px; width: 20%'>
                                <input class="doctor_field" type='checkbox' name='pc_2023f' id='pc_2023f' value='Y' style='margin-right: 10px' />
                                2023F
                            </div>
                            <div style='display: inline-block; margin-right: 2px'>
                                DFE without retinopathy present
                            </div>
                            <div style="clear: both"></div>
                            <div style='display: inline-block; margin-right: 2px; width: 20% ' class="lbl3072f">
                                <input class="doctor_field" type='checkbox' name='pc_3072f' id='pc_3072f' value='Y' style='margin-right: 10px' />
                               3072F
                            </div>
                            <div style='display: inline-block; margin-right: 2px' class="lbl3072f">
                                Low risk of DR (no retinopathy in prior year)
                            </div>                            
                            <div style="clear: both"></div>
                            <div style="font-weight: bold; padding-top: 2px; margin-top: 6px">
                                *If retinopathy present, MUST ALSO CODE the following
                            </div>
                            <div style="clear: both"></div>
                            <div style='display: inline-block; margin-right: 2px; width: 20%'>
                                <input class="doctor_field" type='checkbox' name='pc_5010f' id='pc_5010f' value='Y' style='margin-right: 10px' />
                                5010F
                            </div>
                            <div style='display: inline-block; margin-right: 2px'>
                                PCP report - dilated macular/fundus exam
                            </div>
                            <div style="clear: both"></div>
                            <div style='display: inline-block; margin-right: 2px; width: 20%'>
                                <input class="doctor_field" type='checkbox' name='pc_g8397' id='pc_g8397' value='Y' style='margin-right: 10px' />
                                G8397
                            </div>
                            <div style='display: inline-block; margin-right: 2px'>
                               DFE including +/- ME and severity of DR
                            </div>                              
                        </div>
                        <div style="clear: both"></div>
                        <div style="border: 1px solid #bbb; margin-top: 12px">
                            <div style="padding-top: 2px; padding-bottom: 6px; font-weight: bold">
                                Telescreening Event - Physician not present<br />
                                (FUNDUS PHOTOS-NO DILATION; electronically signed)
                            </div>
                            <div style='display: inline-block; margin-right: 2px; width: 20%'>
                                <input class="doctor_field" type='checkbox' name='pc_92227' id='pc_92227' value='Y' style='margin-right: 10px' />
                               92227
                            </div>
                            <div style='display: inline-block; margin-right: 2px'>
                                Telescreening for detection of DR + I&amp;R
                            </div>                             
                            <div style="clear: both"></div>
                            <div style='display: inline-block; margin-right: 2px; width: 20%'>
                                <input class="doctor_field" type='checkbox' name='pc_2033f' id='pc_2033f' value='Y' style='margin-right: 10px' />
                               2033F
                            </div>
                            <div style='display: inline-block; margin-right: 2px'>
                                Eye imaging validated without retinopathy
                            </div>                            
                            <div style="clear: both"></div>
                            <div style='display: inline-block; margin-right: 2px; width: 20%'>
                                <input class="doctor_field" type='checkbox' name='pc_92228' id='pc_92228' value='Y' style='margin-right: 10px' />
                               92228
                            </div>
                            <div style='display: inline-block; margin-right: 2px'>
                                Telescreening w/ active DR present + I&amp;R
                            </div>                        
                            <div style="clear: both"></div>
                            <div style='display: inline-block; margin-right: 2px; width: 20%'>
                                <input class="doctor_field" type='checkbox' name='pc_2026f' id='pc_2026f' value='Y' style='margin-right: 10px' />
                               2026F
                            </div>
                            <div style='display: inline-block; margin-right: 2px'>
                                Eye imaging validated with retinopathy
                            </div>
                            <div style="clear: both"></div>
                            <div style='display: inline-block; margin-right: 2px; '>
                                <input class="doctor_field" type='checkbox' name='images_unreadable' id='images_unreadable' value='Y' style='margin-right: 10px' />
                                <b>IMAGES UNREADABLE-REFER TO O.D. FOR DILATION</b>
                            </div>                                 
                        </div>
                        <div style="border-bottom: 2px solid #333; margin-top: 15px; margin-bottom: 15px"></div>
                        <div id="recommendations" >                        
                            <b><u>Recommendations</u></b>:<br />
                            <div style='display: inline-block; margin-right: 2px; width: 60%'>
                                 <input class="doctor_field" type='checkbox' name='eye_exam' id='eye_exam' value='Y' style='margin-right: 10px' />
                                 Comprehensive Eye Exam
                            </div>
                            <div style='display: inline-block; margin-right: 2px'>
                                <input type='text' name='eye_exam_period_quantity' id='eye_exam_period_quantity' class='form-field doctor_field referral_field ' style='width: 50px; text-align: center' />
                                <select name='eye_exam_period' id='eye_exam_period' class='form-field doctor_field referral_field' style="width: 80px">
                                    <option value=''></option>
                                    <option value='DAYS'> Days </option>
                                    <option value='WEEKS'> Wks </option>
                                    <option value='MONTHS'> Mos </option>
                                </select>
                            </div>
                            <div style="clear: both"></div>
                            <div style='display: inline-block; margin-right: 2px; width: 60%'>
                                <input class="doctor_field" type='checkbox' name='opth_referral' id='opth_referral' value='Y' style='margin-right: 10px' />
                                Referral to Ophthalmologist
                            </div>
                            <div style='display: inline-block; margin-right: 2px'>
                                <input type='text' name='opth_referral_period_quantity' id='opth_referral_period_quantity' class='form-field doctor_field referral_field' style='width: 50px; text-align: center' />
                                <select name='opth_referral_period' id='opth_referral_period' class='form-field doctor_field referral_field' style="width: 80px" >
                                    <option value=''></option>
                                    <option value='DAYS'> Days </option>
                                    <option value='WEEKS'> Wks </option>
                                    <option value='MONTHS'> Mos </option>
                                </select>
                            </div>                         
                            <div style="clear: both"></div>    
                            <div style='display: inline-block; margin-right: 2px; width: 60%'>
                                <input class="doctor_field" type='checkbox' name='retinal_referral' id='retinal_referral' value='Y' style='margin-right: 10px' />
                                Referral to Retinal Specialist
                            </div>
                            <div style='display: inline-block; margin-right: 2px'>
                                <input type='text' name='retinal_referral_period_quantity' id='retinal_referral_period_quantity' class='form-field doctor_field  referral_field' style='width: 50px; text-align: center' />
                                <select name='retinal_referral_period' id='retinal_referral_period' class='form-field doctor_field referral_field' style="width: 80px">
                                    <option value=''></option>
                                    <option value='DAYS'> Days </option>
                                    <option value='WEEKS'> Wks </option>
                                    <option value='MONTHS'> Mos </option>
                                </select>
                            </div>   
                        </div>
                    </div>
                    <div style='border-bottom: 3px solid #333; margin-top: 5px; margin-bottom: 15px; clear: both'></div>
                    <div style='position: relative; margin-top: 10px'>
                        <textarea class='form-field' readonly="readonly" style='overflow-y: auto; overflow-x: hidden; width: 99%; padding: 5px; height: 92px' name='comment' id='comment'></textarea>
                        <div style='position: absolute; top: -10px; left: 4px; font-size: 1.3em; font-weight: bolder'>Notes:</div>
                    </div>
                    <div style="background-color: rgba(202,202,202,.3); position: relative">
                       <!--
                       
                       OK, HERE WE TRY TO FIGURE OUT WHAT BUTTONS WE ARE GOING TO MAKE AVAILABLE TO THE PERSON LOOKING AT THE FORM
                       
                       ALL BUTTONS WILL BE DISPLAY: NONE AND THE STATE TRANSITION WILL ENABLE WHICH EVER ONES IT NEEDS
                       
                       ALL BUTTONS SHOULD BE LISTED HERE
                       
                       -->
                            <!--input type="button" id='regenerate_screening_form_button'  style="float: right; display: none; margin-right: 1px" value="  Regenerate Screening Form  " onclick='Argus.vision.consultation.generate.singlereport("{$data.member_id}","{$data.event_date}" ,"{$data.address_id}","{$data.event_id}" )' /-->
                            
                            <input type="button" id="release_to_pcp_portal" onclick="Argus.vision.pcp.release('{$form_id}')" style="margin-left: auto; margin-right: auto; display: none;" value="  Release To PCP Portal  " />
                            
                            <input type="button" id="mark_form_as_claimed_button" onclick="Argus.vision.claim.clear()" style="float: left; display: none; margin-left: 1px" value="  Mark Form Claimed  " />
                            
                            <!-- EXAMINE THE DOUBLE ID BELOW!!!! -->
                            <input type="button" id="doctor_sign_and_complete_button" class="" style="float: right; display: none; margin-right: 1px" id='docform' value="  Doctor Sign and Complete Form  " />
    
                            <input id="return_to_submitter_button" type="button" value="  Return To Submitter  " style="display: none"/>
                            
                            <input id="form_recall_button" type="button" value=" Recall Form Prior To Review " style="display: none; font-size: 10pt; float: right; color: #333" onclick="CurrentForm.recall()" />
                            
                            <input id="submit_for_review_button" type="button" value="  Submit For O.D. Review  " style="display: none"/>
                            
                            <input id="clear_signature_and_return_to_doctor_button" type="button" value=" Clear Signature And Return To Doctor " style="display: none"/>
                            <div style="clear: both"></div>
                    </div>                        
                    <div style="clear: both"></div>
                    <div style="width: 100%; background-color: rgba(202,202,202,.2);" id="od_signature">
                        &nbsp;
                    </div>
                </div>
                <div style='clear: both'></div>        
                <div style="text-align: center; margin-top: 5px; border-top: 1px solid #333">
                    <div style="float: right; margin-right: 5px">(rev 04.16.18)</div>
                    <b>Argus Dental &amp; Vision, Inc.</b>, 4919 W. Laurel Street, Tampa, FL, 33607 (Toll Free 877-710-5174)
                </div>                            
            </div>
            <div style="clear: both"></div>
        </form>
    </div>
</div>
{if (!$print)}
    <br /><br />
    <div id="vision-form-feedback-tab" style="padding: 10px">
        <form name="feedback_form" id="feedback_form" onsubmit="return false">
            
                <div style="width: 600px; margin-left: auto; margin-right: auto">
                    <fieldset><legend>Feedback Form</legend>
                    <div style="display: inline-block; width: 48%;">
                        <u>Image Quality</u><br /><br />
                        <input type="radio" class="doctor_field" name="image_quality" id="image_quality_5" value="5" /> Very Good<br />
                        <input type="radio" class="doctor_field" name="image_quality" id="image_quality_4" value="4" /> Good<br />
                        <input type="radio" class="doctor_field" name="image_quality" id="image_quality_3" value="3" /> Fair<br />
                        <input type="radio" class="doctor_field" name="image_quality" id="image_quality_2" value="2" /> Poor<br />
                        <input type="radio" class="doctor_field" name="image_quality" id="image_quality_1" value="1" /> Too Dark<br />
                    </div>                
                    <div style="display: inline-block; width: 48%">
                        <u>Submitted Without:</u><br /><br />
                        <input type="checkbox" class="doctor_field" name="missing_a1c"            id="missing_a1c"           value="Y" /> Hemoglobin A1C Value<br />
                        <input type="checkbox" class="doctor_field" name="missing_diabetes_type"  id="missing_diabetes_type" value="Y" /> Diabetes Type (1 or 2)<br />
                        <input type="checkbox" class="doctor_field" name="missing_pcp_npi"        id="missing_pcp_npi"       value="Y" /> PCP NPI #<br />
                        <input type="checkbox" class="doctor_field" name="missing_event_location" id="missing_event_location" value="Y" /> Event Location<br />
                        <input type="checkbox" class="doctor_field" name="no_readable_images"     id="no_readable_images"    value="Y" /> Readable Images For Both Eyes*<br />
                    </div>
                    <div style="padding: 20px">
                        * Need readable images for both eyes or a note stating patient is monocular in order to complete record.                    
                    </div>
                    Additional Comments<br />
                    <textarea class="doctor_field" name="additional_comments" id="additional_comments" style="background-color: lightcyan; width: 90%; height: 100px; color: #333; border: 1px solid #aaf; padding: 3px" placeholder="Comments..."></textarea>
                    </fieldset>
                </div>
        </form>
    </div>
{/if}
</div>
<script type='text/javascript'>

    //To make things easier, we are going to limit ourselves to editing one form at a time.
    var CurrentForm = Argus.vision.consultation.get('{$print}','{$tag}','{$form_id}','{$window_id}','{$current_user}','{$doctor}','{$pcp_staff}','{$pcp}','{$IPA}');    
    {if ($print)}
        Humble.init(function () {
            CurrentForm.init(function () { window.setTimeout(window.print,1500) });
            (function () {
                var val;
                (new EasyAjax('/vision/feedback/load')).add('form_id','{$form_id}').then(function (response) {
                    var data = JSON.parse(response);
                    for (var i in data) {
                        if ((i !== "id") && (i !== "form_id")) {
                            if (i == "image_quality") {
                                $("#"+i+"_"+data[i]).attr("checked",true);
                            } else if (data[i]=='Y') {
                                $('#'+i).attr("checked",true);
                            } else {
                                $('#'+i).val(data[i]);
                            }
                        }
                    }
                }).post();
                $('#feedback_form').on('change',function (evt) {
                    if (evt.target.type == "checkbox") {
                        val = (evt.target.checked) ? "Y" : ""
                    } else {
                        val = $(evt.target).val();
                    }
                    (new EasyAjax('/vision/feedback/save')).add('form_id','{$form_id}').add(evt.target.name,val).then(function (response) {
                    }).post();
                });
            })();        

        });
       
    {else}
        CurrentForm.init();
        (function () {
            var val;
            (new EasyAjax('/vision/feedback/load')).add('form_id','{$form_id}').then(function (response) {
                var data = JSON.parse(response);
                for (var i in data) {
                    if ((i !== "id") && (i !== "form_id")) {
                        if (i == "image_quality") {
                            $("#"+i+"_"+data[i]).attr("checked",true);
                        } else if (data[i]=='Y') {
                            $('#'+i).attr("checked",true);
                        } else {
                            $('#'+i).val(data[i]);
                        }
                    }
                }
            }).post();
            $('#feedback_form').on('change',function (evt) {
                if (evt.target.type == "checkbox") {
                    val = (evt.target.checked) ? "Y" : ""
                } else {
                    val = $(evt.target).val();
                }
                (new EasyAjax('/vision/feedback/save')).add('form_id','{$form_id}').add(evt.target.name,val).then(function (response) {
                }).post();
            });
        })();        
    {/if}

</script>