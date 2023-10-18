<br />
<form name="outreach_admin_form" id="outreach_admin_form" onsubmit="return false">
    <div style="position: relative;">
        <select name="outreach_admin_campaign" id="outreach_admin_campaign">
            <option value=""></option>
            {foreach from=$campaigns->involved() item=campaign}
                <option value="{$campaign.id}"> {$campaign.campaign} </option>
            {/foreach}                    
        </select><input type="text" name="outreach_admin_campaign_combo" id="outreach_admin_campaign_combo"/> <button class='outreach_add_campaign_button'> Add </button>
    </div>
    <br />
    <div id="current_campaign_assignments">

    </div>
</form>
<script type='text/javascript'>
    new EasyEdits('/edits/outreach/admincampaign','AdminCampaign');
    (function () {
        $('#outreach_admin_campaign').on('change',function (evt) {
            if ($(evt.target).val()) {
                (new EasyAjax('/outreach/contacts/assignments')).add('campaign_id',$(evt.target).val()).then(function (response) {
                    $('#current_campaign_assignments').html(response);
                }).post();
            }
        });
        $('.outreach_add_campaign_button').on('click',function (evt) {
            let desc = prompt('Please enter a description to add the campaign, or click cancel');
            if (desc) { 
                let ao = new EasyAjax('/outreach/campaign/add');
                ao.add('campaign',ao.getValue('outreach_admin_campaign')).add('description',desc).then(function (response) {
                   win.set(response);                    
                }).post();
            }
        });        
    })();
</script>