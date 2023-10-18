{assign var=client value=$client->load()}
{assign var=ipa value=$ipa->load()}
{assign var=location value=$location->load()}
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style="position: relative; margin-left: auto; margin-right: auto; padding: 10px; border-radius: 10px; background-color: ghostwhite; color: #333; width: 600px;">
                <form name="new_ipa_location_form" id="new_location_address_form" onclick="return false">
                    <input type="hidden" name="location_id" id="new_location_id" value="{$location_id}" />
                    <table>
                        <tr><td>Client: </td><td><b>{$client.client}</b></td></tr>
                        <tr><td>IPA: </td><td><b>{$ipa.ipa}</b></td></tr>
                        <tr><td>Location: </td><td><b>{$location.location}</b></td></tr>
                    </table><br />
                    <table>
                        <tr>
                            <td style="text-align: right; padding-right: 5px">New Address: </td>
                            <td><input type="text" name="address" id="new_location_address" placeholder="Address 1, City, State, Zip Code" value="" /></td>
                        </tr>
                        <tr>
                            <td style="text-align: right; padding-right: 5px">Location NPI:</td>
                            <td><input type="text" name="npi" id="new_address_npi" value="" /></td>
                        </tr>
                    </table>
                    <br /><br />
                    <button style="position: absolute; right: 5px; bottom: 5px" id="new_location_address_submit" onclick="$('#desktop-lightbox').css('display','none')">&nbsp;Save&nbsp;</button>
                    <button style="position: absolute; left:  5px; bottom: 5px" onclick="$('#desktop-lightbox').css('display','none')">Cancel</button>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    new EasyEdits('/edits/vision/newaddress','vision-new-address');
</script>
                        