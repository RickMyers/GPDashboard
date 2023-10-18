<br /><br />
Current Campaigns:
<ul>
{foreach from=$campaigns->fetch() item=campaign}
    <li>
        <input type='checkbox' id='dental_campaign_id_{$campaign.id}' value='Y' onclick='Argus.hedis.campaign.toggle("{$campaign.id}",this)' {if ($campaign.active == 'Y')}checked='checked'{/if} /> -
        {$campaign.campaign} 
    </li>
{/foreach}
</ul>
<form name='dental_add_campaign_form' id='dental_add_campaign_form' onsubmt="return false">
    <fieldset style="width: 500px"><legend style="color: ghostwhite; font-size: 1.1em">Add Campaign</legend>
        To create a new campaign, enter the name of the campaign below.  Please do not use the name of an already existing campaign.<br /><br />
        <input type="text" style="color: #333; background-color: lightcyan; padding: 2px; border-radius: 3px; border: 1px solid #aaf" name="campaign_name" id="new_dental_campaign_name" />
        <input type="button" style="color: #333" onclick="Argus.hedis.campaign.add()" value="New Campaign" />
    </fieldset>
</form>
    
