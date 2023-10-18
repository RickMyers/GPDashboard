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
                width: 90%; padding: 3px; background-color: lightcyan; border: 1px solid #777; color: #333; border-radius: 3px
            }
            .full {
                width: 100%
            }
            .cell {
                display: inline-block; border-right: 1px solid #777
            }
            .threequarter {
                    width: 74.5%; display: inline-block; border-right: 1px solid #777
            }
            .half {
                width: 49.5%; display: inline-block; border-right: 1px solid #777
            }
            .third {
                width: 33%; display: inline-block; border-right: 1px solid #777
            }
            .quarter {
                width: 24.5%; display: inline-block; border-right: 1px solid #777
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
               tabs.add('Questionnaire',null,'provider-form-questionnaire-tab');
               tabs.add('Release',null,'provider-form-release-tab');
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
            <img src="/images/argus/argus_white.png" style="height: 45px; margin-top: 2px" /><span style='position: relative; top: 4px; margin-left: 25px; color: ghostwhite; font-size: 2.1em'> Commercial Provider Registration </span>
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
                    
                    <br /><br /><br />
                    <center>
                        <h1>Checklist</h1>
                    </center>
                    <br />
                    <div style='padding-left: 100px'>
                    <div style='font-size: 1.5em; font-weight: bold'>
                        To ensure your application is processed as quickly as possible, please return the following items:
                    </div><br /><br />
                    <ul>
                    <p>
                        <input type='checkbox' name='checklist_1' id='checklist_1' value='Y' /> Completed and signed Provider Application
                    </p>
                    <p>
                        <input type='checkbox' name='checklist_2' id='checklist_2' value='Y' /> Completed and signed Provider Agreement
                    </p>
                    <p>
                        <input type='checkbox' name='checklist_3' id='checklist_3' value='Y' /> Current copy of License
                    </p>
                    <p>
                        <input type='checkbox' name='checklist_4' id='checklist_4' value='Y' /> Current copy of Federal DEA Certificate
                    </p>
                    <p>
                        <input type='checkbox' name='checklist_5' id='checklist_5' value='Y' /> Current copy of Controlled Substance Registration (CSR) (as applicable)
                    </p>
                    <p>
                        <input type='checkbox' name='checklist_6' id='checklist_6' value='Y' /> Current copy of Professional Malpractice Liability Certificate of Insurance
                    </p>
                    <p>
                        <input type='checkbox' name='checklist_7' id='checklist_7' value='Y' /> Current copy of Board Certification (as applicable)
                    </p>
                    <p>
                        <input type='checkbox' name='checklist_8' id='checklist_8' value='Y' /> Copy of Specialty diploma or certificate (as applicable)
                    </p>
                    </ul>
                    <br /><br /><br />

                    </div>
                    <center>
                    &copy; 2017 Argus Dental &amp; Vision, Inc., Proprietary &amp; Confidential
                    </center>                    
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
                            <div class="full">
                                <div class="provider-cell-header">
                                    Provider's Name (include suffix: Jr., Sr., III):
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="providers_name" id="providers_name" class="text-input-field" />
                                </div>
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Main/Other Name (if applicable):
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="maiden_name" id="maiden_name" class="text-input-field" />
                                </div>
                            </div>
                            <div class="half">
                                <div class="provider-cell-header">
                                    Relationship
                                </div>
                                <div class="provider-cell-field">
                                    <div class="quarter"><input type="checkbox" name="provider_is_owner" id="provider_is_owner" class="" /> Owner</div>
                                    <div class="third"><input type="checkbox" name="provider_is_owner" id="provider_is_owner" class="" /> Associate</div>
                                    <div class="third" style="border-right: 0px"><input type="checkbox" name="provider_is_owner" id="provider_is_owner" class="" /> Employee</div>
                                </div>
                            </div>
                            
                        </div>
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    SSN:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_ssn" id="provider_ssn" class="text-input-field" />
                                </div>
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    TIN (if different):
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_tin" id="provider_tin" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    DOB
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_dob" id="provider_dob" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Gender
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="provider_gender" id="provider_gender_male" class="" value="M" /> Male&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="provider_gender" id="provider_gender_female" class="" value="F" /> Female

                                </div> 
                            </div>                            
                        </div>    
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    E-Mail:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_email" id="provider_email" class="text-input-field" />
                                </div>
                            </div>
                            <div class="half">
                                <div class="provider-cell-header">
                                    Individual NPI:
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_npi" id="provider_npi" class="text-input-field" />
                                </div> 
                            </div>
                        </div>         
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Provider Type 
                            </div>
                        </div>  
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    <input type="checkbox" id="dental_provider" name="dental_provider" value="Y" /> Dental<br /><br />
                                </div>
                            </div>
                            <div class="quarter" style="vertical-align: top">
                                <div class="provider-cell-header" style="text-align: justify">
                                    <input type="checkbox" id="dental_provider_general_dentist" name="dental_provider_general_dentist" value="Y" />&nbsp;General&nbsp;Dentist&nbsp;&nbsp;&nbsp;<br /><br />
                                </div>
                            </div>
                            <div class="half" style="vertical-align: top">
                                <div class="provider-cell-header" style="text-align: justify">
                                    <input type="checkbox" id="dental_provider_specialty" name="dental_provider_specialty" value="Y" />&nbsp;Specialty&nbsp;&nbsp;&nbsp
                                    <div style="float: right">
                                        <input type="checkbox" id="dental_provider_specialty_endo" name="dental_provider_specialty_endo" value="Y" />&nbsp;Endo&nbsp;&nbsp;&nbsp;
                                        <input type="checkbox" id="dental_provider_specialty_perio" name="dental_provider_specialty_perio" value="Y" />&nbsp;Perio&nbsp;&nbsp;&nbsp;
                                        <input type="checkbox" id="dental_provider_specialty_prostho" name="dental_provider_specialty_prostho" value="Y" />&nbsp;Prostho&nbsp;&nbsp;&nbsp;<br />
                                        <input type="checkbox" id="dental_provider_specialty_pedo" name="dental_provider_specialty_pedo" value="Y" />&nbsp;Pedo&nbsp;&nbsp;&nbsp;
                                        <input type="checkbox" id="dental_provider_specialty_oral_surgery" name="dental_provider_specialty_oral_surgery" value="Y" />&nbsp;Oral&nbsp;Surgery&nbsp;&nbsp;&nbsp;
                                        <input type="checkbox" id="dental_provider_specialty_ortho" name="dental_provider_specialty_ortho" value="Y" />&nbsp;Ortho&nbsp;&nbsp;&nbsp;
                                    </div>
                                    <div style="clear: both"></div>
                                </div>
                            </div>                            
                        </div>                           
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    <input type="checkbox" id="vision_provider" name="vision_provider" value="Y" /> Vision<br /><br /><br /><br /><br />
                                </div>
                            </div>
                            <div class="threequarter" style="vertical-align: top">
                                <div class="provider-cell-header" style="text-align: justify; border-bottom: 1px solid #777; padding: 5px">
                                    <input type="checkbox" id="vision_provider_routine_vision" name="vision_provider_routine_vision" value="Y" />&nbsp;Routine&nbsp;Vision&nbsp;&nbsp;&nbsp;
                                    <input type="checkbox" id="vision_provider_medical_surgical" name="vision_provider_medical_surgical" value="Y" />&nbsp;Medical&nbsp;and&nbsp;Surgical&nbsp;&nbsp;&nbsp;
                                    <input type="checkbox" id="vision_provider_medical_only" name="vision_provider_medical_only" value="Y" />&nbsp;Medical&nbsp;Only&nbsp;&nbsp;&nbsp;
                                    <input type="checkbox" id="vision_provider_surgical_only" name="vision_provider_surgical_only" value="Y" />&nbsp;Surgical&nbsp;Only&nbsp;&nbsp;&nbsp;<br />
                                    <input type="checkbox" id="vision_provider_facility" name="vision_provider_facility" value="Y" />&nbsp;Optician/Optical&nbsp;Facility&nbsp;&nbsp;&nbsp;
                                </div>
                                <div class="provider-cell-header" style="text-align: justify; padding: 10px 5px;">
                                    <div style="float: left; ">
                                        <input type="checkbox" id="vision_provider_ophthalmologist" name="vision_provider_ophthalmologist" value="Y" />&nbsp;Ophthalmologist&nbsp;&nbsp;&nbsp;
                                        <input type="checkbox" id="vision_provider_specialty" name="vision_provider_specialty" value="Y" />&nbsp;Specialty&nbsp;&nbsp;&nbsp;<br />
                                        <input type="checkbox" id="vision_provider_optometrist" name="vision_provider_optometrist" value="Y" />&nbsp;Optometrist&nbsp;&nbsp;&nbsp;
                                    </div>
                                    <div style="float: right">
                                        <input type="checkbox" id="vision_provider_specialty_cornea" name="vision_provider_specialty_cornea" value="Y" />&nbsp;Cornea&nbsp;&nbsp;&nbsp;
                                        <input type="checkbox" id="vision_provider_specialty_glaucoma" name="vision_provider_specialty_glaucoma" value="Y" />&nbsp;Glaucoma&nbsp;&nbsp;&nbsp;
                                        <input type="checkbox" id="vision_provider_specialty_oculoplastic" name="vision_provider_specialty_oculoplastic" value="Y" />&nbsp;Oculoplastic&nbsp;&nbsp;&nbsp;<br />
                                        <input type="checkbox" id="vision_provider_specialty_retina" name="vision_provider_specialty_retina" value="Y" />&nbsp;Retina&nbsp;&nbsp;&nbsp;
                                        <input type="checkbox" id="vision_provider_specialty_neuro" name="vision_provider_specialty_neuro" value="Y" />&nbsp;Neuro&nbsp;&nbsp;&nbsp;
                                        <input type="checkbox" id="vision_provider_specialty_pedo" name="vision_provider_specialty_pedo" value="Y" />&nbsp;Pedo&nbsp;&nbsp;&nbsp;
                                    </div>
                                    <div style="clear: both"></div>
                                </div>
                            </div>
                        </div>                            
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Professional Training
                            </div>
                        </div>  
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Professional School
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_professional_school" id="provider_professional_school" class="text-input-field" />
                                </div>
                            </div>
                        </div>         
                        <div class="provider-row">
                            <div class="threequarter">
                                <div class="provider-cell-header">
                                    Degree
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_degree" id="provider_professional_degree" class="text-input-field" />
                                </div>
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Year Graduated
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_year_graduated" id="provider_year_graduated" class="text-input-field" />
                                </div> 
                            </div>
                        </div>         
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Residency Program (if applicable)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_residency_program" id="provider_residency_program" class="text-input-field" />
                                </div>
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    From Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_residency_from_date" id="provider_residency_from_date" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    To Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_residency_to_date" id="provider_residency_to_date" class="text-input-field" />
                                </div> 
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Advanced Training (if applicable)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_advanced_training" id="provider_advanced_training" class="text-input-field" />
                                </div>
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    From Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_advanced_training_from_date" id="provider_advanced_training_from_date" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    To Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_advanced_training_to_date" id="provider_advanced_training_to_date" class="text-input-field" />
                                </div> 
                            </div>                            
                        </div>     
                        <div class="provider-row">
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Board Certified
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="provider_board_certified" id="provider_board_certified_yes" value="Y" />&nbsp;Yes&nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="provider_board_certified" id="provider_board_certified_no" value="N" />&nbsp;No
                                </div>
                            </div>
                            <div class="threequarter">
                                <div class="provider-cell-header">
                                    Board
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_board_certified_name" id="provider_board_certified_name" class="text-input-field" />
                                </div> 
                            </div>
                        </div>                              
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Licensing Information
                            </div>
                        </div>  
                        <div class="provider-row">
                            <div class="fifth" style="float: left">
                                <div class="provider-cell-header">
                                    <span id="license_certificate_1_link"><b>State Licenses</b></span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type='file' name='license_certificate_1' id='license_certificate_1' value='' class='text-input-field' />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    State
                                </div>
                                <div class="provider-cell-field">
                                    <select name="provider_license_state_1" id="provider_license_" class="text-input-field" >
                                        <option value=""> </option>
                                        <option value="FL"> Florida [FL] </option>
                                        <option value="GA"> Georgia [GA] </option>
                                    </select>
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    License Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_number_1" id="provider_license_number_1" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Effective Date
                                </div>
                                <div class="provider-cell-field">
                                     <input type="text" name="provider_license_effective_1" id="provider_license_effective_1" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Expiration Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_expiration_1" id="provider_license_expiration_1" class="text-input-field" />
                                </div> 
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="fifth" style="float: left">
                                <div class="provider-cell-header">
                                    <span id="license_certificate_2_link"><b>State Licenses</b></span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type='file' name='license_certificate_2' id='license_certificate_2' value='' class='text-input-field' />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    State
                                </div>
                                <div class="provider-cell-field">
                                    <select name="provider_license_state_2" id="provider_license_state_2" class="text-input-field" >
                                        <option value=""> </option>
                                        <option value="FL"> Florida [FL] </option>
                                        <option value="GA"> Georgia [GA] </option>
                                    </select>
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    License Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_number_2" id="provider_license_number_2" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Effective Date
                                </div>
                                <div class="provider-cell-field">
                                     <input type="text" name="provider_license_effective_2" id="provider_license_effective_2" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Expiration Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_expiration_2" id="provider_license_expiration_2" class="text-input-field" />
                                </div> 
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="fifth" style="float: left">
                                <div class="provider-cell-header">
                                    <span id="license_certificate_3_link"><b>State Licenses</b></span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type='file' name='license_certificate_3' id='license_certificate_3' value='' class='text-input-field' />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    State
                                </div>
                                <div class="provider-cell-field">
                                    <select name="provider_license_state_3" id="provider_license_state_3" class="text-input-field" >
                                        <option value=""> </option>
                                        <option value="FL"> Florida [FL] </option>
                                        <option value="GA"> Georgia [GA] </option>
                                    </select>
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    License Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_number_3" id="provider_license_number_3" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Effective Date
                                </div>
                                <div class="provider-cell-field">
                                     <input type="text" name="provider_license_effective_3" id="provider_license_effective_3" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Expiration Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_expiration_3" id="provider_license_expiration_3" class="text-input-field" />
                                </div> 
                            </div>
                        </div> 
                        <div style="clear: both"></div>
                        <div class="provider-row">
                            <div class="fifth" style="vertical-align: top">
                                <div class="provider-cell-header">
                                    <span id="provider_dea_certificate_link"><b>DEA Certificate</b></span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="provider_dea_certificate" id="provider_dea_certificate" class="text-input-field" />
                                </div>                                 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Certificate Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_dea_certificate" id="provider_license_dea_certificate" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Effective Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_dea_certificate_effective_date" id="provider_license_dea_certificate_effective_date" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Expiration Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_dea_certificate_expiration_date" id="provider_license_dea_certificate_expiration_date" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Applicable
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="provider_license_dea_certificate_applicable" id="provider_license_dea_certificate_applicable_yes" value="Y" />&nbsp;Yes&nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="provider_license_dea_certificate_applicable" id="provider_license_dea_certificate_applicable_no" value="N" />&nbsp;No
                                </div> 
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    <span id="provider_csc_certificate_link"><b>Controlled Substances Cert</b></span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="provider_csc_certificate" id="provider_csc_certificate" class="text-input-field" />
                                </div>                                 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Certificate Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_csc_certificate" id="provider_license_csc_certificate" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Effective Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_csc_certificate_effective_date" id="provider_license_csc_certificate_effective_date" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Expiration Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_csc_certificate_expiration_date" id="provider_license_csc_certificate_expiration_date" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Applicable
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="provider_license_csc_certificate_applicable" id="provider_license_csc_certificate_applicable_yes" value="Y" />&nbsp;Yes&nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="provider_license_csc_certificate_applicable" id="provider_license_csc_certificate_applicable_no" value="N" />&nbsp;No
                                </div> 
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="fifth" style="vertical-align: top">
                                <div class="provider-cell-header">
                                    <span id="provider_gap_certificate_link"><b>General Anesthesia Permit</b></span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="provider_gap_certificate" id="provider_gap_certificate" class="text-input-field" />
                                </div>                                 
                                
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Certificate Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_gap_certificate" id="provider_license_gap_certificate" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Effective Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_gap_certificate_effective_date" id="provider_license_gap_certificate_effective_date" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Expiration Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_gap_certificate_expiration_date" id="provider_license_gap_certificate_expiration_date" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Applicable
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="provider_license_gap_certificate_applicable" id="provider_license_gap_certificate_applicable_yes" value="Y" />&nbsp;Yes&nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="provider_license_gap_certificate_applicable" id="provider_license_gap_certificate_applicable_no" value="N" />&nbsp;No
                                </div> 
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="fifth" style="vertical-align: top">
                                <div class="provider-cell-header">
                                    <span id="provider_cpr_certificate_link"><b>CPR Certificate</b></span>
                                </div>
                                <div class="provider-cell-field">
                                    <input type="file" name="provider_cpr_certificate" id="provider_cpr_certificate" class="text-input-field" />
                                </div>                                 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Certificate Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_cpr_certificate" id="provider_license_cpr_certificate" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Effective Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_cpr_certificate_effective_date" id="provider_license_cpr_certificate_effective_date" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Expiration Date
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_license_cpr_certificate_expiration_date" id="provider_license_cpr_certificate_expiration_date" class="text-input-field" />
                                </div> 
                            </div>
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Applicable
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="provider_license_cpr_certificate_applicable" id="provider_license_cpr_certificate_applicable_yes" value="Y" />&nbsp;Yes&nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="provider_license_cpr_certificate_applicable" id="provider_license_cpr_certificate_applicable_no" value="N" />&nbsp;No
                                </div> 
                            </div>
                        </div>                        
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Privileges&nbsp;&nbsp;&nbsp;
                                <input type="checkbox" id="provider_privileges_hospital" name="provider_privileges_hospital" value="Y" /> Hospital&nbsp;&nbsp;&nbsp;
                                <input type="checkbox" id="provider_privileges_asc" name="provider_privileges_asc" value="Y" /> Ambulatory&nbsp;Surgical&nbsp;Center&nbsp;&nbsp;&nbsp;
                                <input type="checkbox" id="provider_privileges_admitting" name="provider_privileges_admitting" value="Y" /> Admitting&nbsp;Agreement&nbsp;&nbsp;&nbsp;
                                <input type="checkbox" id="provider_privileges_applicable" name="provider_privileges_applicable" value="Y" /> Applicable&nbsp;&nbsp;&nbsp;
                            </div>
                        </div>  
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Hospital Name
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_privileges_hospital_name" id="provider_privileges_hospital_name" class="text-input-field"  />
                                </div>
                            </div>
                            <div class="half">
                                <div class="provider-cell-header">
                                    Address (street, city, state, zip)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_privileges_hospital_address" id="provider_privileges_hospital_address" class="text-input-field"  />
                                </div> 
                            </div>
                        </div>  
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    City
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_privileges_hospital_city" id="provider_privileges_hospital_city" class="text-input-field"  />
                                </div>
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    State
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_privileges_hospital_state" id="provider_privileges_hospital_state" class="text-input-field"  />
                                </div> 
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Zip Code
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_privileges_hospital_zipcode" id="provider_privileges_hospital_zipcode" class="text-input-field"  />
                                </div> 
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Phone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_privileges_hospital_phonenumber" id="provider_privileges_hospital_phonenumber" class="text-input-field"  />
                                </div>
                            </div>
                            <div class="half">
                                <div class="provider-cell-header">
                                    Contact Name
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_privileges_hospital_contact" id="provider_privileges_hospital_contact" class="text-input-field"  />
                                </div> 
                            </div>
                        </div>  
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    Date Privileges Granted
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_privileges_date_granted" id="provider_privileges_date_granted" class="text-input-field"  />
                                </div>
                            </div>
                            <div class="half">
                                <div class="provider-cell-header">
                                    Type of Privileges
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_privileges_type" id="provider_privileges_type" class="text-input-field"  />
                                </div> 
                            </div>
                        </div>                          
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Work History <div  style="float: right; width: 85%">In lieu of completing the section below, you may attach a resume or Curriculum Vitae.  To be acceptable, <u>Resume
                                        or Curriculum Vitae must show last 5 years of employment, including CURRENT EMPLOYMENT, and both MONTHS and YEARS Sof employment</u>.</div>
                                <div style="clear: both"></div>
                            </div>
                        </div>  
                        <div class="provider-row">
                            <div class="provider-cell-field" style="font-family: arial; font-size: 1em; text-align: center">
                                Please include <b>CURRENT EMPLOYMENT</b>.  Explain any gaps of six (6) months or more on a separate piece of paper.   Must list last 5 years of employment.
                            </div>
                        </div>
                        <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Dates From/To
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_dates_1" id="provider_work_history_dates_1" class="text-input-field"  />
                                </div>
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Employer
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_employer_1" id="provider_work_history_employer_1" class="text-input-field"  />
                                </div> 
                            </div>
                            <div class="cell" style="width: 39%;">
                                <div class="provider-cell-header">
                                    Address (street, city, state, zip)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_address_1" id="provider_work_history_address_1" class="text-input-field"  />
                                </div> 
                            </div>
                            <div class="cell" style="width: 15%">
                                <div class="provider-cell-header">
                                    Phone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_phone_number_1" id="provider_work_history_phone_number_1" class="text-input-field"  />
                                </div> 
                            </div>                                
                        </div>
                        <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Dates From/To
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_dates_2" id="provider_work_history_dates_2" class="text-input-field"  />
                                </div>
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Employer
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_employer_2" id="provider_work_history_employer_2" class="text-input-field"  />
                                </div> 
                            </div>
                            <div class="cell" style="width: 39%;">
                                <div class="provider-cell-header">
                                    Address (street, city, state, zip)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_address_2" id="provider_work_history_address_2" class="text-input-field"  />
                                </div> 
                            </div>
                            <div class="cell" style="width: 15%">
                                <div class="provider-cell-header">
                                    Phone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_phone_number_2" id="provider_work_history_phone_number_2" class="text-input-field"  />
                                </div> 
                            </div>                                
                        </div>
                        <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Dates From/To
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_dates_3" id="provider_work_history_dates_3" class="text-input-field"  />
                                </div>
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Employer
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_employer_3" id="provider_work_history_employer_3" class="text-input-field"  />
                                </div> 
                            </div>
                            <div class="cell" style="width: 39%;">
                                <div class="provider-cell-header">
                                     Address (street, city, state, zip)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_address_3" id="provider_work_history_address_3" class="text-input-field"  />
                                </div> 
                            </div>
                            <div class="cell" style="width: 15%">
                                <div class="provider-cell-header">
                                    Phone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_phone_number_3" id="provider_work_history_phone_number_3" class="text-input-field"  />
                                </div> 
                            </div>                                
                        </div>                        
                        <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Dates From/To
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_dates_4" id="provider_work_history_dates_4" class="text-input-field"  />
                                </div>
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Employer
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_employer_4" id="provider_work_history_employer_4" class="text-input-field"  />
                                </div> 
                            </div>
                            <div class="cell" style="width: 39%;">
                                <div class="provider-cell-header">
                                    Address (street, city, state, zip)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_address_4" id="provider_work_history_address_4" class="text-input-field"  />
                                </div> 
                            </div>
                            <div class="cell" style="width: 15%">
                                <div class="provider-cell-header">
                                    Phone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_phone_number_4" id="provider_work_history_phone_number_4" class="text-input-field"  />
                                </div> 
                            </div>                                
                        </div> 
                        <div class="provider-row">
                            <div class="fifth">
                                <div class="provider-cell-header">
                                    Dates From/To
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_dates_5" id="provider_work_history_dates_5" class="text-input-field"  />
                                </div>
                            </div>
                            <div class="quarter">
                                <div class="provider-cell-header">
                                    Employer
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_employer_5" id="provider_work_history_employer_5" class="text-input-field"  />
                                </div> 
                            </div>
                            <div class="cell" style="width: 39%;">
                                <div class="provider-cell-header">
                                    Address (street, city, state, zip)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_address_5" id="provider_work_history_address_5" class="text-input-field"  />
                                </div> 
                            </div>
                            <div class="cell" style="width: 15%">
                                <div class="provider-cell-header">
                                    Phone Number
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="provider_work_history_phone_number_5" id="provider_work_history_phone_number_5" class="text-input-field"  />
                                </div> 
                            </div>                                
                        </div> 
                        <div class="provider-row">
                            <div class="provider-form-header">
                                Practice Information
                            </div>
                        </div>  
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Practice Type 
                                </div>
                                <div class="provider-cell-field">
                                    <input type="radio" name="practice_type" id="practice_type_solo" value='solo' /> Solo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="practice_type" id="practice_type_partnership" value='partnership' /> Partnership&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="practice_type" id="practice_type_corporation" value='corporation' /> Professional&nbsp;Corporation&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="radio" name="practice_type" id="practice_type_other"  value='other'/> Other: 
                                    <input type="text" name="practice_type_other_value" id="practice_type_other_value" value="" class="text-input-field" style="width: 220px" />
                                </div>
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Corporation's Name (if applicable): 
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="corporation_name" id="corporation_name" value="" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="half">
                                <div class="provider-cell-header">
                                    TIN
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="practice_tin" id="practice_tin" value="" class="text-input-field" />
                                </div>
                            </div>                            
                            <div class="half">
                                <div class="provider-cell-header">
                                    Group NPI
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="practice_group_npi" id="practice_group_npi" value="" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Practice Name 
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="practice_name" id="practice_name" value="" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Mailing Address (street, city, state, zip)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="practice_mailing_address" id="practice_mailing_address" value="" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>
                        <div class="provider-row">
                            <div class="full">
                                <div class="provider-cell-header">
                                    Billing Address (street, city, state, zip)
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="practice_billing_address" id="practice_billing_address" value="" class="text-input-field" />
                                </div>
                            </div>                            
                        </div>  
                        <div class="provider-row">
                            <div class="third">
                                <div class="provider-cell-header">
                                    Business Contact
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="business_contact" id="business_contact" value="" class="text-input-field" />
                                </div>
                            </div>                 
                            <div class="third">
                                <div class="provider-cell-header">
                                    E-Mail Address
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="business_contact_email" id="business_contact_email" value="" class="text-input-field" />
                                </div>
                            </div>
                            <div class="sixth">
                                <div class="provider-cell-header">
                                    Phone
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="business_contact_phone" id="business_contact_phone" value="" class="text-input-field" />
                                </div>
                            </div>
                            <div class="sixth">
                                <div class="provider-cell-header">
                                    Fax
                                </div>
                                <div class="provider-cell-field">
                                    <input type="text" name="business_contact_fax" id="business_contact_fax" value="" class="text-input-field" />
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
                                    Complete Address (street, city, state, zip)
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
                    </div>
                    <br /><br /><br /><br />
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