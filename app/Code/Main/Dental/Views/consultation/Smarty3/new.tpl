{assign var=status  value=false}
{assign var=data    value=false}
{assign var=dentist value=$role->userHasRole('DDS')}
{assign var=hygienist value=$role->userHasRole('Tele Hygienist')}
{foreach from=$form->consultationInformation() item=data}
    {assign var=form_id value=$data['form_id']}
{/foreach}
{assign var=browse value=false}
<style type="text/css">
    .block {
        display: inline-block; color: #333
    }
    .field-block {
        white-space: nowrap; margin-right: 2px; margin-bottom: 2px; display: inline-block
    }
    .dental-row {
         min-width: 600px; overflow: hidden; white-space: nowrap
    }
    .dental-cell {
        padding: 2px; display: inline-block; background-color: rgba(202,202,202,.2); margin-right: 2px; overflow: hidden; min-width: 120px
    }
    .dental-cell-title {
        font-family: monospace; font-size: .8em; letter-spacing: 2px; color: #333
    }
    .dental-cell-content {
        font-family: sans-serif; color: black; font-size: 1em; padding-left: 15px
    }
    .form-row {
        overflow: hidden; width: 100%; clear: both; white-space: nowrap
    }
    .form-field {
        background-color: #dfdfdf; border: 1px solid transparent; padding: 3px; border-radius: 3px; border-bottom-color: #999
    }
    .form-field:focus {
        background-color: lightcyan; border-bottom-color: #333
    }
    .diagnosis_codes_header {
        text-align: center; font-weight: bolder; text-decoration: underline
    }
    .diagnosis_codes_cell {
        overflow: hidden;
    }
    .tooth-whole {
        position: absolute;
    }
    .tooth-outer {
        width: 30px; padding: 15px; height: 30px; overflow: hidden; border: 1px solid #333;  border-radius: 20px
    }
    .tooth-cross {
        transform: rotate(45deg); position: absolute; top: 0px; left: 0px; width: 30px; height: 30px; box-sizing: border-box; background-color: #FAE5D3; z-index: 1; opacity: .5
    }
    .tooth-cross:hover {
        opacity: 1.0;
    }
    .tooth-cross-section {
        display: inline-block; width: 15px; height: 15px;
    }
    .tooth-inner {
        position: relative; top: -8px; left: -8px; width: 16px; height: 16px; border-radius: 10px; border: 1px solid #333;  z-index: 3; background-color: ghostwhite; font-size: .9em; text-align: center; font-weight: bolder
    }
    .tooth-inner:hover {
        background-color: #FAE5D3
    }
    .baby-tooth-whole {
        position: absolute;
    }
    .baby-tooth-outer {
        width: 30px; padding: 15px; height: 30px; overflow: hidden; border: 1px solid #333;  border-radius: 20px
    }
    .baby-tooth-cross {
        transform: rotate(45deg); position: absolute; top: 0px; left: 0px; width: 30px; height: 30px; box-sizing: border-box; background-color: #FAE5D3; z-index: 1; opacity: .5
    }
    .baby-tooth-cross:hover {
        opacity: 1.0;
    }
    .baby-tooth-cross-section {
        display: inline-block; width: 15px; height: 15px;
    }
    .baby-tooth-inner {
        position: relative; top: -8px; left: -8px; width: 16px; height: 16px; border-radius: 10px; border: 1px solid #333;  z-index: 3; background-color: ghostwhite; font-size: .9em; text-align: center; font-weight: bolder
    }
    .baby-tooth-inner:hover {
        background-color: #FAE5D3
    }
    .dental-signature-button {
        background-color: #d84a38; color: ghostwhite; padding: 5px 10px; border-radius: 3px; border: 1px solid transparent;
    }
</style>
<div id="dental-consultation-header" style='padding-bottom: 4px; border-bottom: 1px solid #333; '>

</div>
<div id="dental-consultation-body" style="overflow: auto">
    <div id="dental-form-snapshots-tab"></div>
    <div id="dental-form-xray-tab">
        <div style="display: none; position: absolute; top: 0px; left: 0px; z-index: 100" id="xray-upload-layer-{$window_id}">
            <table style='width: 100%; height: 100%;'>
                <tr>
                    <td style='background-color: rgba(77,77,77,.3)'>
                        <div style='width: 500px; padding: 10px; border-radius: 10px; border: 1px solid #aaf; background-color: ghostwhite; margin-left: auto; margin-right: auto'>
                            <form name='dental-attach-xray-form' id='dental-attach-xray-form-{$window_id}' onsubmit='return false'>
                                <fieldset style='padding: 10px'>
                                    <legend>Instructions</legend>
                                    Please use the file selection box below to select an X-Ray to attach to this form, and then click 'Attach', otherwise click 'Cancel' to close this window<br /><br />
                                    <input type='file' multiple="true" name='form-scan-image' id='form-scan-image-{$window_id}' style='background-color: lightcyan; padding: 3px; border: 1px solid #aaf; border-radius: 3px; width: 300px' placeholder='Scanned Image' /><br /><br />
                                    <div id="upload-controls-{$window_id}}">
                                        <input type='button' value='Attach' style='float: right' onclick='Argus.dental.xray.attach("{$form_id}","{$window_id}")' />
                                        <input type='button' value='Cancel' onclick="$('#xray-upload-layer-{$window_id}').css('display','none')" />
                                    </div>
                                    <div id="upload-controls-spinner-{$window_id}" style="display: none; font-size: 1.3em; text-align: center; font-style: italic; color: #333">
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
            <div id='dental-form-xray-list'>
            </div>
            <div style='margin-top: 10px; padding-left: 10px'>
                <!--input type='button' id='add-scan-button-{$window_id}' value='Add Scan' /-->
            </div>
        </div>
    </div>
    <div id="dental-form-tab">
        <div style="display: none; position: absolute; top: 0px; left: 0px; z-index: 100" id="form-comment-layer-{$window_id}">
            <table style='width: 100%; height: 100%;'>
                <tr>
                    <td style='background-color: rgba(77,77,77,.3)'>
                        <div style='width: 500px; padding: 10px; border-radius: 10px; border: 1px solid #aaf; background-color: ghostwhite; margin-left: auto; margin-right: auto'>
                            <form name='comment-attach-form' id='comment-attach-form-{$window_id}' onsubmit='return false'>
                                <fieldset style='padding: 10px'>
                                    <legend>Instructions</legend>
                                    Please add your comment below<br /><br />
                                    <textarea id="vision_form_comments_{$form_id}" placeholder='New Comment...' style='overflow-y: auto; overflow-x: hidden; width: 100%; height: 100px; background-color: lightcyan; border: 1px solid #aaf'></textarea>
                                    <input type='button' value='Attach' style='float: right' onclick='Argus.vision.comment.post("{$form_id}","{$window_id}")' />
                                    <input type='button' value='Cancel' onclick="$('#form-comment-layer-{$window_id}').css('display','none')" />
                                </fieldset>
                            </form>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div id="dental-consultation-body">
            <form name="new-dental-consultation-form" id="new-dental-consultation-form-{$window_id}" onsubmit="return false">

                <input type="hidden" name="hygienist_signature"   id="hygienist_signature-{$window_id}" value="" />
                <input type="hidden" name="hygienist_signed_date" id="hygienist_signed_date-{$window_id}" value="" />
                <input type="hidden" name="hygienist_signed_time" id="hygienist_signed_time-{$window_id}" value="" />
                <input type="hidden" name="dentist_signature"     id="dentist_signature-{$window_id}" value="" />
                <input type="hidden" name="dentist_signed_date"   id="dentist_signed_date-{$window_id}" value="" />
                <input type="hidden" name="dentist_signed_time"   id="dentist_signed_time-{$window_id}" value="" />
                <input type="hidden" name="status"                id="status-{$window_id}" value="" />
                <input type="hidden" name="form_id"               id="form_id-{$window_id}" value="" />
                <input type="hidden" name="hygienist"             id="hygienist-{$window_id}" value="" />
                <input type="hidden" name="dentist"               id="dentist-{$window_id}" value="" />
                <input type="hidden" name="id"                    id="id-{$window_id}" value="" />
                <input type="hidden" name="visit_date"            id="visit_date-{$window_id}" value="" />
                <input type="hidden" name="submit_date"           id="submit_date-{$window_id}" value="" />
                <input type="hidden" name="last_activity_date"    id="last_activity_date-{$window_id}" value="" />
                <input type="hidden" name="review_by_date"        id="review_by_date-{$window_id}" value="" />
                <div style="width: 885px; padding-left: 10px; padding-right: 10px; margin-left: 10px; border-right: 1px solid #333">
                    <div style="background-color: rgba(202,202,202,.2); position: relative; padding: 10px; font-size: 1.2em; color: black;">
                        <div style="text-align: center; font-size: 1.2em; text-decoration: underline; margin-bottom: 10px">
                            DENTAL SCREENING
                        </div>
                        <b><u>Electronic Consent</u></b>: Will be signed in the Dashboard by parent guardian (over 18).
                        <div style="text-align: justify; margin-top: 15px">
                        <b><u>Patient Understanding, Acknowledgement, and Consent</u></b>:<br />  This service is a screening and/or assessment of the oral cavity and NOT a comprehensive examination. It is strongly recommended that you contact your primary dental provider and schedule your comprehensive oral exam. The comprehensive oral exam will provide a detailed examination of your gum and tooth health and will determine your need for a preventative health maintenance plan. By signing below, you are consenting to screening/assessment provided by a licensed Registered Dental Hygienist and may include a remote/live exam by a Dentist.
                        <div style="float: right; font-size: .9em; font-family: monospace; letter-spacing: 0.5px">
                            Click to Acknowledge Consent <input type="checkbox" name="consent_decree" id="consent_decree-{$window_id}" value="Y" />
                        </div>
                        </div>
                    </div>
                    <div class="dental-row" style='margin-top: 2px;'>
                        <div class="dental-cell" style='width:30%'>
                            <div class="dental-cell-title">
                                Patient Name
                            </div><div class="dental-cell-content">
                                <input type="text" name="member_name" id="member_name-{$window_id}" class="form-field" style="width: 100%" value="" />
                            </div>
                        </div><div class="dental-cell" style='width: 30%'>
                            <div class="dental-cell-title">
                                Member ID
                            </div>
                            <div class="dental-cell-content">
                                <input type="text" name="member_id" id="member_id-{$window_id}" class="form-field" style="width: 100%" value="" />
                            </div>
                        </div><div class="dental-cell" style="width: 16%">
                            <div class="dental-cell-title">
                                Date Of Birth
                            </div>
                            <div class="dental-cell-content">
                                <input type="text" placeholder='MM/DD/YYYY' onchange='Argus.teledentistry.form.age(this,"{$window_id}")' name="patient_dob" id="patient_dob-{$window_id}" class="form-field" style="width: 100%" value="" />
                            </div>

                        </div><div class="dental-cell" style="min-width: 5%">
                            <div class="dental-cell-title">
                                Age
                            </div>
                            <div class="dental-cell-content">
                                <input type="text" name="patient_age" id="patient_age-{$window_id}" class="form-field" style="width: 60px" value="" />
                            </div>
                        </div><div class="dental-cell" style="width: 14%">
                            <div class="dental-cell-title">
                                Exam Date
                            </div>
                            <div class="dental-cell-content">
                                <input type="text" placeholder='MM/DD/YYYY' name="consultation_date" id="consultation_date-{$window_id}" class="form-field" style="width: 100%" value="" />
                            </div>
                        </div>
                    </div><div class="dental-row">
                        <div class="dental-cell" style="width: 40%">
                            <div class="dental-cell-title">
                                Parent or Guardian Name
                            </div>
                            <div class="dental-cell-content">
                                <input type="text" name="patient_guardian" id="patient_guardian-{$window_id}" class="form-field" style="width: 100%" value="" />
                            </div>
                        </div><div class="dental-cell" style="width: 60%">
                            <div class="dental-cell-title">
                                Allergies
                            </div>
                            <div class="dental-cell-content">
                                <input type="text" name="patient_allergies" id="patient_allergies-{$window_id}" class="form-field" style="width: 100%" value="" />
                            </div>
                        </div>
                    </div><div class="dental-row">
                        <div class="dental-cell" style="width: 100%">
                            <div class="dental-cell-title">
                                E-Mail Address
                            </div>
                            <div class="dental-cell-content">
                                <input type="text" name="email_address" id="email_address-{$window_id}" class="form-field" style="width: 70%" value="" />
                            </div>
                        </div>
                    </div>
                    <div style="text-align: center; margin-top: 20px; font-size: 1.3em; color: #999; letter-spacing: 3px">UPPER</div>
                    <div style="clear: both"></div>
                    <div style="box-sizing: border-box; height: 460px; margin-top: 5px; margin-bottom: 5px; position: relative; " id='tooth-display'>
                        <div style="width: 50%; height: 50%; background-color: ghostwhite; display: inline-block; border-right: 1px solid #333; border-bottom: 1px solid #333"
                             ><div class="tooth-whole" id='tooth-1'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        1
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-2'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        2
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-3'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        3
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-4'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        4
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-5'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        5
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-6'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        6
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-7'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        7
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-8'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        8
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-A'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        A
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-B'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        B
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-C'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        C
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-D'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        D
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-E'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        E
                                    </div>
                                </div>
                            </div>

                        </div
                        ><div style="width: 50%; height: 50%; background-color: ghostwhite; display: inline-block; border-left: 1px solid #333; border-bottom: 1px solid #333">
                            <div class="tooth-whole" id='tooth-9'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        9
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-10'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        10
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-11'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        11
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-12'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        12
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-13'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        13
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-14'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        14
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-15'>

                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        15
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-16'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        16
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-F'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        F
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-G'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        G
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-H'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        H
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-I'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        I
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-J'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        J
                                    </div>
                                </div>
                            </div>
                        </div
                        ><div style="width: 50%; height: 50%; background-color: ghostwhite; display: inline-block; border-right: 1px solid #333; border-top: 1px solid #333">
                            <div class="tooth-whole" id='tooth-25'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        25
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-26'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        26
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-27'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        27
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-28'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        28
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-29'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        29
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-30'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        30
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-31'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                       31
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-32'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        32
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-P'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        P
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-Q'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        Q
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-R'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        R
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-S'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        S
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-T'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        T
                                    </div>
                                </div>
                            </div>
                        </div
                        ><div style="width: 50%; height: 50%; background-color: ghostwhite; display: inline-block; border-left: 1px solid #333; border-top: 1px solid #333">
                            <div class="tooth-whole" id='tooth-17'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        17
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-18'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        18
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-19'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        19
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-20'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        20
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-21'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        21
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-22'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        22
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-23'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        23
                                    </div>
                                </div>
                            </div>
                            <div class="tooth-whole" id='tooth-24'>
                                <div class="tooth-outer">
                                    <div class='tooth-cross'
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="tooth-inner">
                                        24
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-K'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        K
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-L'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        L
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-M'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        M
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-N'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        N
                                    </div>
                                </div>
                            </div>
                            <div class="baby-tooth-whole" id='tooth-O'>
                                <div class="baby-tooth-outer">
                                    <div class='baby-tooth-cross'
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666; border-bottom: 1px solid #666"></div
                                        ><div class='baby-tooth-cross-section' style="border-right: 1px solid #666;"></div
                                        ><div class='baby-tooth-cross-section' style="border-left: 1px solid #666;"></div
                                    ></div>
                                    <div class="baby-tooth-inner">
                                        O
                                    </div>
                                </div>
                            </div>

                        </div
                    ></div>
                    <div style="clear: both"></div>
                    <div style="text-align: center; font-size: 1.3em; color: #999; letter-spacing: 3px">LOWER</div>
                    <div style="margin-top: 20px">Findings:</div>
                    <div>
                        <textarea name="patient_findings" id="patient_findings-{$window_id}" style="width: 98%; height: 100px; overflow-x: hidden; overflow-y: auto" class="form-field"
                        ></textarea>
                    </div>
                    <div style="margin-top: 30px">Recommendations:</div>
                    <div>
                        <textarea name="patient_recommendations" id="patient_recommendatinos-{$window_id}" style="width: 98%; height: 100px; overflow-x: hidden; overflow-y: auto" class="form-field"
                        ></textarea>
                    </div>
                    <div style="margin-top: 30px; border-bottom: 1px solid #333">Services Rendered</div>
                    <div>
                        <table style="width: 100%;">
                            <tr>
                                <td width='33%'>
                                    <input type="checkbox" name="service_d0272" id="service_d0272-{$window_id}" value='Y' />
                                    2 BWX [D0272]
                                </td>
                                <td width='33%'>
                                    <input type="checkbox" name="service_d0274" id="service_d0274-{$window_id}" value='Y' />
                                    4 BWX [D0274]
                                </td>
                                <td width='33%'>
                                    <input type="checkbox" name="service_d1206" id="service_d1206-{$window_id}" value='Y' />
                                    FI2 [D1206]
                                </td>
                            </tr>
                            <tr>
                                <td width='33%'>
                                    <input type="checkbox" name="service_d1330" id="service_d1330-{$window_id}" value='Y' />
                                    OHI [D1330]
                                </td>
                                <td width='33%'>
                                    <input type="checkbox" name="service_d1120" id="service_d1120-{$window_id}" value='Y' />
                                    C Prophy [D1120]
                                </td>
                                <td width='33%'>
                                    <input type="checkbox" name="service_d0330" id="service_d0330-{$window_id}" value='Y' />
                                    Pano [D0330]
                                </td>
                            </tr>
                            <tr>
                                <td width='33%'>
                                    <input type="checkbox" name="service_d0150" id="service_d0150-{$window_id}" value='Y' />
                                    Comprehensive Exam [D0150]
                                </td>
                                <td width='33%'>
                                    <input type="checkbox" name="service_d1351" id="service_d1351-{$window_id}" value='Y' />
                                    Sealants [D1351]
                                </td>
                                <td width='33%'>
                                    <input type="checkbox" name="service_d0190" id="service_d0190-{$window_id}" value='Y' />
                                    Screening [D0190]
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="checkbox" name="service_d1310" id="service_d1310-{$window_id}" value='Y' />
                                    Nutritional Counseling [D1310]
                                </td>
                                <td>
                                    <input type="checkbox" name="service_d0140" id="service_d0140-{$window_id}" value='Y' />
                                    Limited Exam [D0140]
                                </td>
                                <td>
                                    <input type="checkbox" name="service_d0350" id="service_d0350-{$window_id}" value='Y' />
                                    Intra Oral Photos [D0350]
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <input type="checkbox" name="service_d1110" id="service_d1110-{$window_id}" value='Y' />
                                    Prophy [D1110]
                                </td>
                                <td>
                                    <input type="checkbox" name="service_d9995" id="service_d9995-{$window_id}" value='Y' />
                                    Synchronous Tele-Dentistry [D9995]
                                </td>
                                <td>
                                    <input type="checkbox" name="service_d9996" id="service_d9996-{$window_id}" value='Y' />
                                    Asynchronous Tele-Dentistry [D9996]
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="checkbox" name="service_d1091" id="service_d1091-{$window_id}" value='Y' />
                                    Assessment [D1091]
                                </td>
                                <td>&nbsp;
                                </td>
                                <td>&nbsp;
                                </td>
                            </tr>
                            
                        </table>
                    </div>
                    <br />
                    <div>
                        {if (($hygienist) && (!isset($data['hygienist_signature'])))}
                            <div id="hygienist-signature-box" style="display: none">
                                Hygienist:
                                <div id="hygienist-signature-area" style="width: 260px; display: inline-block; border-bottom: 1px solid #333">
                                &nbsp;
                                </div>
                            </div>
                            <button id="hygienist-sign-button" onclick="Argus.dental.consultation.pin('hygienist','{$window_id}','{$form_id}'); return false;" class="dental-signature-button" style="float: left; ">Hygienist Signature</button>
                        {else}

                            Hygienist:
                            <div style="width: 260px; display: inline-block; border-bottom: 1px solid #333">
                            {if (isset($data['hygienist_signature']) && $data['hygienist_signature'])}
                                {$data['hygienist_signature']}
                            {/if}
                            &nbsp;
                            </div>

                        {/if}
                        <div style="width: 400px; float: right">
                        {if (($dentist) && (!isset($data['dentist_signature'])))}
                            <div id="dentist-signature-box" style="display: none">
                                Dentist:
                                <div id="dentist-signature-area" style="width: 320px; display: inline-block; border-bottom: 1px solid #333">
                                &nbsp;
                                </div>
                            </div>
                            <button id="dentist-sign-button" onclick="Argus.dental.consultation.pin('dentist','{$window_id}','{$form_id}'); return false" class="dental-signature-button" style="float: right; ">Dentist Signature</button>
                        {else}

                            Dentist:
                            <div style="width: 320px; display: inline-block; border-bottom: 1px solid #333">
                            {if (isset($data['dentist_signature']) && $data['dentist_signature'])}
                                {$data['dentist_signature']}
                            {/if}
                            &nbsp;
                            </div>

                        {/if}
                        </div>
                        <div style="clear: both"></div>
                    </div>
                    <br />
                    <div style="text-align: center">
                        <b>Argus Dental &amp; Vision, Inc.</b>, 4919 W. Laurel Street, Tampa, FL, 33607 (Toll Free 877.864.0625)
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<div id="dental-consultation-footer" style="text-align: center; padding: 5px; background-color: #333">
    <button style="padding-right: 10px; padding-left: 10px; float: right" onclick="Argus.dental.consultation.print('{$form_id}')">Print</button>
    <button onclick="Argus.dental.consultation.start('{$form_id}'); Argus.teledentistry.open.facetime('{$form_id}')">Start Consultation</button>
 </div>
<script type='text/javascript'>
    (function () {
        var win = Desktop.window.list['{$window_id}'];
        win.resize = function () {
            var h = win.content.height() - $E('dental-consultation-footer').offsetHeight - $E('dental-consultation-header').offsetHeight;
            $('#dental-consultation-body').height(h);
        };
        win.close = function () {
            if (confirm('Do you want to end the consultation?')) {
                Argus.teledentistry.waiting = false;
                Argus.dashboard.socket.emit('patientLeftWaitingRoom', { });
                Argus.dashboard.socket.removeListener('teledentistryToothChosen',Argus.teledentistry.form.teeth.pick);
                Argus.dashboard.socket.removeListener('newDentalSnapshot',Argus.teledentistry.form.snapshots);
                Argus.dashboard.socket.removeListener('teledentistryFormUpdate',Argus.teledentistry.form.set);
                Argus.dashboard.socket.removeListener('newTeledentistryXray',Argus.teledentistry.form.xrays.claim);
                Argus.dashboard.socket.removeListener('currentTooth',Argus.teledentistry.form.teeth.setCurrent);
                Argus.dashboard.socket.removeListener('inbound'+Argus.dental._formId()+'FacetimeCall',Argus.teledentistry.form.facetime);
                Argus.dashboard.socket.removeListener('dentalConsultationSigned',Argus.teledentistry.form.signed);                
                Argus.dental._formId(false);
                $('#dental-waiting-room-alert').css('opacity','0.4');
               // (new EasyAjax('/dental/teledentistry/closeroom')).add('room',room).then(function () {

               // }).post();
            }
            return true;
        };
        win.resize();
    })();
    //Argus.dashboard.socket.emit('registerListeners', [ 'listener1','listener2']);
    Argus.teledentistry.form = (function (form_id, window_id) {
        Argus.dental._formId(form_id);
        Argus.dental._windowId(window_id);
        return  {
            dateFormat: function (dval) {
                if (dval) {
                    var d = dval.split('-');
                    dval = d[1]+'/'+d[2]+'/'+d[0];
                }
                return dval;
            },            
            age:   function (box,win_id) {
                var d = box.value.split('/');
                if (d.length == 3) {
                    var birthday = new Date(d[2],d[0]-1,d[1]);
                    var ageDifMs = Date.now() - birthday.getTime();
                    var ageDate = new Date(ageDifMs); // miliseconds from epoch
                    $('#patient_age-'+window_id).val(Math.abs(ageDate.getUTCFullYear() - 1970)).change();
                }
            },
            check: function () {
                var win_id = Argus.dental._windowId();
                if ($('#hygienist_signature-'+win_id).val() && $('#dentist_signature-'+win_id).val()) {
                    if (($('#status-'+win_id).val()!=='C') && confirm('Would you like to mark this consultation complete? ')) {
                        (new EasyAjax('/dental/consultation/status')).add('form_id',form_id).add('status','C').then(function (response) {
                            $('#status-'+win_id).val('C');
                            Argus.dashboard.socket.emit('messageRelay',{ "form_id": form_id, "status": "C", "message": 'dentalConsultationStatusChange' });
                        }).post();
                    }
                }
            },
            snapshots: function () {
                (new EasyAjax('/dental/consultation/snapshots')).add('form_id',form_id).add('window_id',window_id).then(function (response) {
                    $('#dental-form-snapshots-tab').html(response);
                }).post();
            },
            facetime: function (data) {
                if (data && data.user_id != Branding.id) {
                } else {
                    console.log('Skipping my own invite to facetime');
                }
            },
            signed: function (data) {
                if (data.form_id == Argus.dental._formId()) {
                    var win_id = Argus.dental._windowId();
                    $('#'+data.role+'-sign-button').css('display','none');
                    $('#'+data.role+'-signature-box').css('display','inline-block');
                    $('#'+data.role+'-signature-area').html(data.signature);
                    $('#'+data.role+'-signature-'+win_id).val(data.signature).change();
                    Argus.teledentistry.form.check();
                }
            },
            xrays: {
                claim: function (data) {
                    if (data && data.member_id && (data.member_id == $('#member_id-'+window_id).val()) && $E('dental-form-xray-list'))  {
                        (new EasyAjax('/dental/teledentistry/claim')).add('form_id',form_id).add("member_id",data.member_id).then(function (response) {
                            $('#dental-form-xray-list').html(response);
                        }).post();
                    }
                },
                list: function () {
                    (new EasyAjax('/dental/teledentistry/xrays')).add('form_id',form_id).add("member_id",$('#member_id-'+window_id).val()).then(function (response) {
                        $('#dental-form-xray-list').html(response);
                    }).post();
                }
            },
            load: function () {
                let form = $E('new-dental-consultation-form-'+window_id);
                {foreach from=$data item=val key=var}
                    Argus.tools.value.set(form,'','{$var}','{$val|escape:javascript}');
                {/foreach}
                Argus.teledentistry.form.xrays.list();
                if ($('#patient_dob-{$window_id}').val()) {
                    $('#patient_dob-{$window_id}').val(Argus.teledentistry.form.dateFormat($('#patient_dob-{$window_id}').val()));
                }
                if ($('#consultation_date-{$window_id}').val()) {
                    $('#consultation_date-{$window_id}').val(Argus.teledentistry.form.dateFormat($('#consultation_date-{$window_id}').val()));
                }                   
                $('#patient_dob-{$window_id}').datepicker();
                $('#consultation_date-{$window_id}').datepicker();
                
            },
            save: function (evt) {
                let ao = new EasyAjax('/dental/consultation/save');
                ao.add('id',form_id).add(evt.target.name,ao.getValue(evt.target)).then(function () {
                }).post();
                Argus.dashboard.socket.emit('teledentistryFormChange', { "form_id": form_id, "field": evt.target.name, "value": ao.getValue(evt.target), "user": Argus.teledentistry._room() });
            },
            update: function (evt) {
                Argus.dashboard.socket.emit('teledentistryFormChange', { "form_id": form_id, "field": evt.target.name, "value": evt.target.value, "user": Argus.teledentistry._room() });
            },
            set: function (data) {
                if (data.form_id == form_id) {
                    let form = $E('new-dental-consultation-form-'+window_id);
                    if (data.user !== Argus.teledentistry._room()) {
                        Argus.tools.value.set(form,'',data.field,data.value);
                    };
                }
            },
            listeners: function () {
                Argus.dashboard.socket.on('teledentistryToothChosen',Argus.teledentistry.form.teeth.pick);
                Argus.dashboard.socket.on('newDentalSnapshot',Argus.teledentistry.form.snapshots);
                Argus.dashboard.socket.on('teledentistryFormUpdate',Argus.teledentistry.form.set);
                Argus.dashboard.socket.on('newTeledentistryXray',Argus.teledentistry.form.xrays.claim);
                Argus.dashboard.socket.on('currentTooth',Argus.teledentistry.form.teeth.setCurrent);
                Argus.dashboard.socket.on('inbound'+form_id+'FacetimeCall',Argus.teledentistry.form.facetime);
                Argus.dashboard.socket.on('dentalConsultationSigned',Argus.teledentistry.form.signed);
                $('#new-dental-consultation-form-'+window_id).on('change',Argus.teledentistry.form.save);
                $('#new-dental-consultation-form-'+window_id).on('keypress',Argus.teledentistry.form.update);
                $('.tooth-whole').on('click',Argus.teledentistry.form.teeth.set);
                $('.baby-tooth-whole').on('click',Argus.teledentistry.form.teeth.set);
            },
            teeth: {
                current: false,
                setCurrent: function (data) {
                    if ((data.form_id == form_id) && data.tooth) {
                        if (data.currentTooth == Argus.teledentistry.form.teeth.current) {
                            Argus.teledentistry.form.teeth.reset(1);
                        } else {
                            Argus.teledentistry.form.teeth.reset();
                            $('#'+data.tooth).css('opacity',1.0);
                            Argus.teledentistry.form.teeth.current = data.tooth;
                        }
                    }
                },
                placeAdult: function (fromTooth, toTooth, fromDeg, radius, radian) {
                    var teeth = toTooth - fromTooth+2;
                    var deg   = Math.round(90/teeth);
                    for (var i=fromTooth; i<=toTooth; i++) {
                        fromDeg += deg;
                        tooth = $E('tooth-'+i);
                        tooth.style.left = (tooth.offsetLeft - (Math.cos(fromDeg*radian)*radius))+'px';
                        tooth.style.top  = (tooth.offsetTop  - (Math.sin(fromDeg*radian)*radius))+'px';
                    }
                },
                placeBaby: function (teeth, fromDeg, radius, radian) {
                    var deg = Math.round(90/(teeth.length+1));
                    for (var i=0; i<teeth.length; i++) {
                        fromDeg += deg;
                        tooth = $E('tooth-'+teeth[i]);
                        tooth.style.left = (tooth.offsetLeft - (Math.cos(fromDeg*radian)*radius))+'px';
                        tooth.style.top  = (tooth.offsetTop  - (Math.sin(fromDeg*radian)*radius))+'px';
                    }
                },
                center: function (radian) {
                    var widthMid  = Math.round($E('tooth-display').offsetWidth/2);
                    var heightMid = Math.round($E('tooth-display').offsetHeight/2);
                    var tooth;
                    var babyTeeth = 'ABCDEFGHIJKLMNOPQRST';
                    for (var i=0; i<babyTeeth.length; i++) {
                        tooth = $E('tooth-'+babyTeeth.substr(i,1));
                        if (tooth) {
                            tooth.style.left = (widthMid - Math.round(tooth.offsetWidth/2))+'px';
                            tooth.style.top  = (heightMid - Math.round(tooth.offsetHeight/2))+'px';
                        }
                    }
                    for (var i=1; i<33; i++) {
                        tooth = $E('tooth-'+i);
                        tooth.style.left = (widthMid - Math.round(tooth.offsetWidth/2))+'px';
                        tooth.style.top  = (heightMid - Math.round(tooth.offsetHeight/2))+'px';;
                    }
                    return radian;
                },
                render: function (radian) {
                    Argus.teledentistry.form.teeth.placeAdult(1,8,0,200,radian);
                    Argus.teledentistry.form.teeth.placeAdult(9,16,90,200,radian);
                    Argus.teledentistry.form.teeth.placeAdult(17,24,180,200,radian);
                    Argus.teledentistry.form.teeth.placeAdult(25,32,270,200,radian);
                    Argus.teledentistry.form.teeth.placeBaby(['A','B','C','D','E'],0,145,radian);
                    Argus.teledentistry.form.teeth.placeBaby(['F','G','H','I','J'],90,145,radian);
                    Argus.teledentistry.form.teeth.placeBaby(['K','L','M','N','O'],180,145,radian);
                    Argus.teledentistry.form.teeth.placeBaby(['P','Q','R','S','T'],270,145,radian);
                },
                set: function (evt) {
                    var node = evt.target;
                    var id   = false;
                    while (!id && node.parentNode) {
                        id   = (node.parentNode && node.parentNode.id) ? node.parentNode.id : false;
                        node = node.parentNode;
                    }
                    if (id) {
                        if (id === Argus.teledentistry.form.teeth.current) {
                            Argus.teledentistry.form.teeth.reset(1);
                        } else {
                            Argus.teledentistry.form.teeth.reset();
                            $('#'+id).css('opacity',1.0);
                            Argus.teledentistry.form.teeth.current = id;
                        }
                        Argus.dashboard.socket.emit('teledentistryToothPicked',{ 'user': Argus.teledentistry._room(), 'form_id': form_id, 'tooth': id });
                    }
                },
                reset: function (val) {
                    val = (val) ? val : 0.3;
                    Argus.teledentistry.form.teeth.current = false;
                    $('.tooth-whole').css('opacity',val);
                    $('.baby-tooth-whole').css('opacity',val);
                },
                pick: function (data) {
                    if (data && data.user && (data.user !== Argus.teledentistry._room())) {
                        if (data.tooth === Argus.teledentistry.form.teeth.current) {
                            Argus.teledentistry.form.teeth.reset(1);
                        } else {
                            Argus.teledentistry.form.teeth.reset();
                            Argus.teledentistry.form.teeth.current = data.tooth;
                            $('#'+data.tooth).css('opacity',1.0);
                        }
                    }
                }
            }
        };
    })('{$form_id}','{$window_id}');
    Argus.dashboard.socket.emit('currentToothCheck', { 'form_id': '{$form_id}' });
    Argus.teledentistry.form.listeners();
    Argus.teledentistry.form.load();
    Argus.teledentistry.form.teeth.render(Argus.teledentistry.form.teeth.center(Math.PI/180));
    Argus.teledentistry.form.check();
    (function (win_id) {
        var win = Desktop.window.list[win_id];
        return function () {
            win._scroll(false);
            $('#xray-upload-layer-{$window_id}').css('display','block').css('height','100%').css('width','100%');
        };
    })('{$window_id}');
    Argus.teledentistry.form.snapshots();
    var tabs = new EasyTab('dental-consultation-header');
    tabs.add('Form',null,'dental-form-tab',120);
    tabs.add('Snapshots',function () {
        var name = $('#member_name-{$window_id}').val();
        var member_id = $('#member_id-{$window_id}').val();
        $('#form-scan-patient-id-{$window_id}').html(((name) ? name : '') + ((member_id) ? ' ['+member_id+']' : ''));
    },'dental-form-snapshots-tab',120);
    tabs.add('X-Rays',Argus.teledentistry.form.xrays.list,'dental-form-xray-tab',120);
    tabs.tabClick(0);
</script>