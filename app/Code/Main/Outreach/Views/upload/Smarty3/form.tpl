<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style="margin-left: auto; margin-right: auto; width: 450px; padding: 20px; background-color: ghostwhite; color: #333; border-radius: 10px">
                <form name="outreach_member_upload_form" id="outreach_member_upload_form" onsubmit="return false">
                    <fieldset><legend>Instructions</legend>
                        <br />Upload a member list into the currently selected campaign<br /><br />
                        <input type="file" name="member_list" id="outreach_member_list" style="padding: 2px; border: 1px solid #aaf; background-color: lightcyan; font-size: .95em; color: #333;" /><br />
                        <div style="margin-bottom: 10px; letter-spacing: 1px; font-family: monospace; font-size: .9em">Member List</div>
                        <input type="file" name="map_file" id="outreach_map_file" style="padding: 2px; border: 1px solid #aaf; background-color: lightcyan; font-size: .95em; color: #333;" /><br />
                        <div style="margin-bottom: 10px; letter-spacing: 1px; font-family: monospace; font-size: .9em">Map File (optional)</div>
                        <input type="button" id="outreach_member_cancel" value="  Cancel  " style="float: right;" onclick="Argus.outreach.win.splashScreen(''); return false"/>
                        <input type="button" id="outreach_member_upload" value="  Upload  " />
                    </fieldset>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    (function () {
        $('#outreach_member_upload').on('click',function (evt) {
            if ($('#outreach_campaign').val()) {
                (new EasyAjax('/outreach/upload/members')).add('campaign_id',$('#outreach_campaign').val()).packageForm('outreach_member_upload_form').then(function (response) {
                    console.log(response);
                    Argus.outreach.win.splashScreen('');
                }).post();
            } else {
                alert('Choose a campaign first...');
            }
        });
    })();
</script>