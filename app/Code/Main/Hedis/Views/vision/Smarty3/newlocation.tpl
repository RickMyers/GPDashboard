{assign var=client value=$client->load()}
{assign var=ipa_stuff value=$ipa->load()}
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style="position: relative; margin-left: auto; margin-right: auto; padding: 10px; border-radius: 10px; background-color: ghostwhite; color: #333; width: 600px;">
                <form name="new_ipa_location_form" id="new_ipa_location_form" onclick="return false">
                    <input type="hidden" name="client_id" id="new_ipa_client_id" value="{$client.id}" />
                    <input type="hidden" name="ipa_id" id="new_ipa_id" value="{$ipa_stuff.id}" />
                    Client: <b>{$client.client}</b><br />
                    IPA: <b>{$ipa_stuff.ipa}</b><br /><br />
                    New Location: <input type="text" name="location" id="new_ipa_location_name" value="" /><br /><br /><br />
                    <button style="position: absolute; right: 5px; bottom: 5px" id="new_location_name_submit" onclick="$('#desktop-lightbox').css('display','none')">&nbsp;Save&nbsp;</button>
                    <button style="position: absolute; left:  5px; bottom: 5px" onclick="$('#desktop-lightbox').css('display','none')">Cancel</button>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    new EasyEdits('/edits/vision/newlocation','vision-new-location');
</script>
                        