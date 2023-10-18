{assign var=client value=$client->load()}
{assign var=ipa_stuff value=$ipa->load()}
{assign var=location value=$location->load()}
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style="position: relative; margin-left: auto; margin-right: auto; padding: 10px; border-radius: 10px; background-color: ghostwhite; color: #333; width: 600px;">
                <form name="edit_ipa_location_form" id="edit_ipa_location_form" onclick="return false">
                    <input type="hidden" name="client_id" id="edit_ipa_client_id" value="{$client.id}" />
                    <input type="hidden" name="ipa_id" id="edit_ipa_id" value="{$ipa_stuff.id}" />
                    <input type="hidden" name="id" id="edit_location_id" value="{$location.id}" />
                    Client: <b>{$client.client}</b><br />
                    IPA: <b>{$ipa_stuff.ipa}</b><br /><br />
                    Location: <input type="text" name="location" id="edit_ipa_location_name" value="{$location.location}" /><br /><br /><br />
                    <button style="position: absolute; right: 5px; bottom: 5px" id="edit_location_name_submit" onclick="$('#desktop-lightbox').css('display','none')">&nbsp;Save&nbsp;</button>
                    <button style="position: absolute; left:  5px; bottom: 5px" onclick="$('#desktop-lightbox').css('display','none')">Cancel</button>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    new EasyEdits('/edits/vision/editlocation','vision-edit-location');
</script>
                        
