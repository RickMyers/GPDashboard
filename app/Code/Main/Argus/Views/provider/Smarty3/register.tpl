{assign var=data value=$provider_form->load()}
{assign var=id value=$data.id}
{assign var=form_id value=$data.form_id}
{assign var=make_readonly value=false}
{if ($data.status == 'S')}
    {assign var=make_readonly value=true}
{/if}<!DOCTYPE html>
    <head>
        <!--
           IF THIS THING IS NOT IN NEW STATUS
        PERSON MUST HAVE ROLE OF "Application Reviewer"
        AND BE LOGGED IN
        ELSE GET SENT TO THE MAIN SIGN-IN PAGE
        -->
        <title>Provider Register | Argus</title>
        <link rel="shortcut icon" href="/images/argus/favicon.png" />
        <link rel='stylesheet' href='/css/bootstrap'/>
        <link rel='stylesheet' href='/css/theme'/>
        <link rel="stylesheet" href="/css/jqueryui" />
        <link rel="stylesheet" href="/css/widgets" />
        <style type="text/css">
            .text-input-field {
                width: 90%; padding: 2px; background-color: lightcyan; border: 1px solid #777; color: #333
            }
            .full {
                width: 100%
            }
            .threequarter {
                    width: 74.5%; display: inline-block; border-right: 1px solid #777
            }
            .half {
                width: 49.7%; display: inline-block; border-right: 1px solid #777
            }
            .third {
                width: 33%; display: inline-block; border-right: 1px solid #777
            }
            .quarter {
                width: 24.7%; display: inline-block; border-right: 1px solid #777
            }
            .fifth {
                width: 19.5%; display: inline-block; border-right: 1px solid #777
            }
            .sixth {
                width: 16%; display: inline-block; border-right: 1px solid #777
            }
            .seventh {
                width: 13.5%; display: inline-block; border-right: 1px solid #777
            }
            .form-tab {
                display: none; padding-top: 25px
            }
            .provider-form {
                width: 92%; margin-left: auto; margin-right: auto; border-collapse: collapse; border: 1px solid #777;
            }
            .provider-form-header {
                background-color: #8DB3E0; font-weight: bold; font-size: 1.1em; padding: 5px 0px 5px 0px
            }
            .provider-cell-header {
                font-family: monospace; font-size: .9em; padding-left: 5px
            }
            .provider-cell-field {
                padding-left: 25px; padding-top: 5px; font-family: sans-serif; font-size: .9em
            }
            .provider-row {
                border-bottom: 1px solid #777; border-collapse: collapse; padding-bottom: 2px
            }
            .td-spacer {
                padding-left: 2px; padding-right: 15px
            }
            #form-content-layer {
                width: 75%; min-width: 1024px; max-width: 1750px;  margin-left: auto; margin-right: auto; overflow: hidden; background-color: rgba(248,248,255,.9);
                border-left: 1px solid #333; border-right: 1px solid #333; padding-left: 10px; padding-right: 10px
            }
            #argus-provider-banner {
                height: 50px; background-color: #333;
            }
            #argus-provider-footer {
                height: 20px; background-color: #333; color: ghostwhite; font-size: .9em; text-align: center; padding-top: 1px
            }
            #provider-form-instructions-layer {
                width: 19%; float: right; padding: 10px; text-align: justify; font-size: 1.2em
            }
            #provider-form-layer {
                width: 79%; border-right: 1px solid silver; overflow: auto;
            }
        </style>
        <script type="text/javascript" src='/js/jquery'></script>
        <script type='text/javascript' src='/js/bootstrap'></script>
        <script type='text/javascript' src='/js/common'></script>
        <script type='text/javascript' src='/js/jqueryui'></script>
        <script type='text/javascript' src='/js/widgets'></script>
        <script type="text/javascript">
            var Argus = {
                "provider": {
                    "view": function (form_id,field) {
                        if (form_id && field) {
                            $('#view_form_id').val(form_id);
                            $('#view_form_field').val(field);
                            $E('view-attachment-form').submit();
                        }
                    },
                    "readonly": function () {
                        var f = $E('new-provider-registration-form');
                        for (var i=0, fLen=f.length;i<fLen;i++){
                            if ((f.elements[i].type && (f.elements[i].type == 'checkbox')) || (f.elements[i].type && (f.elements[i].type == 'radio'))) {
                                f.elements[i].disabled = true;
                            } else {
                                f.elements[i].readOnly = true;
                            }
                        }
                    },
                    "toggle": function (cb) {
                        var disabled = (cb && cb.checked) ? false : true;
                        $('#submit-form-data-1').attr('disabled',disabled);
                        $('#submit-form-data-2').attr('disabled',disabled);
                    },
                    "submit": function () {
                        if (confirm("Do you wish to submit your registration form for review?")) {
                            (new EasyAjax('/argus/provider/submit')).add('id','{$id}').add('form_id','{$form_id}').then(function (response) {
                                alert("Thank you for your submission!");
                                window.location.href = "/";
                            }).post();
                        }
                    },
                    "isNodeList": function(nodes) {
                        var stringRepr = Object.prototype.toString.call(nodes);

                        return typeof nodes === 'object' &&
                            /^\[object (HTMLCollection|NodeList|Object)\]$/.test(stringRepr) &&
                            (typeof nodes.length === 'number') &&
                            (nodes.length === 0 || (typeof nodes[0] === "object" && nodes[0].nodeType > 0));
                    },                        
                    "set": function (form,field_name,value) {
                        form    = $E(form);
                        field   = form.elements[field_name];
                        if (Argus.provider.isNodeList(field) || NodeList.prototype.isPrototypeOf(field)) {                            
                            for (var i=0; i<field.length; i++) {
                                field[i].checked = field[i].value == value;
                            };
                        } else {
                            if (field && field.type) {
                                switch (field.type.toLowerCase()) {
                                    case "checkbox" :
                                        if (value == 'on') {
                                            field.checked = true;
                                        } else {
                                            field.checked = (field.value == value);
                                        };
                                        break;
                                    default :
                                        try {
                                            $(field).val(value);
                                        } catch (ex) {
                                        }
                                        break;
                                }
                            } 
                        }
                    }
                }
            };
            $(window).resize(function () {
                var wh = (window.innerHeight || document.body.clientHeight || document.documentElement.clientHeight);
                var ww = (window.innerWidth || document.body.clientWidth || document.documentElement.clientWidth);
                var h =  (wh - $E('argus-provider-banner').offsetHeight - $E('argus-provider-footer').offsetHeight);
                $('#pin-entry-layer').height(wh-5);
                $('#form-content-layer').height(h);
                $('#provider-form-instructions-layer').height(h);
                $('#provider-form-layer').height(h);
                $('#uploading-overlay').height(wh);
                $('#uploading-overlay').width(ww);
            });
            $(document).ready(function () {
               $(window).resize();
               var tabs = new EasyTab('provider-form-tabs',120);
               tabs.add('Checklist',null,'provider-form-checklist-tab');
               tabs.add('Practice',null,'provider-form-practice-tab');
               tabs.add('Patient',null,'provider-form-patient-tab');
               tabs.add('Provider',null,'provider-form-provider-tab');
               tabs.add('Work History',null,'provider-form-work-history-tab');
               tabs.add('Questionnaire',null,'provider-form-questionnaire-tab');
               tabs.add('Release',null,'provider-form-release-tab');
               tabs.add('Additional Offices',null,'provider-form-additional-offices-tab');
               tabs.tabClick(0);
               Argus.provider.toggle($E('#confirm-form-information'));
               $('#providers_date_of_birth').datepicker();
               (new EasyAjax('/argus/provider/attachments')).add('id','{$id}').then(function (response) {
                   var attachments = JSON.parse(response);
                   for (var i=0; i<attachments.length; i++) {
                       var link = attachments[i].field+'_link';
                       $('#'+link).html('<a style="color: blue" href="#" onclick="Argus.provider.view(\''+attachments[i].form_id+'\',\''+attachments[i].field+'\');return false">'+$('#'+link).html()+'<span style="color: red" title="A document is attached to this field, click the link to view the document">*</span>');
                   }
                   
               }).post();
               {if ($make_readonly)}
                    Argus.provider.readonly();
               {/if}
               (new EasyEdits('/edits/argus/providerpin','provider-pin-form'));
                   
            });

        </script>
    </head>
    <body>
        <div style="position: absolute; display: none; top: 0px; left: 0px; width: 100%; background-color: rgba(50,50,50,.5); height: 500px; z-index: 99" id="pin-entry-layer">
            <table style="width: 100%; height: 100%">
                <tr>
                    <td>
                        <div style="padding: 20px; border-radius: 20px; background-color: ghostwhite; width: 500px; margin-left: auto; margin-right: auto; color: #333">
                            <form name="pin-entry-form" id="pin-entry-form" onsubmit="return false">
                                <fieldset><legend>Instructions</legend>
                                    Please enter the PIN (Personal Identification Number) that was sent to you with your registration form e-mail.  If you can not find the
                                    registration email, you may click <a href='#' onclick='return false'>here</a> to have it resent to you.<br /><br />
                                    Enter Pin: <input placeholder='######' maxlength='6' type='text' name='pin' id='pin' style='text-align: center; width: 100px; padding: 2px; background-color: lightcyan; color: #333; border: 1px solid #aaf' /><br /><br />
                                    <input type="button" value=" Cancel " style="float: right" onclick="$('#pin-entry-layer').css('display','none')" /><input type='button' value=' Submit ' name='provider-pin-submit-button' id="provider-pin-submit-button" />
                                </fieldset>
                            </form>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <form name="view-attachment-form" id="view-attachment-form" target="_BLANK" action='/argus/provider/view' method="post">
            <input type='hidden' name='id'  id="view_form_id" value="" />
            <input type='hidden' name='field' id="view_form_field" value="" />
        </form>
        <div style="position: absolute; top: 0px; left: 0px; display: none; background-color: rgba(100,100,100,.5)" id="uploading-overlay">
            <table style="width: 100%; height: 100%">
                <tr>
                    <td>
                        <div style="background-color: ghostwhite; font-size: 1em; color: #333; font-weight: bold; width: 400px; padding: 20px; border: 1px solid #999; border-radius: 20px; margin-left: auto; margin-right: auto; text-align: center">
                            <img height="70" src="/images/argus/inprogress.gif" title="Uploading Attachment" />
                            Uploading Attachment, Please Wait....
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div id="argus-provider-banner">
            <img src="/images/argus/argus_white.png" style="height: 45px; margin-top: 2px" /><span style='position: relative; top: 4px; margin-left: 25px; color: ghostwhite; font-size: 2.1em'> Provider Registration </span>
        </div>
        <div id="form-content-layer">
            <form name="new-provider-registration-form" id="new-provider-registration-form" onsubmit="return false">
                <input type='hidden' name='provider_form_id' id='provider_form_id' value='{$form_id}' />
            <div id="provider-form-instructions-layer"><div style='text-align: center; font-weight: bold'>Welcome to Argus New Provider Registration!</div>
                <br /><br />
                <b>Instructions</b>:<br /><br />Please fill out each section of this form to the best of your ability.  The option to submit the provider registration form
            is on the 'Release' tab.  By clicking on the "I attest" checkbox on the 'Release' tab, you are digitally signing and dating this form.
            <br /><br />
            For convenience, this form automatically saves your data as you fill each field, allowing you to enter the data across multiple sittings. You can return to this form and continue filling it out through the link in the e-mail that was sent to you.
            <br /><br />
            </div>
            <div id="provider-form-layer">

                <div id="provider-form-tabs" style="margin-top: 26px">

                </div>

                <!-- #################################################################################################### -->
                
                <div id="provider-form-checklist-tab" class="form-tab">
                    <br />
                    <center>
                    <h2>Checklist</h2>
                    </center>
                    <div style="width: 700px; margin-left: auto; margin-right: auto; font-size: 1.3em">
                    <br /><br />
                    <b>To ensure your application is processed as quickly as possible, please return the
                    following items</b>:<br /><br />
                    <ul>
                        <input type="checkbox" name="checklist_1" id="checklist_1" value="Y" /> Completed and signed Provider Application<br />
                        <input type="checkbox" name="checklist_2" id="checklist_2" value="Y" /> Completed and signed Provider Agreement<br />
                        <input type="checkbox" name="checklist_3" id="checklist_3" value="Y" />  Current copy of License<br />
                        <input type="checkbox" name="checklist_4" id="checklist_4" value="Y" />  Current copy of Federal DEA Certificate<br />
                        <input type="checkbox" name="checklist_5" id="checklist_5" value="Y" />  Current copy of Controlled Substance Registration (CSR) (as applicable)<br />
                        <input type="checkbox" name="checklist_6" id="checklist_6" value="Y" />  Current copy of Professional Malpractice Liability Certificate of Insurance<br />
                        <input type="checkbox" name="checklist_7" id="checklist_7" value="Y" />  Current copy of Board Certification (as applicable)<br />
                        <input type="checkbox" name="checklist_8" id="checklist_8" value="Y" />  Copy of Specialty diploma or certificate (as applicable)<br />
                    </ul>
                    </div>
                </div>
                
                <!-- #################################################################################################### -->
                
                <div id="provider-form-practice-tab" class="form-tab">
                    <div class="provider-form">
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Practice Information
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="provider-cell-header">
                                Practice Type (Select One)
                            </div>
                            <div class="provider-cell-field">
                                <table>
                                <tr><td class='td-spacer'><input type='radio' name='practice_type' id='practice_type_solo' value='Solo' /></td><td class='td-spacer'>Solo</td>
                                    <td class='td-spacer'><input type='radio' name='practice_type' id='practice_type_partnership' value='Partnership' /></td><td class='td-spacer'>Partnership</td>
                                    <td class='td-spacer'><input type='radio' name='practice_type' id='practice_type_professional' value='Professional Corporation' /></td><td class='td-spacer'>Professional Corporation</td>
                                    <td class='td-spacer'><input type='radio' name='practice_type' id='practice_type_other' value='Other' /></td><td class='td-spacer'> Other
                                        <input type='text'  name='practice_type_other_value' id='practice_type_other_value' class="text-input-field" style='width: 160px' /></td></tr>
                                </table>
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="provider-cell-header">
                                Practice wishes to participant in:
                            </div>
                            <div class="provider-cell-field">
                                <table>
                                <tr><td class='td-spacer'><input type='radio' name='practice_participant_in' id='practice_participant_in_commercial' value='Commercial' /></td><td class='td-spacer'>Commercial</td>
                                    <td class='td-spacer'><input type='radio' name='practice_participant_in' id='practice_participant_in_medicaid' value='Medicaid' /></td><td class='td-spacer'>Medicaid</td>
                                    <td class='td-spacer'><input type='radio' name='practice_participant_in' id='practice_participant_in_advantage' value='Medicaid Advantage' /></td><td class='td-spacer'>Medicaid Advantage</td>
                                    <td class='td-spacer'><input type='radio' name='practice_participant_in' id='practice_participant_in_fhc' value='Florida Healthy Kids' />Florida Healthy Kids</td></tr>
                                </table>                                
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="provider-cell-header">
                                Provider's Name:
                            </div>
                            <div class="provider-cell-field">
                                <input type="text" name="providers_name" id="providers_name" class="text-input-field" />
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="provider-cell-header">
                                Corporation Name (if applicable):
                            </div>
                            <div class="provider-cell-field">
                                <input type="text" name="corporation_name" id="corporation_name" class="text-input-field" />
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    TIN:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="tin" id="tin" class="text-input-field" />
                                </div>
                            </div>
                            <div class="half">
                                <div class="provider-cell-header">
                                    Group NPI (NPI-2, if applicable):
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="group_npi" id="group_npi" class="text-input-field" />
                                </div> 
                            </div>
                        </div>    
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Practice Name:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="practice_name" id="practice_name" class="text-input-field" />
                                </div>
                            </div>
                        </div>   
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    <div style="float: right; margin-right: 40px">
                                        <input type="checkbox" name="multiple_mailing_addresses" id="multiple_mailing_addresses" value="Yes" />
                                        Check here if multiple billing addresses
                                    </div>                                    
                                    Mailing Address: 
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="mailing_address" id="mailing_address" class="text-input-field" />
                                </div>
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Billing Address: 
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="billing_address_1" id="billing_address_1" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>  
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Billing Address: 
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="billing_address_2" id="billing_address_2" class="text-input-field" />
                                </div>
                            </div>                            
                        </div> 
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Please indicate address to send signed Provider Agreement and Welcome packet:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="send_packet_to_address" id="send_packet_to_address" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>                           
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Billing Address (if different from above): 
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="other_billing_address" id="other_billing_address" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>    
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Business Contact E-Mail:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="business_contact_email" id="business_contact_email" class="text-input-field" />
                                </div>
                            </div>                             
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Business Contact Phone
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="business_contact_phone" id="business_contact_phone" class="text-input-field" />
                                </div>
                            </div>                             
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Business Contact Fax
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="business_contact_fax" id="business_contact_fax" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>   
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Credentialing Contact E-Mail:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="credentialing_contact_email" id="credentialing_contact_email" class="text-input-field" />
                                </div>
                            </div>                             
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Credentialing Contact Phone
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="credentialing_contact_phone" id="credentialing_contact_phone" class="text-input-field" />
                                </div>
                            </div>                             
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Credentialing Contact Fax
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="credentialing_contact_fax" id="credentialing_contact_fax" class="text-input-field" />
                                </div>
                            </div>   
                        </div>                         
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Office Locations <div style="font-size: .9em; margin-left: 20px; display: inline-block">Please provide information for only those locations who will participate with Argus</div>
                            </div>
                        </div>  
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Primary Office Location
                                </div>
                                <div class="provider-cell-field">
                                    <input type="checkbox" name="additional_office_locations" id="additional_office_locations" value="Yes" /> Check here for additional office locations, fill out locations on the 'Additional Offices' tab
                                </div>
                            </div>                            
                        </div> 
                        <div style="border: 1px solid #333"></div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Practice Name
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="office_practice_name_1" id="office_practice_name_1" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Complete Address (Street, City, State, Zip Code)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="office_practice_address_1" id="office_practice_address_1" class="text-input-field" />
                                </div>
                            </div>                            
                        </div> 
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Office Manager:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="office_practice_manager_1" id="office_practice_manager_1" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    E-Mail Address:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="office_practice_email_1" id="office_practice_email_1" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Phone:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="office_practice_phone_1" id="office_practice_phone_1" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Fax:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="office_practice_fax_1" id="office_practice_fax_1" class="text-input-field" />
                                </div>
                            </div>                             
                        </div> 
                        <div style="border: 1px solid #333"></div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Practice Name
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="office_practice_name_2" id="office_practice_name_2" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Complete Address (Street, City, State, Zip Code)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="office_practice_address_2" id="office_practice_address_2" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>                         
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Office Manager:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="office_practice_manager_2" id="office_practice_manager_2" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    E-Mail Address:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="office_practice_email_2" id="office_practice_email_2" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Phone:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="office_practice_phone_2" id="office_practice_phone_2" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Fax:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="office_practice_fax_2" id="office_practice_fax_2" class="text-input-field" />
                                </div>
                            </div>                             
                        </div> 
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Hours of Operation
                            </div>
                        </div>    
                        <div class="provider-row">
                            <div class="seventh">
                                <div class="provider-cell-header">
                                   Monday
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="hours_of_operation_on_monday" id="hours_of_operation_on_monday" class="text-input-field" />
                                </div>
                            </div>  
                            <div class="seventh">
                                <div class="provider-cell-header">
                                   Tuesday
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="hours_of_operation_on_tuesday" id="hours_of_operation_on_tuesday" class="text-input-field" />
                                </div>
                            </div>  
                            <div class="seventh">
                                <div class="provider-cell-header">
                                   Wednesday
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="hours_of_operation_on_wednesday" id="hours_of_operation_on_wednesday" class="text-input-field" />
                                </div>
                            </div>  
                            <div class="seventh">
                                <div class="provider-cell-header">
                                   Thursday
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="hours_of_operation_on_thursday" id="hours_of_operation_on_thursday" class="text-input-field" />
                                </div>
                            </div>  
                            <div class="seventh">
                                <div class="provider-cell-header">
                                   Friday
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="hours_of_operation_on_friday" id="hours_of_operation_on_friday" class="text-input-field" />
                                </div>
                            </div>  
                            <div class="seventh">
                                <div class="provider-cell-header">
                                   Saturday
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="hours_of_operation_on_saturday" id="hours_of_operation_on_saturday" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="seventh">
                                <div class="provider-cell-header">
                                   Sunday
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="hours_of_operation_on_sunday" id="hours_of_operation_on_sunday" class="text-input-field" />
                                </div>
                            </div>                              
                        </div>  
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Name of Provider(s) at this Location, INCLUDING THE APPLICANT. Please provide Medicaid numbers for each provider, as applicable
                                </div>
                                <div class="provider-cell-field">
                                    <table width="80%">
                                        <tr>
                                            <td>1. <input type="text" name="provider_at_location_1" id="provider_at_location_1" class="text-input-field" /></td>
                                            <td>2. <input type="text" name="provider_at_location_2" id="provider_at_location_2" class="text-input-field" /></td>
                                        </tr>
                                        <tr>
                                            <td>3. <input type="text" name="provider_at_location_3" id="provider_at_location_3" class="text-input-field" /></td>
                                            <td>4. <input type="text" name="provider_at_location_4" id="provider_at_location_4" class="text-input-field" /></td>
                                        </tr>                                        
                                    </table>
                                </div>
                            </div>                            
                        </div>   
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Please complete if different from the above Practice Information
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Billing Address for this Location (Street, City, State, Zip Code):
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="different_billing_address" id="different_billing_address" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>  
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    TIN for this Location (if different, please submit additional W-9):
                                </div>
                                <div class="provider-cell-field">
                                    <table width="80%">
                                        <tr>
                                            <td>
                                                <input type="text" name="different_tin" id="different_tin" class="text-input-field" /></td>
                                            <td>
                                                <table>
                                                    <tr>
                                                        <td><span id="optional_w9_form_link">W-9</span>:</td> 
                                                        <td>  <input type="file" placeholder="Optional W-9" name="optional_w9_form" id="optional_w9_form"/></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>                            
                        </div>                          
                    </div>
                    <br /><br /><br /><br />
                </div>

                <!-- #################################################################################################### -->

                <div id="provider-form-patient-tab" class="form-tab">
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Patient Relation Services
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Languages Spoken By Provider:
                                </div>
                                <div class="provider-cell-field">
                                    <table width="90%">
                                        <tr>
                                            <td width="20%"><input type="checkbox" name="provider_speaks_english" id="provider_speaks_english" value="Yes" /> English</td>
                                            <td width="20%"><input type="checkbox" name="provider_speaks_spanish" id="provider_speaks_spanish" value="Yes" /> Spanish</td>
                                            <td width="20%"><input type="checkbox" name="provider_speaks_french" id="provider_speaks_french" value="Yes" /> French</td>
                                            <td><input type="checkbox" name="provider_speaks_other" id="provider_speaks_other" value="Yes" />
                                                <input type="text" name="provider_speaks_other_language" id="provider_speaks_other_language" class="text-input-field" placeholder="Other Language" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>                            
                        </div>  
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Languages Spoken By Staff:
                                </div>
                                <div class="provider-cell-field">
                                    <table width="90%">
                                        <tr>
                                            <td width="20%"><input type="checkbox" name="staff_speaks_english" id="staff_speaks_english" value="Yes" /> English</td>
                                            <td width="20%"><input type="checkbox" name="staff_speaks_spanish" id="staff_speaks_spanish" value="Yes" /> Spanish</td>
                                            <td width="20%"><input type="checkbox" name="staff_speaks_french" id="staff_speaks_french" value="Yes" /> French</td>
                                            <td><input type="checkbox" name="staff_speaks_other" id="staff_speaks_other" value="Yes" />
                                                <input type="text" name="staff_speaks_other_language" id="staff_speaks_other_language" class="text-input-field" placeholder="Other Language" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>                            
                        </div>  
                        <div class="provider-row">
                            <div class="third">
                                <div class="provider-cell-header">
                                    Accepts Patients with Disabilities
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="accepts_patients_with_disabilities" id="accepts_patients_with_disabilities_yes" value="Yes" /> Yes 
                                    <input type="radio" name="accepts_patients_with_disabilities" id="accepts_patients_with_disabilities_no" value="No" /> No
                                </div>
                            </div>                            
                            <div class="third">
                                <div class="provider-cell-header">
                                    TTY Available
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="tty_available" id="tty_available_yes" value="Yes" /> Yes 
                                    <input type="radio" name="tty_available" id="tty_available_no" value="No" /> No
                                </div>
                            </div>                            
                            <div class="third">
                                <div class="provider-cell-header">
                                    Signing Available
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="signing_available" id="signing_available_yes" value="Yes" /> Yes 
                                    <input type="radio" name="signing_available" id="signing_available_no" value="No" /> No
                                </div>
                            </div>                            
                        </div>  
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Handicap Accessible Office (ADA Compliant)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="handicap_accessible_office" id="handicap_accessible_office_yes" value="Yes" /> Yes 
                                    <input type="radio" name="handicap_accessible_office" id="handicap_accessible_office_no" value="No" /> No
                                </div>
                            </div>                            
                            <div class="half">
                                <div class="provider-cell-header">
                                    Handicap Parking Available
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="handicap_parking_available" id="handicap_parking_available_yes" value="Yes" /> Yes 
                                    <input type="radio" name="handicap_parking_available" id="handicap_parking_available_no" value="No" /> No
                                </div>
                            </div>                            
                        </div>   
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Accepting New Patients
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="accepting_new_patients" id="accepting_new_patients_yes" value="Yes" /> Yes 
                                    <input type="radio" name="accepting_new_patients" id="accepting_new_patients_no" value="No" /> No
                                </div>
                            </div>                            
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Age of Patients
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="age_of_patients_low" id="age_of_patients_low" class="text-input-field" style="width: 60px" /> to 
                                    <input type="text" name="age_of_patients_high" id="age_of_patients_high" class="text-input-field" style="width: 60px" />
                                </div>
                            </div>                            
                            <div class="half" style=" position: relative; top: -20px">
                                <div class="provider-cell-header">
                                    Average Time for Appointment
                                </div>
                                <div class="provider-cell-field">
                                    <table>
                                        <tr>
                                            <td><u>Urgent</u>: </td>
                                            <td>&nbsp;&nbsp;
                                                <input type="radio" name="urgent_appointment_wait" id="urgent_appointment_wait_1" value="Same Day" /> Same Day
                                                <input type="radio" name="urgent_appointment_wait" id="urgent_appointment_wait_2" value="1-2 Days" /> 1-2 Days
                                                <input type="radio" name="urgent_appointment_wait" id="urgent_appointment_wait_3" value="3+ Days" /> 3+ Days
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><u>New Patient</u>: </td>
                                            <td>&nbsp;&nbsp;
                                                <input type="radio" name="new_patient_appointment_wait" id="new_patient_appointment_wait_1" value="Same Day" /> Same Day
                                                <input type="radio" name="new_patient_appointment_wait" id="new_patient_appointment_wait_2" value="1-2 Days" /> 1-2 Days
                                                <input type="radio" name="new_patient_appointment_wait" id="new_patient_appointment_wait_3" value="3+ Days" /> 3+ Days
    
                                            </td>
                                        </tr>                                        
                                    </table>
                                </div>
                            </div>                            
                        </div> 
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Do you provide 24-hour coverage?
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="provider_24_hour_coverage" id="provider_24_hour_coverage_yes" value="Yes" /> Yes 
                                    <input type="radio" name="provider_24_hour_coverage" id="provider_24_hour_coverage_no" value="No" /> No
                                </div>
                            </div>                            
                            <div class="half">
                                <div class="provider-cell-header">
                                    <b>24-hour emergency number</b>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="emergency_number" id="emergency_number" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Patient Procedure Services <span style="font-size: .9em; padding-left: 15px">Please check all that are applicable</span>
                            </div>
                        </div>  
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Nitrous Oxide
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="nitrous_oxide" id="nitrous_oxide_yes" value="Yes" /> Yes 
                                    <input type="radio" name="nitrous_oxide" id="nitrous_oxide_no" value="No" /> No
                                </div>
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    IV Sedation
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="iv_sedation" id="iv_sedation_yes" value="Yes" /> Yes 
                                    <input type="radio" name="iv_sedation" id="iv_sedation_no" value="No" /> No
                                </div>
                            </div>   
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    General Anesthesia
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="general_anesthesia" id="general_anesthesia_yes" value="Yes" /> Yes 
                                    <input type="radio" name="general_anesthesia" id="general_anesthesia_no" value="No" /> No
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Oral Sedation
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="oral_sedation" id="oral_sedation_yes" value="Yes" /> Yes 
                                    <input type="radio" name="oral_sedation" id="oral_sedation_no" value="No" /> No
                                </div>
                            </div>                                   
                        </div> 
                        <div class="provider-row">
                            <div class="third">
                                <div class="provider-cell-header">
                                    <input type="checkbox" name="x_ray_not_applicable" id="x_ray_not_applicable" value="Yes" /> Check here if not applicable
                                </div>
                                <div class="provider-cell-field">
                                    &nbsp;
                                </div>
                            </div>
                            <div class="third">
                                <div class="provider-cell-header">
                                    Panoramic X-Ray
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="panoramic_xray" id="panoramic_xray_yes" value="Yes" /> Yes 
                                    <input type="radio" name="panoramic_xray" id="panoramic_xray_no" value="No" /> No
                                </div>
                            </div>   
                            <div class="third">
                                <div class="provider-cell-header">
                                    Intraoral X-Ray
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="intraoral_xray" id="intraoral_xray_yes" value="Yes" /> Yes 
                                    <input type="radio" name="intraoral_xray" id="intraoral_xray_no" value="No" /> No
                                </div>
                            </div> 
                        </div>
                        <div class="provider-row">
                            <div class="third">
                                <div class="provider-cell-header">
                                    <input type="checkbox" name="submissions_not_applicable" id="submissions_not_applicable" value="Yes" /> Check here if not applicable
                                </div>
                                <div class="provider-cell-field">
                                    &nbsp;
                                </div>
                            </div>
                            <div class="third">
                                <div class="provider-cell-header">
                                    Electronic Claims Submission:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="electronic_claims_submission" id="electronic_claims_submission_yes" value="Yes" /> Yes 
                                    <input type="radio" name="electronic_claims_submission" id="electronic_claims_submission_no" value="No" /> No
                                </div>
                            </div>   
                            <div class="third">
                                <div class="provider-cell-header">
                                    Digital Radiograph Submission
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="digital_radiograph_submission" id="digital_radiograph_submission_yes" value="Yes" /> Yes 
                                    <input type="radio" name="digital_radiograph_submission" id="digital_radiograph_submission_no" value="No" /> No
                                </div>
                            </div> 
                        </div>   
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Web Access:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="web_access" id="web_access_yes" value="Yes" /> Yes 
                                    <input type="radio" name="web_access" id="web_access_no" value="No" /> No
                                </div>
                            </div>
                            <div class="half" style="position: relative; top: -20px">
                                <div class="provider-cell-header">
                                    Sterilization Method:
                                </div>
                                <div class="provider-cell-field">
                                    <table width="90%">
                                        <tr>
                                            <td width="20%"><input type="checkbox" name="sterilization_method_autoclave" id="sterilization_method_autoclave" value="Yes" /> Autoclave</td>
                                            <td width="20%"><input type="checkbox" name="sterilization_method_chemiclave" id="sterilization_method_chemiclave" value="Yes" /> Chemiclave</td>
                                            <td><input type="checkbox" name="sterilization_method_other" id="sterilization_method_other" value="Yes" />
                                                <input type="text" name="sterilization_method_other_type" id="sterilization_method_other_type" class="text-input-field" placeholder="Other" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>   
                        </div>                               
                    <br /><br /><br />
                </div>

                <!-- #################################################################################################### -->

                <div id="provider-form-provider-tab" class="form-tab">
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    <b>To be completed by Provider.  Please complete and attach all documents.  Missing information will delay processing.
                                </div>
                                <div class="provider-cell-field">
                                    &nbsp;
                                </div>
                            </div>                            
                        </div>  
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Provider Information
                            </div>
                        </div>                      
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Provider's Name (include suffix;, JR., Sr., III):
                                </div>
                                <div class="provider-cell-field">
                                    <input type='text' name='providers_full_name' id='providers_full_name' class="text-input-field" />
                                </div>
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Maiden/Other Name(s) (if applicable):
                                </div>
                                <div class="provider-cell-field">
                                    <input type='text' name='providers_other_name' id='providers_other_name' class="text-input-field" />
                                </div>
                            </div>
                            <div class="seventh">
                                <div class="provider-cell-header">
                                    Owner
                                </div>
                                <div class="provider-cell-field">
                                    <input type='checkbox' name='provider_is_owner' id='provider_is_owner' value="Yes" />
                                </div>
                            </div>  
                            <div class="seventh">
                                <div class="provider-cell-header">
                                    Associate
                                </div>
                                <div class="provider-cell-field">
                                    <input type='checkbox' name='provider_is_associate' id='provider_is_associate' value="Yes" />
                                </div>
                            </div>  
                            <div class="seventh">
                                <div class="provider-cell-header">
                                    Employee
                                </div>
                                <div class="provider-cell-field">
                                    <input type='checkbox' name='provider_is_employee' id='provider_is_employee' value="Yes" />
                                </div>
                            </div>                              
                        </div>  
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Social Security Number (SSN):
                                </div>
                                <div class="provider-cell-field">
                                    <input type='text' name='providers_ssn' id='providers_ssn' class="text-input-field" />
                                </div>
                            </div>                            
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    TIN (if different):
                                </div>
                                <div class="provider-cell-field">
                                    <input type='text' name='providers_tin' id='providers_tin' class="text-input-field" />
                                </div>
                            </div>                            
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Gender:
                                </div>
                                <div class="provider-cell-field" style="white-space: nowrap">
                                    <input type='radio' name='providers_gender' id='providers_gender_male'  value="M" /> Male
                                    <input type='radio' name='providers_gender' id='providers_gender_female'  value="F" /> Female
                                </div>
                            </div>                            
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Date of Birth
                                </div>
                                <div class="provider-cell-field">
                                    <input type='text' name='providers_date_of_birth' id='providers_date_of_birth' class="text-input-field" />
                                </div>
                            </div>                            
                        </div> 
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Individual NPI (NPI-1)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="individual_npi_npi_1" id="individual_npi_npi_1" class="text-input-field" />
                                </div>
                            </div>                            
                            <div class="half">
                                <div class="provider-cell-header">
                                    E-Mail
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_npi_email" id="provider_npi_email" class="text-input-field" />
                                </div>
                            </div>                              
                        </div> 
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Individual Medicaid Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="individual_medicaid_number" id="individual_medicaid_number_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="individual_medicaid_number" id="individual_medicaid_number_no" value="No" /> No &nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="individual_medicaid_number" id="individual_medicaid_number_ip" value="In Process" /> In Process &nbsp;&nbsp;&nbsp;
                                </div>
                            </div>                            
                            <div class="half">
                                <div class="provider-cell-header">
                                    Individual Medicaid Number (if applicable)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="applicable_individual_medicaid_number" id="applicable_individual_medicaid_number" class="text-input-field" />
                                </div>
                            </div>                              
                        </div>   
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Individual Medicare Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="individual_medicare_number" id="individual_medicare_number_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="individual_medicare_number" id="individual_medicare_number_no" value="No" /> No &nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="individual_medicare_number" id="individual_medicare_number_ip" value="In Process" /> In Process &nbsp;&nbsp;&nbsp;
                                </div>
                            </div>                            
                            <div class="half">
                                <div class="provider-cell-header">
                                    Individual Medicare Number (if applicable)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="applicable_individual_medicare_number" id="applicable_individual_medicare_number" class="text-input-field" />
                                </div>
                            </div>                                   
                        </div>   
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Are you enrolled in Medicare Part D?
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="enrolled_in_medicare" id="enrolled_in_medicare_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="enrolled_in_medicare" id="enrolled_in_medicare_no" value="No" /> No &nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="enrolled_in_medicare" id="enrolled_in_medicare_ip" value="In Process" /> In Process &nbsp;&nbsp;&nbsp;
                                </div>
                            </div>                            
                            <div class="half">
                                <div class="provider-cell-header">
                                    Do you submit claims under your TIN or the Practice?
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="submit_under_tin" id="submit_under_tin_yes" value="TIN" /> TIN &nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="submit_under_tin" id="submit_under_tin_no" value="Practice" /> Practice &nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="submit_under_tin" id="submit_under_tin_ip" value="NA" /> N/A &nbsp;&nbsp;&nbsp;
                                </div>
                            </div>                              
                        </div>  
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Provider Type &amp; Professional Training (Complete as applicable)
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Provider Type
                                </div>
                                <div class="provider-cell-field">
                                    <table>
                                        <tr>
                                            <td>
                                                <input type="checkbox" name="provider_type_dental" id="provider_type_dental" value="Yes" /> Dental &nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td>
                                                <input type="checkbox" name="provider_type_routine_vision" id="provider_type_routine_vision" value="Yes" /> Routine Vision &nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td>
                                                <input type="checkbox" name="provider_type_medical_and_surgical" id="provider_type_medical_and_surgical" value="Yes" /> Medical &amp; Surgical &nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td>
                                                <input type="checkbox" name="provider_type_medical_only" id="provider_type_medical_only" value="Yes" /> Medical Only &nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td>
                                                <input type="checkbox" name="provider_type_surgical_only" id="provider_type_surgical_only" value="Yes" /> Surgical Only &nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td>
                                                <input type="checkbox" name="provider_type_optical_facility" id="provider_type_optical_facility" value="Yes" /> Optical Facility
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>                            
                       
                        </div>    
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Vision Provider Type:
                                </div>
                                <div class="provider-cell-field">
                                    <table>
                                        <tr>
                                            <td><input type="checkbox" name="ophthalmologist" id="ophthalmologist" value="Yes"/> Ophthalmologist&nbsp;&nbsp;&nbsp;</td>
                                            <td><input type="checkbox" name="optometrist" id="optometrist" value="Yes"/> Optometrist&nbsp;&nbsp;&nbsp;</td>
                                            <td><input type="checkbox" name="licensed_optician" id="licensed_optician" value="Yes"/> Licensed Optician&nbsp;&nbsp;&nbsp;</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>                            
                            <div class="half">
                                <div class="provider-cell-header">
                                    Vision Specialty
                                </div>
                                <div class="provider-cell-field">
                                    <table>
                                        <tr>
                                            <td><input type="checkbox" name="vision_pedo" id="vision_pedo" value="Yes"/> Pedo&nbsp;&nbsp;&nbsp;</td>
                                            <td><input type="checkbox" name="vision_neuro" id="vision_Neuro" value="Yes"/> Neuro&nbsp;&nbsp;&nbsp;</td>
                                            <td><input type="checkbox" name="vision_retina" id="vision_retina" value="Yes"/> Retina&nbsp;&nbsp;&nbsp;</td>
                                            <td><input type="checkbox" name="vision_oculoplastic" id="vision_oculoplastic" value="Yes"/> Oculoplastic&nbsp;&nbsp;&nbsp;</td>
                                            <td><input type="checkbox" name="vision_cornea" id="vision_cornea" value="Yes"/> Cornea&nbsp;&nbsp;&nbsp;</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>                            
                        </div>
                         <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Dental Provider Type:
                                </div>
                                <div class="provider-cell-field">
                                    <table>
                                        <tr>
                                            <td><input type="checkbox" name="general_dentist" id="general_dentist" value="Yes"/> General Dentistry</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>                            
                            <div class="half">
                                <div class="provider-cell-header">
                                    Dental Specialty
                                </div>
                                <div class="provider-cell-field">
                                    <table>
                                        <tr>
                                            <td><input type="checkbox" name="dental_endo"   id="dental_endo" value="Yes"/> Endo&nbsp;&nbsp;&nbsp;</td>
                                            <td><input type="checkbox" name="dental_perio"  id="dental_perio" value="Yes"/> Perio&nbsp;&nbsp;&nbsp;</td>
                                            <td><input type="checkbox" name="dental_prostho" id="dental_prostho" value="Yes"/> Prostho&nbsp;&nbsp;&nbsp;</td>
                                            <td><input type="checkbox" name="dental_pedo"   id="dental_pedo" value="Yes"/> Pedo&nbsp;&nbsp;&nbsp;</td>
                                            <td><input type="checkbox" name="dental_ortho"  id="dental_ortho" value="Yes"/> Ortho&nbsp;&nbsp;&nbsp;</td>
                                            <td><input type="checkbox" name="dental_oral_surgery" id="dental_oral_surgery" value="Yes"/> Oral Surgery</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>                            
                        </div>
                         <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Professional School:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="professional_school" id="professional_school" class="text-input-field" />
                                </div>
                            </div>                            
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Degree
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="professional_degree" id="professional_degree" class="text-input-field" />
                                </div>
                            </div>                            
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Year Graduated
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="year_graduated" id="year_graduated" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>                    
                         <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Residency Program (if applicable)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="residency_program" id="residency_program" class="text-input-field" />
                                </div>
                            </div>                            
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    From
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="residency_program_from" id="residency_program_from" class="text-input-field" />
                                </div>
                            </div>                            
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    To
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="residency_program_to" id="residency_program_to" class="text-input-field" />
                                </div>
                            </div>                            
                             
                        </div>
                         <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Fellowship or Advanced Training (if applicable)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="fellowship_training" id="fellowship_training" class="text-input-field" />
                                </div>
                            </div>                            
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    From
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="fellowship_training_from" id="fellowship_training_from" class="text-input-field" />
                                </div>
                            </div>                            
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    To
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="fellowship_training_to" id="fellowship_training_to" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>

                         <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Board Certified?
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="board_certified" id="board_certified_yes" value="Yes" /> Yes (select certifying board below) &nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="board_certified" id="board_certified_no" value="No" /> No &nbsp;&nbsp;&nbsp;
                                </div>
                            </div>                            
                        </div>

                         <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Dentistry
                                </div>
                                <div class="provider-cell-field">
                                    <input type="checkbox" name="american_board_of_general_dentistry" id="american_board_of_general_dentistry" value="Yes" /> American Board of General Dentistry<br />
                                    <input type="checkbox" name="american_board_of_endodontics"     id="american_board_of_endodontics" value="Yes" /> American Board of Endodontics<br />
                                    <input type="checkbox" name="american_board_of_oral_surgery"    id="american_board_of_oral_surgery" value="Yes" /> American Board of Oral Surgery<br />
                                    <input type="checkbox" name="american_board_of_orthodontics"    id="american_board_of_orthodontics" value="Yes" /> American Board of Orthodontics<br />
                                    <input type="checkbox" name="american_board_of_pediatrics"      id="american_board_of_pediatrics" value="Yes" /> American Board of Pediatrics<br />
                                    <input type="checkbox" name="american_board_of_periodontology"  id="american_board_of_periodontology" value="Yes" /> American Board of Periodontology<br />
                                    <input type="checkbox" name="american_board_of_prosthodontics"  id="american_board_of_prosthodontics" value="Yes" /> American Board of Prosthodontics<br />                           
                                    <input type="checkbox" name="dental_other"    id="dental_other" value="Yes" /> 
                                    Other: <input type="text" name="other_dental_credentialing_board" id="other_dental_credentialing_board" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="half" style="position: relative;">
                                <div class="provider-cell-header" >
                                    Vision
                                </div>
                                <div class="provider-cell-field">
                                    <input type="checkbox" name="american_board_of_optometry"    id="american_board_optometry" value="Yes" /> American Board of Optometry<br />
                                    <input type="checkbox" name="american_board_of_ophthalmology"      id="american_board_of_ophthalmology" value="Yes" /> American Board of Ophthalmology<br />
                                    <input type="checkbox" name="american_osteopathic_association"  id="american_osteopathic_associationy" value="Yes" /> American Osteopathic Association<br />
                                    <input type="checkbox" name="american_association_of_physician_specialists"  id="american_association_of_physician_specialists" value="Yes" /> American Association of Physician Specialistss<br />                           
                                    <input type="checkbox" name="vision_other"           id="vision_other" value="Yes" /> 
                                    Other: <input type="text" name="other_vision_credentialing_board" id="other_vision_credentialing_board" class="text-input-field" /><br /><br /><br /><br />
                                </div>
                            </div>                               
                        </div>
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Licensing Information <span style="font-size: .9em; margin-left: 30px">Please attach copies of current documents identified below</span>
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    State
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_1_state" id="license_1_state" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    License Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_1_license_number" id="license_1_license_number" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Effective Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_1_effective_date" id="license_1_effective_date" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Expiration Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_1_expiration_date" id="license_1_expiration_date" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    <span id="license_1_attachment_link">Attach License/Cert</span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="license_1_attachment" id="license_1_attachment" class="text-input-field" />
                                </div>
                            </div>                             
                        </div>  
                        <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    State
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_2_state" id="license_2_state" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    License Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_2_license_number" id="license_2_license_number" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Effective Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_2_effective_date" id="license_2_effective_date" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Expiration Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_2_expiration_date" id="license_2_expiration_date" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    <span id="license_2_attachment_link">Attach License/Cert</span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="license_2_attachment" id="license_2_attachment" class="text-input-field" />
                                </div>
                            </div>                             
                        </div>  
                        <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    State
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_3_state" id="license_3_state" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    License Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_3_license_number" id="license_3_license_number" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Effective Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_3_effective_date" id="license_3_effective_date" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Expiration Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_3_expiration_date" id="license_3_expiration_date" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    <span id="license_3_attachment_link">Attach License/Cert</span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="license_3_attachment" id="license_3_attachment" class="text-input-field" />
                                </div>
                            </div>                             
                        </div>  
                        <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    State
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_4_state" id="license_4_state" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    License Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_4_license_number" id="license_4_license_number" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Effective Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_4_effective_date" id="license_4_effective_date" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Expiration Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="license_4_expiration_date" id="license_4_expiration_date" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    <span id="license_4_attachment_link">Attach License/Cert</span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="license_4_attachment" id="license_4_attachment" class="text-input-field" />
                                </div>
                            </div>                             
                        </div>   
                         <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    DEA Certificate
                                </div>
                                <div class="provider-cell-field">
                                    <input type="checkbox" name="dea_certificate_not_applicable" id="dea_certificate_not_applicable" value="Yes" /> Not Applicable
                                </div>
                            </div>           
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="dea_certificate_number" id="dea_certificate_number" class="text-input-field" />
                                </div>
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Eff. Date:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="dea_certificate_effective_date" id="dea_certificate_effective_date" class="text-input-field" />
                                </div>
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Exp. Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="dea_certificate_expiration_date" id="dea_certificate_expiration_date" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    <span id="dea_certificate_attachment_link">Attach License/Cert</span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="dea_certificate_attachment" id="dea_certificate_attachment" class="text-input-field" />
                                </div>
                            </div>                              
                        </div>  
                    
                         <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Controlled Substance
                                </div>
                                <div class="provider-cell-field">
                                    <input type="checkbox" name="controlled_substance_not_applicable" id="controlled_substance_not_applicable" value="Yes" /> Not Applicable
                                </div>
                            </div>           
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="controlled_substance_number" id="controlled_substance_number" class="text-input-field" />
                                </div>
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Eff. Date:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="controlled_substance_effective_date" id="controlled_substance_effective_date" class="text-input-field" />
                                </div>
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Exp. Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="controlled_substance_expiration_date" id="controlled_substance_expiration_date" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    <span id="controlled_substance_attachment_link">Certificate (CDS)</span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="controlled_substance_attachment" id="controlled_substance_attachment" class="text-input-field" />
                                </div>
                            </div>                              
                        </div>                       
                         <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    ACLS Certificate
                                </div>
                                <div class="provider-cell-field">
                                    <input type="checkbox" name="acls_certificate_not_applicable" id="acls_certificate_not_applicable" value="Yes" /> Not Applicable
                                </div>
                            </div>           
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="acls_certificatee_number" id="acls_certificate_number" class="text-input-field" />
                                </div>
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Eff. Date:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="acls_certificate_effective_date" id="acls_certificate_effective_date" class="text-input-field" />
                                </div>
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Exp. Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="acls_certificate_expiration_date" id="acls_certificate_expiration_date" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    <span id="acls_certificate_attachment_link">Certificate (CDS)</span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="acls_certificate_attachment" id="acls_certificate_attachment" class="text-input-field" />
                                </div>
                            </div>                              
                        </div>                          
                         <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    General Anesthesia
                                </div>
                                <div class="provider-cell-field">
                                    <input type="checkbox" name="general_anesthesia_not_applicable" id="general_anesthesia_not_applicable" value="Yes" /> Not Applicable
                                </div>
                            </div>           
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="general_anesthesia_number" id="general_anesthesia_number" class="text-input-field" />
                                </div>
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Eff. Date:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="general_anesthesiae_effective_date" id="general_anesthesia_effective_date" class="text-input-field" />
                                </div>
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Exp. Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="general_anesthesia_expiration_date" id="general_anesthesia_expiration_date" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    <span id="general_anesthesia_attachment_link">Permit</span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="general_anesthesia_attachment" id="general_anesthesia_attachment" class="text-input-field" />
                                </div>
                            </div>                              
                        </div>  
                        <div class="provider-row">
                            <div class="provider-form-header">
                                <div style="float: right; margin-right: 10px">
                                    If Medical Provider only and not applicable, check here <input type="checkbox" name="provider_type_not_applicable" id="provider_type_not_applicable" value="Yes" />
                                </div>
                                Privileges: &nbsp;&nbsp; <input type="checkbox" name="privilege_type_asc" id="privilige_type_asc" value="Yes" /> ASC &nbsp;&nbsp;&nbsp;
                                           <input type="checkbox" name="privilege_type_hospital" id="privilige_type_hospital" value="Yes" /> Hospital &nbsp;&nbsp;&nbsp;
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                   Facility Name
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="privilege_facility_name" id="privilege_facility_name" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="half">
                                <div class="provider-cell-header">
                                   Street Address:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="gprivilege_street_address" id="privilege_street_address" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                   City:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="privilege_city" id="privilege_city" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   State:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="privilege_state" id="privilege_state" class="text-input-field" />
                                </div>
                            </div>                            
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Zip Code:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="privilege_zip_code" id="privilege_zip_code" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                   Phone Number:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="privilege_phone_number" id="privilege_phone_number" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="half">
                                <div class="provider-cell-header">
                                   Contact Name
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="privilege_contact_name" id="privilege_contact_name" class="text-input-field" />
                                </div>
                            </div>                            
                        </div> 
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                   Date Privileges Granted
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="privilege_date_granted" id="privilege_date_granted" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="half">
                                <div class="provider-cell-header">
                                   Type of Privileges
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="privilege_type" id="privilege_type" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>   
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Professional Liability Insurance Information <div style="display: inline-block; width: 50%; text-align: justify; font-size: .9em">
                                    Please attach a copy of your current Insurance Declaration page or Certificate of Insurance
                                </div>
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="threequarter">
                                <div class="provider-cell-header">
                                   Professional Liability Insurance Carrier
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="professional_liability_insurance_carrier" id="professional_liability_insurance_carrier" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Policy Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="insurance_policy_number" id="insurance_policy_number" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                   Individual Limit of Coverage
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="individual_limit_of_coverage" id="individual_limit_of_coverage" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="half">
                                <div class="provider-cell-header">
                                   Aggregate Limit of Coverage
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="aggregate_limit_of_coverage" id="aggregate_limit_of_coverage" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>     
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    <span id="insurance_policy_link">Attach Insurance Policy</span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="insurance_policy" id="insurance_policy" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Effective Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="policy_effective_date" id="policy_effective_date" class="text-input-field" />
                                </div>
                            </div>   
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Expiration Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="policy_expiration_date" id="policy_expiration_date" class="text-input-field" />
                                </div>
                            </div>                              
                        </div>                       
                        <br /><br /><br /><br />
                </div>
                
                <!-- #################################################################################################### -->

                <div id="provider-form-work-history-tab" class="form-tab">
                        <div class="provider-row">
                            <div class="provider-form-header">
                                 <div style="display: inline-block; width: 85%; float: right; text-align: justify; font-size: .9em">
                                    In lieu of completing the section below, you may attach a resume or Curriculum Vitae. To be acceptable, <u>Resume or Curriculum Vitae must show last 5 years of employment, including CURRENT EMPLOYMENT, and both MONTHS and YEARS of employment</u>.
                                </div> Work History
                                <div style="clear: both"></div>
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   Please include CURRENT EMPLOYMENT. Explain any gaps of six (6) months or more on a separate piece of paper. Must list last 5 years of employment.
                                </div>
                                <div class="provider-cell-field">
                                    <table style="width: 100%">
                                        <tr>
                                            <th width="20%" style="text-align: center">Dates To/From<br />
                                                (MM/YY - MM/YY)</th>
                                            <th width="40%" style="text-align: center">Employer</th>
                                            <th width="30%" style="text-align: center">Address</th>
                                            <th style="text-align: center">Phone</th>
                                        </tr>
                                        <tr>
                                            <td align="center">
                                                <input type="text" style="width: 25%" name="work_history_from_date_1" id="work_history_from_date_1" class="text-input-field" /> to
                                                <input type="text" style="width: 25%" name="work_history_to_date_1" id="work_history_to_date_1" class="text-input-field" />
                                            </td>
                                            <td>
                                               <input type="text" name="work_history_employer_1" id="work_history_employer_1" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_address_1" id="work_history_address_1" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_phone_1" id="work_history_phone_1" class="text-input-field" />
                                            </td>
                                        </tr>
                                        <tr><td colspan="4">&nbsp;</td></tr>
                                        <tr>
                                            <td align="center">
                                                <input type="text" style="width: 25%" name="work_history_from_date_2" id="work_history_from_date_2" class="text-input-field" /> to
                                                <input type="text" style="width: 25%" name="work_history_to_date_2" id="work_history_to_date_2" class="text-input-field" />
                                            </td>
                                            <td>
                                               <input type="text" name="work_history_employer_2" id="work_history_employer_2" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_address_2" id="work_history_address_2" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_phone_2" id="work_history_phone_2" class="text-input-field" />
                                            </td>
                                        </tr>
                                        <tr><td colspan="4">&nbsp;</td></tr>
                                        <tr>
                                            <td align="center">
                                                <input type="text" style="width: 25%" name="work_history_from_date_3" id="work_history_from_date_3" class="text-input-field" /> to
                                                <input type="text" style="width: 25%" name="work_history_to_date_3" id="work_history_to_date_3" class="text-input-field" />
                                            </td>
                                            <td>
                                               <input type="text" name="work_history_employer_3" id="work_history_employer_3" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_address_3" id="work_history_address_3" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_phone_3" id="work_history_phone_3" class="text-input-field" />
                                            </td>
                                        </tr>
                                        <tr><td colspan="4">&nbsp;</td></tr>
                                        <tr>
                                            <td align="center">
                                                <input type="text" style="width: 25%" name="work_history_from_date_4" id="work_history_from_date_4" class="text-input-field" /> to
                                                <input type="text" style="width: 25%" name="work_history_to_date_4" id="work_history_to_date_4" class="text-input-field" />
                                            </td>
                                            <td>
                                               <input type="text" name="work_history_employer_4" id="work_history_employer_4" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_address_4" id="work_history_address_4" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_phone_4" id="work_history_phone_4" class="text-input-field" />
                                            </td>
                                        </tr>
                                        <tr><td colspan="4">&nbsp;</td></tr>
                                        <tr>
                                            <td align="center">
                                                <input type="text" style="width: 25%" name="work_history_from_date_5" id="work_history_from_date_5" class="text-input-field" /> to
                                                <input type="text" style="width: 25%" name="work_history_to_date_5" id="work_history_to_date_5" class="text-input-field" />
                                            </td>
                                            <td>
                                               <input type="text" name="work_history_employer_5" id="work_history_employer_5" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_address_5" id="work_history_address_5" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_phone_5" id="work_history_phone_5" class="text-input-field" />
                                            </td>
                                        </tr>
                                        <tr><td colspan="4">&nbsp;</td></tr>
                                        <tr>
                                            <td align="center">
                                                <input type="text" style="width: 25%" name="work_history_from_date_6" id="work_history_from_date_6" class="text-input-field" /> to
                                                <input type="text" style="width: 25%" name="work_history_to_date_6" id="work_history_to_date_6" class="text-input-field" />
                                            </td>
                                            <td>
                                               <input type="text" name="work_history_employer_6" id="work_history_employer_6" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_address_6" id="work_history_address_6" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_phone_6" id="work_history_phone_6" class="text-input-field" />
                                            </td>
                                        </tr>
                                        <tr><td colspan="4">&nbsp;</td></tr>
                                        <tr>
                                            <td align="center" width="20%">
                                                <input type="text" style="width: 25%" name="work_history_from_date_7" id="work_history_from_date_7" class="text-input-field" /> to
                                                <input type="text" style="width: 25%" name="work_history_to_date_7" id="work_history_to_date_7" class="text-input-field" />
                                            </td>
                                            <td width="40%">
                                               <input type="text" name="work_history_employer_7" id="work_history_employer_7" class="text-input-field" />
                                            </td>
                                            <td width="30%">
                                                <input type="text" name="work_history_address_7" id="work_history_address_7" class="text-input-field" />
                                            </td>
                                            <td>
                                                <input type="text" name="work_history_phone_7" id="work_history_phone_7" class="text-input-field" />
                                            </td>
                                        </tr>                                        
                                    </table>
                                    <br />
                                    <table>
                                        <tr>
                                            <td>
                                                <b><span id="provider_resume_link">Provider Resume</span></b>:
                                            </td>
                                            <td>
                                                <input type="file" name="provider_resume" id="provider_resume" class="text-input-field" />
                                            </td>
                                        </tr>
                                        <tr><td colspan="4">&nbsp;</td></tr>
                                        <tr>
                                            <td>
                                                <b><span id="provider_work_gap_explanation_link">Work Gap Explanation</span></b>:
                                            </td>
                                            <td>
                                                <input type="file" name="provider_work_gap_explanation" id="provider_work_gap_explanation" class="text-input-field" />
                                            </td>
                                        </tr>                                        
                                    </table>
                                </div>
                            </div> 
                            <br />
                        </div>
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Professional References
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    List at least <b>two</b> (2) professional references, from your specialty area, not including relatives, who have worked with you in the past two years. References must be from individuals who through recent observation, are directly familiar with your work and can attest to your clinical competence in your specialty area.
                                </div>
                            </div> 
                        </div>  
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                  &nbsp;
                                </div>
                                <div class="provider-cell-field">
                                    &nbsp;
                                </div>
                            </div>                               
                        </div>                      
                        <div class="provider-row">
                            <div class="third">
                                <div class="provider-cell-header">
                                   Name of Reference
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_name_1" id="reference_name_1" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="third">
                                <div class="provider-cell-header">
                                   Title and Specialty
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_specialty_1" id="reference_specialty_1" class="text-input-field" />
                                </div>
                            </div>   
                            <div class="third">
                                <div class="provider-cell-header">
                                  E-mail address
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_email_1" id="reference_email_1" class="text-input-field" />
                                </div>
                            </div>                               
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                  Mailing Address
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_mailing_address_1" id="reference_mailing_address_1" class="text-input-field" />
                                </div>
                            </div>                               
                        </div>  
                        <div class="provider-row">
                            <div class="third">
                                <div class="provider-cell-header">
                                   Telephone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_phone_1" id="reference_phone_1" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="third">
                                <div class="provider-cell-header">
                                   Fax Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_fax_1" id="reference_fax_1" class="text-input-field" />
                                </div>
                            </div>   
                            <div class="third">
                                <div class="provider-cell-header">
                                  Cell Phone Number (optional)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_cellphone_1" id="reference_cellphone_1" class="text-input-field" />
                                </div>
                            </div>                               
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                  &nbsp;
                                </div>
                                <div class="provider-cell-field">
                                    &nbsp;
                                </div>
                            </div>                               
                        </div>   
                        <div class="provider-row">
                            <div class="third">
                                <div class="provider-cell-header">
                                   Name of Reference
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_name_2" id="reference_name_2" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="third">
                                <div class="provider-cell-header">
                                   Title and Specialty
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_specialty_2" id="reference_specialty_2" class="text-input-field" />
                                </div>
                            </div>   
                            <div class="third">
                                <div class="provider-cell-header">
                                  E-mail address
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_email_2" id="reference_email_2" class="text-input-field" />
                                </div>
                            </div>                               
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                  Mailing Address
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_mailing_address_2" id="reference_mailing_address_2" class="text-input-field" />
                                </div>
                            </div>                               
                        </div>  
                        <div class="provider-row">
                            <div class="third">
                                <div class="provider-cell-header">
                                   Telephone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_phone_2" id="reference_phone_2" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="third">
                                <div class="provider-cell-header">
                                   Fax Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_fax_2" id="reference_fax_2" class="text-input-field" />
                                </div>
                            </div>   
                            <div class="third">
                                <div class="provider-cell-header">
                                  Cell Phone Number (optional)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="reference_cellphone_2" id="reference_cellphone_2" class="text-input-field" />
                                </div>
                            </div>                               
                        </div> 
                        <br /><br /><br />
                </div>

                <!-- #################################################################################################### -->

                <div id="provider-form-questionnaire-tab" class="form-tab">
                    <div class="provider-form">
                        <div class="provider-row">
                            <div class="provider-form-header">
                                PROFESSIONAL HISTORICAL DATA QUESTIONNAIRE
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="provider-cell-header">
                                <b>The following must be answered by Provider.</b><br /><br />
                                Any “Yes” response will require a detailed explanation and must be submitted along with the Dental Provider Application.
                            </div>
                            <div class="provider-cell-field">
                                <table style='width: 96%' border='1'>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>1.</td>
                                        <td style='padding: 5px'>Have you ever been convicted of a felony or do you have any pending misdemeanor and/or felony charges?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_1" id="questionnaire_question_1_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_1" id="questionnaire_question_1_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>2.</td>
                                        <td style='padding: 5px'>Has your license to practice medicine in any jurisdiction ever been voluntarily or involuntarily denied, restricted, suspended, challenged, revoked, conditioned, or otherwise limited?	</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_2" id="questionnaire_question_2_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_2" id="questionnaire_question_2_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>3.</td>
                                        <td style='padding: 5px'>Have you ever been publicly reprimanded or disciplined by a professional licensing agency or Board?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_3" id="questionnaire_question_3_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_3" id="questionnaire_question_3_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>4.</td>
                                        <td style='padding: 5px'>Has your DEA certification and/or state controlled drug permit ever been restricted, suspended, revoked, voluntarily relinquished or otherwise limited?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_4" id="questionnaire_question_4_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_4" id="questionnaire_question_4_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>5.</td>
                                        <td style='padding: 5px'>Have any of your privileges or memberships at any hospital or institution ever been denied, suspended, reduced, revoked, not renewed or otherwise limited?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_5" id="questionnaire_question_5_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_5" id="questionnaire_question_5_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>6.</td>
                                        <td style='padding: 5px'>Has your participation in Medicare, Medicaid or any other government program ever been limited, expelled, excluded or have you voluntarily excluded yourself from any of these programs?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_6" id="questionnaire_question_6_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_6" id="questionnaire_question_6_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>7.</td>
                                        <td style='padding: 5px'>Have you ever been convicted or pled “nolo contendere” to a criminal offense related to Medicare, Medicaid or any other Federal program?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_7" id="questionnaire_question_7_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_7" id="questionnaire_question_7_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>8.</td>
                                        <td style='padding: 5px'>Has your participation in an HMO and/or an Insurance Company network ever been limited, restricted, suspended or terminated?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_8" id="questionnaire_question_8_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_8" id="questionnaire_question_8_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>9.</td>
                                        <td style='padding: 5px'>In the past five years, up to and including the present, have you had any ongoing physical or mental impairment or condition which would make you unable, with or without reasonable accommodation, to perform the essential functions of a practitioner in your area of practice, or unable to perform those essential functions without a direct threat to the health and safety of others?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_9" id="questionnaire_question_9_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_9" id="questionnaire_question_9_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>10.</td>
                                        <td style='padding: 5px'>Considering the essential function of a practitioner in your area of practice, in the past five years, up to and including the present, have you suffered from any communicable health condition that could pose a significant health and safety risk to your patients?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_10" id="questionnaire_question_10_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_10" id="questionnaire_question_10_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>11.</td>
                                        <td style='padding: 5px'>In the past five years and up to and including the present, have you had a history of chemical dependency or substance abuse that might affect your ability to competently and safely perform the essential functions of a practitioner in your area of practice?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_11" id="questionnaire_question_11_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_11" id="questionnaire_question_11_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>12.</td>
                                        <td style='padding: 5px'>Are you currently participating or under supervision of a Physician or Recovery Network or applicable program?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_12" id="questionnaire_question_12_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_12" id="questionnaire_question_12_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>13.</td>
                                        <td style='padding: 5px'>Has any malpractice carrier made an out-of-court settlement or paid a judgment of a medical malpractice claim on your behalf in the past 5 years or are any medical malpractice suits pending against you?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_13" id="questionnaire_question_13_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_13" id="questionnaire_question_13_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>14.</td>
                                        <td style='padding: 5px'>Are you currently uninsured for professional liability (malpractice insurance) coverage?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_14" id="questionnaire_question_14_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_14" id="questionnaire_question_14_no" value="No" /> No
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style='width: 10%; text-align: center'>15.</td>
                                        <td style='padding: 5px'>Has your malpractice/professional liability insurer placed conditions or restrictions on your coverage or ability to obtain coverage in the past 10 years?</td>
                                        <td style='width: 15%; text-align: center'>
                                            <input type="radio" name="questionnaire_question_15" id="questionnaire_question_15_yes" value="Yes" /> Yes &nbsp;&nbsp;&nbsp;
                                            <input type="radio" name="questionnaire_question_15" id="questionnaire_question_15_no" value="No" /> No
                                        </td>
                                    </tr>
                                </table>
                                <br /><br />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- #################################################################################################### -->

                <div id="provider-form-release-tab" class="form-tab">
                    <div class="provider-form">
                        <div class="provider-row">
                            <div class="provider-form-header">
                                PROVIDER  ATTESTATION, AUTHORIZATION,  AND RELEASE OF INFORMATION FORM
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="provider-cell-header">
                                By submitting this authorization and release of information form, I understand and agree as follows:
                            </div>
                            <div class="provider-cell-field">
                                By submitting this authorization and release of information form, I understand and agree as follows:
                                <br /><br />
                                I understand and acknowledge that, as an applicant for participating status with Argus Dental & Vision, Inc. for initial credentialing or re-credentialing, I have the burden of producing adequate information for proper evaluation of my competence, character, ethics, mental and physical health status, and/or other qualifications.
                                <br /><br />
                                I further understand and acknowledge that Argus Dental & Vision, Inc. or designated agent will investigate the information in this application. By submitting this application, I agree to such investigation and to the disciplinary reporting and information exchange activities of Argus Dental & Vision, Inc. as part of the verification and credentialing process.
                                <br /><br />
                                I authorize Argus Dental & Vision, Inc., and its subsidiaries, affiliates, successors, employees, agents, authorized representatives, and third parties (hereinafter “ADV”), to consult with hospitals, members of hospital medical staffs, professional liability carriers, managed care organizations and other persons or entities to obtain information concerning my professional credentials and qualifications, including without limitation my professional competence and conduct. Such authorization to obtain information includes but is not limited to information about my quality of care and utilization statistics from chiefs of the clinical departments of a hospital in which I have staff privileges, professional state boards, applicable state and federal agencies, and primary care and specialist physician colleagues participating with ADV.
                                <br /><br />
                                I authorize all individuals, institutions and entities of organization with which I am currently or have been associated with which I am currently or have been associated and all professional liability insurers with which I have had or currently have professional liability insurance, who may have information bearing on my professional qualifications, ethical standing, competence, and mental and physical health status to release the aforementioned information to ADV.
                                <br /><br />
                                I consent to the inspection of records and documents that may be material to an evaluation of qualifications and my ability to provide services I request. I authorize each and every individual and organization in custody of such records and documents to permit such inspection and copying. I am willing to make myself available for interviews if required or requested.
                                <br /><br />
                                I consent to the release to ADV of any and all information that may be relevant to an evaluation of my qualifications, including information about disciplinary actions and information that might otherwise be considered confidential or privileged.
                                <br /><br />
                                I authorize ADV to release this information, as well as quality assurance data relating to me: (1) to health/dental/vision plans/programs owned, managed, or administered by ADV, (2) to health/medical/dental/vision groups, independent practice associations and similar entities contracting with said health/medical/dental/vision plans/programs has delegated credentialing functions to such entities, and (3) as authorized under state or federal law or regulation.
                                <br /><br />
                                I release ADV and any and all persons or entities providing information about me to ADV, from any and all liability connected with or arising from the release of such information, provided that such party(ies) was(were) acting in good faith without malice. I further release ADV from any and all liability for its acts performed in good faith and without malice in evaluating my application and any decisions related to my application or credentialing status.
                                <br /><br />
                                I understand and agree that any misstatement or material omission in this application will constitute grounds for rejection of my application or summary dismissal as a participating provider in any and all managed care products or plans maintained or managed by ADV. If any material changes occur in the information I have provided in this application making such information no longer correct and complete or affecting my professional status, I understand and agree that it is my obligation to notify ADV within ten (10) days of said occurrence. Failure to comply with this obligation may constitute grounds for rejection of my application or summary dismissal as a participating provider in any and all managed care products or plans maintained or managed by ADV.
                                <br /><br />
                                I understand that completion and submission of this application and Attestation and Release of Information Form (“Release”) does not automatically grant me membership or participating status with Argus Dental & Vision, Inc.
                                <br /><br />
                                I further acknowledge that I have read and understand this Release. A photocopy of this Release shall be as effective as the original and authorization constitutes my written authorization and request to communicate any relevant information and to release any and all supportive documentation regarding this application.
                                <br /><br />
                                <input type="checkbox" onclick="Argus.provider.toggle(this)" name="confirm-form-information" id="confirm-form-information" value="Yes"> I attest that the information in this application is complete, accurate, and current. A photocopy of this application has the same force and effect as the original. I have reviewed this information as of the most recent date listed below.
                                <br /><br />
                                {if (!$make_readonly)}
                                <input type="button" onclick="$('#pin-entry-layer').css('display','block'); return false" style="float: right; margin-right: 10px" name="submit-form-data-right" id="submit-form-data-1" value=" Submit New Provider Registration Form " />
                                <input type="button" onclick="$('#pin-entry-layer').css('display','block'); return false" name="submit-form-data" id="submit-form-data-2" value=" Submit New Provider Registration Form " />
                                {else}
                                    <br />
                                    <h3>This form was submitted on <u>{$data.date_submitted}</u></h3>
                                {/if}
                            </div>
                        </div>
                        <br /><br /><br />
                    </div>
                </div>

                <!-- #################################################################################################### -->

                <div id="provider-form-additional-offices-tab" class="form-tab">
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Additional Office Locations <div style="display: inline-block; width: 50%; text-align: justify; font-size: .9em">
                                    Please provide information for only those locations who will participate with Argus
                                </div>
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   Practice Name
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_name_1" id="additional_practice_name_1" class="text-input-field" />
                                </div>
                            </div> 
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   Complete Address (Street, City, State, Zip Code)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_address_1" id="additional_practice_address_1" class="text-input-field" />
                                </div>
                            </div> 
                        </div>
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Office Manager
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_office_manager_1" id="additional_office_manager_address_1" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   E-mail Address
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_email_1" id="additional_practice_email_1" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Phone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_phone_number_1" id="additional_practice_phone_number_1" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Phone Extension
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_phone_ext_1" id="additional_practice_phone_ext_1" class="text-input-field" />
                                </div>
                            </div>                             
                        </div>    
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   &nbsp;
                                </div>
                                <div class="provider-cell-field">
                                    &nbsp;
                                </div>
                            </div> 
                        </div>    
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   Practice Name
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_name_2" id="additional_practice_name_2" class="text-input-field" />
                                </div>
                            </div> 
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   Complete Address (Street, City, State, Zip Code)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_address_2" id="additional_practice_address_2" class="text-input-field" />
                                </div>
                            </div> 
                        </div>                    
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Office Manager
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_office_manager_2" id="additional_office_manager_address_2" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   E-mail Address
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_email_2" id="additional_practice_email_2" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Phone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_phone_number_2" id="additional_practice_phone_number_2" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Phone Extension
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_phone_ext_2" id="additional_practice_phone_ext_2" class="text-input-field" />
                                </div>
                            </div>                             
                        </div>    
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   &nbsp;
                                </div>
                                <div class="provider-cell-field">
                                    &nbsp;
                                </div>
                            </div> 
                        </div> 
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   Practice Name
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_name_3" id="additional_practice_name_3" class="text-input-field" />
                                </div>
                            </div> 
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   Complete Address (Street, City, State, Zip Code)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_address_3" id="additional_practice_address_3" class="text-input-field" />
                                </div>
                            </div> 
                        </div>                    
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Office Manager
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_office_manager_3" id="additional_office_manager_address_3" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   E-mail Address
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_email_3" id="additional_practice_email_3" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Phone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_phone_number_3" id="additional_practice_phone_number_3" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Phone Extension
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_phone_ext_3" id="additional_practice_phone_ext_3" class="text-input-field" />
                                </div>
                            </div>                             
                        </div>    
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   &nbsp;
                                </div>
                                <div class="provider-cell-field">
                                    &nbsp;
                                </div>
                            </div> 
                        </div>    
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   Practice Name
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_name_4" id="additional_practice_name_4" class="text-input-field" />
                                </div>
                            </div> 
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   Complete Address (Street, City, State, Zip Code)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_address_4" id="additional_practice_address_4" class="text-input-field" />
                                </div>
                            </div> 
                        </div>                    
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Office Manager
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_office_manager_4" id="additional_office_manager_address_4" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   E-mail Address
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_email_4" id="additional_practice_email_4" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Phone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_phone_number_4" id="additional_practice_phone_number_4" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Phone Extension
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_phone_ext_4" id="additional_practice_phone_ext_4" class="text-input-field" />
                                </div>
                            </div>                             
                        </div>    
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   &nbsp;
                                </div>
                                <div class="provider-cell-field">
                                    &nbsp;
                                </div>
                            </div> 
                        </div>   
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   Practice Name
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_name_5" id="additional_practice_name_5" class="text-input-field" />
                                </div>
                            </div> 
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                   Complete Address (Street, City, State, Zip Code)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_address_5" id="additional_practice_address_5" class="text-input-field" />
                                </div>
                            </div> 
                        </div>                    
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Office Manager
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_office_manager_5" id="additional_office_manager_address_5" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   E-mail Address
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_email_5" id="additional_practice_email_5" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                   Phone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_phone_number_5" id="additional_practice_phone_number_5" class="text-input-field" />
                                </div>
                            </div> 
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Phone Extension
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="additional_practice_phone_ext_5" id="additional_practice_phone_ext_5" class="text-input-field" />
                                </div>
                            </div>                             
                        </div>    
                        <br /><br /><br />
                </div>
            </div>
            </form>
        </div>
                            
        <div id="argus-provider-footer">
            &copy; 2017-present, Argus Dental &amp; Vision, all rights reserved
        </div>
        <script type="text/javascript">
            $('#new-provider-registration-form').on('change',function (evt) {
                if (evt.target && (evt.target.type == 'file')) {
                    $('#uploading-overlay').css('display','block');
                    (new EasyAjax('/argus/provider/attachment')).add('id','{$id}').add('attachment',evt.target.name).addFiles('attachment_file',evt.target).then(function (response) {
                        $('#uploading-overlay').css('display','none');
                    }).post();                    
                } else {
                    var ao = new EasyAjax('/argus/provider/save');
                    ao.add('id','{$id}');
                    ao.add(evt.target.name,ao.getValue(evt.target,'new-provider-registration-form'));
                    ao.then(function (response) {
                    }).post();
                }
            });
            {foreach from=$data item=value key=field}
                Argus.provider.set('new-provider-registration-form','{$field}',"{$value}")
            {/foreach}
            Argus.provider.toggle($E('#confirm-form-information'));
        </script>
    </body>
</html>