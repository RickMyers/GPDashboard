<!DOCTYPE html>
    <head>
        <title>Provider Register | Argus</title>
        <link rel="shortcut icon" href="/images/argus/favicon.png" />
        <link rel='stylesheet' href='/css/bootstrap'/>
        <link rel='stylesheet' href='/css/theme'/>
        <link rel="stylesheet" href="/css/jqueryui" />
        <link rel="stylesheet" href="/css/widgets" />
        <style type="text/css">
            .full {
                width: 100%
            }
            .half {
                width: 50%; display: inline-block
            }
            .third {
                width: 33.3%; display: inline-block
            }
            .quarter {
                width: 25%; display: inline-block
            }
            .fifth {
                width: 20%; display: inline-block
            }
            .sixth {
                width: 16%; display: inline-block
            }
            .seventh {
                width: 14%; display: inline-block
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
            $(window).resize(function () {
                var h = ((window.innerHeight || document.body.clientHeight || document.documentElement.clientHeight) - $E('argus-provider-banner').offsetHeight - $E('argus-provider-footer').offsetHeight);
                $('#form-content-layer').height(h);
                $('#provider-form-instructions-layer').height(h);
                $('#provider-form-layer').height(h);
            });
            $(document).ready(function () {
               $(window).resize(); 
               new EasyEdits('/edits/argus/newproviderrequest','new-provider-request-form');
            });
            
        </script>
    </head>
    <body>
        <div id="argus-provider-banner">
            <img src="/images/argus/argus_white.png" style="height: 45px; margin-top: 2px" />
        </div>
        <div id="form-content-layer">
            <div id="provider-form-instructions-layer"><div style='text-align: center; font-weight: bold'>Welcome to Argus New Provider Registration!</div>
                <br /><br />
                <b>Instructions</b>:<br /><br />Completing and submitting this form will generate an E-mail that will be sent to the specified E-mail address entered in the form.<br /><br />
                The E-mail will contain a link to the New Provider Registration form that will need to be completed before we can enter the provider into our network.
            <br /><br />
            For convenience, this new provider form automatically saves your data as you fill each field, allowing you to enter the data across multiple sittings. You can return to this form and continue filling it out through the link in the E-mail that was sent to you.
            <br /><br />
            </div>
            <div id="provider-form-layer">
                
                <table style='width: 100%; height: 100%'>
                    <tr>
                        <td>
                            <div style='width: 500px; border: 1px solid #777; border-radius: 20px; padding: 20px; margin-left: auto; margin-right: auto' id="registration-form-layer">
                                <form name="new-provider-registration-request" id="new-provider-registration-request" onsubmit="return false">
                                    <b>Provider Registration Request Form</b><br /><br />
                                    <input type="text" name="name" id="registrant_name" /><br />
                                    First and Last Name<br /><br />
                                    <input type="text" name="email" id="registrant_email" /><br />
                                    Provider E-Mail Address<br /><br />
                                    Please check all that you are interested in (at least one is required)<br /><br />
                                    <input type="checkbox" name="commercial" id="commercial" value='Y' /> Commercial&nbsp;&nbsp;
                                    <input type="checkbox" name="medicaid" id="medicaid" value='Y' /> Medicaid&nbsp;&nbsp;
                                    <input type="checkbox" name="medicare" id="medicare" value='Y' /> Medicare&nbsp;&nbsp;
                                    <input type="checkbox" name="fhk" id="fhk" value='Y' /> Florida Healthy Kids<br /><br />
                                    <input type="button" value="Submit Registration Form Request" id="provider_request_submit" name="provider_request_submit" />
                                </form>
                            </div> 
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="argus-provider-footer">
            &copy; 2017-present, Argus Dental &amp; Vision, all rights reserved
        </div>
        
    </body>
</html>