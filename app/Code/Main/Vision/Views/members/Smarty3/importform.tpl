<table style='width:100%; height: 100%'>
    <tr>
        <td>
            <div style='margin-left: auto; margin-right: auto; width: 600px; padding: 20px; border: 1px solid silver; border-radius: 10px;'>
                <form name='vision_member_import_form' id='vision_member_import_form' onsubmit='return false'>
                    
                    <fieldset style='padding: 10px'><legend>Instructions</legend> 
                        This tool allows you to refresh the member list.  A summary of the members who have been removed from clients member list will be generated and  emailed to the 
                        HEDIS manager list.<br /><br />
                        <select name='client' id='vision_member_client' style='background-color: lightcyan; border: 1px solid #aaf; padding: 2px'>
                            <option value=''> Please choose a client from below</option>
                            {foreach from=$clients->fetch() item=client}
                                <option value='{$client.id}'>{$client.client}</option>
                            {/foreach}
                        </select><br />
                        Client<br /><br />
                        <input type='file' name='member_list' id="vision_member_list" style='background-color: lightcyan; border: 1px solid #aaf; padding: 2px; width:400px'/>
                        Member List (CSV)<br /><br />
                        <input type="button" id="member_import_submit" onclick="return false" value=" Upload " />
                        
                    </fieldset>
                    
                    
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    (function () {
        $('#member_import_submit').on('click',function () {
            var health_plan_id = $('#vision_member_client').val();
            if (health_plan_id) {
                var win = Desktop.whoami('vision_member_import_form');
                Desktop.window.list[win].splashScreen(Humble.template('vision/MemberImportWait'));
                (new EasyAjax('/vision/members/import')).add('health_plan_id',$('#vision_member_client').val()).addFiles('member_list',$E('vision_member_list')).then(function (response) {
                    Desktop.window.list[win].splashScreen(false);                    
                }).post();
                window.setTimeout(Argus.vision.member.importUpdate,1000);
            } else {
                alert("Please select the healthplan");
            }
        })
    })();
</script>
