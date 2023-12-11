<br /><br /><form name='hedis-calllist-upload-form' id='hedis-calllist-upload-form-{$window_id}' onsubmit='return false'>
    <fieldset style='padding: 20px;  width: 100%; min-width: 640px; max-width: 80%; font-size: 1.2em'><legend style='font-size: 1em; font-family: sans-serif; font-weight: bold'>Instructions</legend>
                Click on the form field below and select the file to upload.  The file will be processed to prime the HEDIS related calls in support of the campaign identified.<br /><br />
    
    <h2>Campaign: {$campaigns->getCampaign()}</h2>            
    <table>

        <tr>
            <td align="right" style="padding-right: 8px; font-size: 1.2em" valign='top'>
                Call Schedule
            </td>
            <td>
                <input type='file' name='counseling-schedule' id='counseling-schedule-{$window_id}' style='background-color: lightcyan; width: 300px; border: 1px solid #aaf; padding: 2px; border-radius: 2px' /><br />
            </td>
        </tr>
    </table>

    <input type="hidden"    name="campaign_id" id='dental_campaign_id-{$window_id}}' value='{$campaigns->getId()}' />
    <input type="checkbox" name='add_members' id='add_members-{$window_id}' value='Y' checked='true' /> - Check here if you wish to add these members to the HEDIS database (hint: you probably do)<br /><br />
    <input type='button' id='counseling-upload-submit-{$window_id}' value='Upload' class='blueButton' style='padding: 5px 10px; font-size: 1em;' />
    <div id="counseling-upload-message-{$window_id}" style="display: none; font-style: italic; color: #333; font-weight: bold;">
        Uploading... Please Wait...<br />
        <div style="width: 500px; border: 1px solid silver; position: relative;">
            <div id="upload-progress-bar" style="background-color: rgba(0,102,102,.5); height: 25px;width: 5px; position: relative;">
                
            </div>
            <div id="dental-upload-status" style="position: absolute; top: 6px; left: 5px"></div>
        </div>
    </div>
    </fieldset>
</form>
    <script type="text/javascript">

        $('#counseling-upload-submit-{$window_id}').on('click',function () {
            Argus.dental.upload.timer = window.setTimeout(Argus.dental.upload.status,2000);
            $('#counseling-upload-submit-{$window_id}').fadeOut();
            $('#counseling-upload-message-{$window_id}').fadeIn();
            (function (win) {
                (new EasyAjax('/dental/counseling/upload')).addForm('hedis-calllist-upload-form-{$window_id}').addFiles('schedule',$E('counseling-schedule-{$window_id}')).then(function (response) {
                    if (Argus.dental.upload.timer) {
                        window.clearTimeout(Argus.dental.upload.timer);
                    }
                    win._close();
                }).post()
            })(Desktop.window.list['{$window_id}']);            
        })
    </script>