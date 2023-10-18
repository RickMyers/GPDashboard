<!DOCTYPE html>
<html>
        <head>
        <title>Dashboard | Argus</title>
        <link rel="shortcut icon" href="/images/argus/favicon.png" />
        <link rel='stylesheet' href='/css/bootstrap?cachebust=1526408690.9192'/>
        <!--link rel='stylesheet' href='/css/theme?cachebust=1526408690.9192'/-->
        <link rel="stylesheet" href="/css/widgets?cachebust=1526408690.9192" />
        <link rel='stylesheet' href='/css/desktop?cachebust=1526408690.9192'/>
        <link rel='stylesheet' href='/css/dashboard?cachebust=1526408690.9192'/>
        <style type="text/css">
            #argus-landing-logout-countdown {
                position: absolute; top: 10px; left: 10px; padding: 20px; border-radius: 20px;
                border: 1px solid #333; background-color: white; font-family: sans-serif;
                width: 220px; display: none; z-index: 1000
            }
            #landing-logout-countdown {
                font-size: 5em; font-family: monospace; color: #333; text-align: center;
            }
            div > i {
                color: #333; font-size: 22px
            }
            div:hover > i {
                color: #bc2328;
            }
            .landing-clock {
                float: right; margin-right: 30px; color: ghostwhite; margin-top: 12px; font-size: 1.75em
            }
            .dashboard-alert-icon {
                margin-left: 15px; opacity: .4
            }
        </style>
        <!--script type='text/javascript' src='/js/backbone'></script-->
        <script type="text/javascript">
            var UseTranparentWindows = '';
            var Branding = {
                icon: '/images/argus/argus_eye_white.png',
                name: 'Argus Dental',
                id: '2'
            }
        </script>
        <script type="text/javascript" src='/js/jquery?cachebust=1526408690.9192'></script>
        <script type='text/javascript' src='/js/argus?cachebust=1526408690.9192'></script>
        <script type='text/javascript' src='/js/bootstrap?cachebust=1526408690.9192'></script>
        <script type='text/javascript' src='/js/vue?cachebust=1526408690.9192'></script>
        <script type='text/javascript' src='/js/common?cachebust=1526408690.9192'></script>
        <script type='text/javascript' src='/js/desktop?cachebust=1526408690.9192'></script>
        <script type='text/javascript' src='/js/dashboard?cachebust=1526408690.9192'></script>
        <script type='text/javascript' src='/js/widgets?cachebust=1526408690.9192'></script>
        <script type='text/javascript' src='/js/sockets?cachebust=1526408690.9192'></script>
{assign var=status  value=false}
{assign var=data    value=false}
{assign var=dentist value=$role->userHasRole('DDS')}
{assign var=hygienist value=$role->userHasRole('Tele Hygienist')}
{foreach from=$form->consultationInformation() item=data}
    {assign var=form_id value=$data['form_id']}
{/foreach}
{assign var=window_id value="print-window"}
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
        <body>
<div id="dental-consultation-body" style="overflow: auto">


    <div id="dental-form-tab">
        <div id="dental-consultation-body">
            <form name="new-dental-consultation-form" id="new-dental-consultation-form-{$window_id}" onsubmit="return false">
                <input type="hidden" name="hygienist_signature"   id="hygienist_signature-{$window_id}" value="" />
                <input type="hidden" name="hygienist_signed_date" id="hygienist_signed_date-{$window_id}" value="" />
                <input type="hidden" name="hygienist_signed_time" id="hygienist_signed_time-{$window_id}" value="" />
                <input type="hidden" name="dentist_signature"         id="dentist_signature-{$window_id}" value="" />
                <input type="hidden" name="dentist_signed_date"       id="dentist_signed_date-{$window_id}" value="" />
                <input type="hidden" name="dentist_signed_time"       id="dentist_signed_time-{$window_id}" value="" />
                <div style="width: 1125px; padding-left: 10px; padding-right: 10px; margin-left: 10px; border-right: 1px solid #333">
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

                        </div><div class="dental-cell" style="width: 20%">
                            <div class="dental-cell-title">
                                Date Of Birth
                            </div>
                            <div class="dental-cell-content">
                                <input type="text" name="patient_dob" id="patient_dob-{$window_id}" class="form-field" style="width: 100%" value="" />
                            </div>

                        </div><div class="dental-cell" style="width: 20%">
                            <div class="dental-cell-title">
                                Exam Date
                            </div>
                            <div class="dental-cell-content">
                                <input type="text" name="consultation_date" id="consultation_date-{$window_id}" class="form-field" style="width: 100%" value="" />
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
                            <button id="hygienist-sign-button" onclick="Argus.dental.consultation.pin('hygienist','{$window_id}'); return false;" class="dental-signature-button" style="float: left; ">Hygienist Signature</button>
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
                            <button id="dentist-sign-button" onclick="Argus.dental.consultation.pin('dentist','{$window_id}'); return false" class="dental-signature-button" style="float: right; ">Dentist Signature</button>
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
<script type='text/javascript'>

    var Excedis = (function () {
        return  {
            load: function () {
                let form = $E('new-dental-consultation-form-{$window_id}');
                {foreach from=$data item=val key=var}
                    Argus.tools.value.set(form,'','{$var}','{$val|escape:javascript}');
                {/foreach}
                if ($('#patient_dob-{$window_id}').val()) {
                    $('#patient_dob-{$window_id}').val(Excedis.dateFormat($('#patient_dob-{$window_id}').val()));
                }
                if ($('#consultation_date-{$window_id}').val()) {
                    $('#consultation_date-{$window_id}').val(Excedis.dateFormat($('#consultation_date-{$window_id}').val()));
                }                
            },
            dateFormat: function (dval) {
                if (dval) {
                    var d = dval.split('-');
                    dval = d[1]+'/'+d[2]+'/'+d[0];
                }
                return dval;
            },
            teeth: {
                current: false,
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
                    Excedis.teeth.placeAdult(1,8,0,200,radian);
                    Excedis.teeth.placeAdult(9,16,90,200,radian);
                    Excedis.teeth.placeAdult(17,24,180,200,radian);
                    Excedis.teeth.placeAdult(25,32,270,200,radian);
                    Excedis.teeth.placeBaby(['A','B','C','D','E'],0,145,radian);
                    Excedis.teeth.placeBaby(['F','G','H','I','J'],90,145,radian);
                    Excedis.teeth.placeBaby(['K','L','M','N','O'],180,145,radian);
                    Excedis.teeth.placeBaby(['P','Q','R','S','T'],270,145,radian);
                }
            }
        };
    })();
    Excedis.load();
    Excedis.teeth.render(Excedis.teeth.center(Math.PI/180));
</script>
        </body>
</html>