<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style="margin-left: auto; margin-right: auto; width: 460px; padding: 10px; border-radius: 10px; background-color: ghostwhite; color: #333">
                <form name="od_assignment_form" id="od_assignment_form" onsubmit="return false">
                As an O.D. with the HEDIS Vision Manager role, you can assign all of the Scanning forms in the queue to another O.D.<br/><br />
                
                Please choose an O.D. from the list below, or click <b>Cancel</b> to abort<br /><br/>
                
                <select name="assignee" id="assignee" style="background-color: lightcyan; width: 80%; border: 1px solid #aaf; padding: 2px">
                    <option value=""> </option>
                    {foreach from=$users->getUsersByRoleName('O.D.') item=user}
                        <option value="{$user.user_id}"> {$user.appellation} {$user.first_name} {$user.last_name} </option>
                    {/foreach}
                </select><br />
                <div style="">O.D. List</div><br />
                <center>
                Reassign <input type="text" name="number_to_reassign" id="number_to_reassign" style="background-color: lightcyan; width: 50px; text-align: center; border: 1px solid #aaf; padding: 2px"   value="{$forms->availableScanningForms()}"/> Forms.<br /><br />
                </center>
                <input type="button" name="assignment_button" id="assignment_button" value="  Assign  " style="float: right" onclick=""/>
                <input type="button" name="cancel_assignment_button" id="cancel_assignment_button" value="  Cancel  " onclick="Argus.dashboard.lightbox.close()"/>
                <div style="clear: both"></div>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    $('#assignment_button').on('click',function () {
        if ($('#assignee').val()) {
            (new EasyAjax('/vision/od/reassignment')).add('assignee',$('#assignee').val()).add('reassign',$('#number_to_reassign').val()).then(function (response) {
                Argus.dashboard.lightbox.close();
            }).post();
        } else {
            alert('Please choose an O.D. to assign these forms to');
        }
    });
</script>

