{assign var=client value=$client->load()}
{assign var=ipa value=$ipa->load()}
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style="position: relative; margin-left: auto; margin-right: auto; padding: 10px; border-radius: 10px; background-color: ghostwhite; color: #333; width: 600px;">
                <form name="edit_ipa_form" id="edit_ipa_form" onclick="return false">
                    <input type="hidden" name="client_id" id="edit_ipa_client_id" value="{$client.id}" />
                    <input type="hidden" name="id" id="edit_ipa_id" value="{$ipa.id}" />
                    Client: {$client.client}<br /><br />
                    
                    IPA Name: <input type="text" name="ipa" id="edit_ipa_name" value="{$ipa.ipa}" /><br /><br /><br />
                    <button style="position: absolute; right: 5px; bottom: 5px" id="edit_ipa_name_submit" onclick="$('#desktop-lightbox').css('display','none')">&nbsp;Save&nbsp;</button>
                    <button style="position: absolute; left:  5px; bottom: 5px" onclick="$('#desktop-lightbox').css('display','none')">Cancel</button>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    new EasyEdits('/edits/vision/editipa','vision-edit-ipa');
</script>
                        
