{assign var=client value=$client->load()}
{assign var=ipa value=$ipa->load()}
{assign var=location value=$location->load()}
{assign var=address value=$address->load()}
{assign var=npi value=$npi->load(true)}
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div style="position: relative; margin-left: auto; margin-right: auto; padding: 10px; border-radius: 10px; background-color: ghostwhite; color: #333; width: 600px;">
                <form name="edit_ipa_location_form" id="edit_location_address_form" onclick="return false">
                    <input type="hidden" name="location_id" id="edit_location_id" value="{$location.id}" />
                    <input type="hidden" name="id" id="edit_address_id" value="{$address.id}" />
                    <input type="hidden" name="npi_id" id="edit_npi_id" value="{$npi.id}" />
                    <table>
                        <tr><td>Client: </td><td><b>{$client.client}</b></td></tr>
                        <tr><td>IPA: </td><td><b>{$ipa.ipa}</b></td></tr>
                        <tr><td>Location: </td><td><b>{$location.location}</b></td></tr>
                    </table><br />
                    <table>
                        <tr>
                            <td style="text-align: right; padding-right: 5px">New Address: </td>
                            <td><input type="text" name="address" id="edit_location_address" placeholder="Address 1, City, State, Zip Code" value="{$address.address}" /></td>
                        </tr>
                        <tr>
                            <td style="text-align: right; padding-right: 5px">Location NPI:</td>
                            <td><input type="text" name="npi" id="edit_address_npi" value="{$npi.npi}" /></td>
                        </tr>
                    </table>
                    <br /><br />
                    <button style="position: absolute; right: 5px; bottom: 5px" id="edit_location_address_submit" onclick="$('#desktop-lightbox').css('display','none')">&nbsp;Save&nbsp;</button>
                    <button style="position: absolute; left:  5px; bottom: 5px" onclick="$('#desktop-lightbox').css('display','none')">Cancel</button>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    new EasyEdits('/edits/vision/editaddress','vision-edit-address');
</script>
                        
