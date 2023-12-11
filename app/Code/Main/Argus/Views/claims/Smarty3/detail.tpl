<style type="text/css">
    .claim-data-section {
        background-color: rgba(202,202,202,.2); margin-bottom: 15px
    }
    .claim-data-header {
        padding: 10px 2px 10px 2px;  background-color: buttonface; color: #333; font-weight: bold
    }
    .claim-data-row {
        overflow: visible; white-space: nowrap
    }
    .claim-data-cell {
        width: 19.5%; margin-right: 2px; margin-bottom: 2px; display: inline-block; background-color: rgba(202,202,202,.2)
    }
    .claim-data-title {
        font-family: monospace; font-size: .9em; letter-spacing: 1px; padding: 2px
    }
    .claim-data-field {
        font-family: sans-serif; font-size: .95em; padding: 2px 2px 2px 20px; overflow: hidden; min-height: 20px
    }
</style>
<div id="claim_data_{$window_id}_nav"></div>
{assign var=details value=$claim->extendedData()}
<div class="claim-data-section" id="claim-data-tab-1-{$window_id}">
    <div class="claim-data-header">
        Claim Data
    </div>
    <div class="claim-data-row">
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Claim Number
            </div>
            <div class="claim-data-field">
                {$details.claim_number}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Claim File
            </div>
            <div class="claim-data-field">
                {$details.claim_file}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Client
            </div>
            <div class="claim-data-field">
                {$details.screening_client}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Form ID 
            </div>
            <div class="claim-data-field">
                {$details.form_id}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Form Type
            </div>
            <div class="claim-data-field">
                {$details.form_type|ucfirst}
            </div>
        </div>
    </div> 
    <div class="claim-data-row">
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Member Number
            </div>
            <div class="claim-data-field">
                {$details.member_number}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Member Name
            </div>
            <div class="claim-data-field">
                {$details.member_name}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Technician Name
            </div>
            <div class="claim-data-field">
                {$details.technician_name}
            </div>
        </div>            
        <div class="claim-data-cell">
            <div class="claim-data-title">
                IPA
            </div>
            <div class="claim-data-field">
                {$details.ipa_id_combo}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Location
            </div>
            <div class="claim-data-field">
                {$details.location_id_combo}
            </div>
        </div>
    </div>    

</div>
<div class="claim-data-section" id="claim-data-tab-2-{$window_id}">
    <div class="claim-data-header">
        Event Details
    </div>
    <div class="claim-data-row">
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Event Id
            </div>
            <div class="claim-data-field">
                
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Event Date
            </div>
            <div class="claim-data-field">
                
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Event Type
            </div>
            <div class="claim-data-field">
                
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                IPA
            </div>
            <div class="claim-data-field">
                {$details.ipa_id_combo}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Business Name
            </div>
            <div class="claim-data-field">
                {if (isset($details.business_name))}
                    {$details.business_name}
                {/if}
            </div>
        </div>
    </div>                        
</div>

<div class="claim-data-section" id="claim-data-tab-3-{$window_id}">
    <div class="claim-data-header">Aldera Details</div>
{if (isset($details.aldera_details))}
    <div class="claim-data-row">
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Claim Number
            </div>
            <div class="claim-data-field">
                {$details.aldera_details.claimNumber}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Claim Type
            </div>
            <div class="claim-data-field">
                {$details.aldera_details.claimType}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Patient Control Number
            </div>
            <div class="claim-data-field">
                {$details.aldera_details.patientControlNumber}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Claim Status
            </div>
            <div class="claim-data-field">
                {$claim->expandClaimStatus($details.aldera_details.claimStatus)}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Service Date Range
            </div>
            <div class="claim-data-field">
                {$details.aldera_details.serviceDateRange}
            </div>
        </div>
    </div>
    <div class="claim-data-row">
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Status Date
            </div>
            <div class="claim-data-field">
                {$details.aldera_details.statusDate}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Total Billed Amount
            </div>
            <div class="claim-data-field">
                {$details.aldera_details.totalBilledAmount}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Total Paid Amount
            </div>
            <div class="claim-data-field">
                <b>{$details.aldera_details.totalPaidAmount}</b>
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Authorization Number
            </div>
            <div class="claim-data-field">
                {$details.aldera_details.authorizationNumber}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Authorization Used
            </div>
            <div class="claim-data-field">
                {$details.aldera_details.statusDate}
            </div>
        </div>
    </div>    
    <div class="claim-data-row">
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Paid Date
            </div>
            <div class="claim-data-field">
                <b>{$details.aldera_details.paidDate}</b>
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Provider GID
            </div>
            <div class="claim-data-field">
                {$details.aldera_details.providerGID}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Group GID
            </div>
            <div class="claim-data-field">
                {$details.aldera_details.groupGID}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Member ID
            </div>
            <div class="claim-data-field">
                {$details.aldera_details.memberID}
            </div>
        </div>
        <div class="claim-data-cell">
            <div class="claim-data-title">
                Member Name
            </div>
            <div class="claim-data-field">
                {$details.aldera_details.memberLastName}, {$details.aldera_details.memberFirstName}
            </div>
        </div>
    </div>    
{/if}
</div>
<div class="claim-data-section" id="claim-data-tab-4-{$window_id}">
    Loading...
</div>
<script type="text/javascript">
    (function () {
        Desktop.window.list['{$window_id}']._scroll(true);
        var tabs = new EasyTab('claim_data_{$window_id}_nav',null,120)
        tabs.add('Aldera Data',null,'claim-data-tab-3-{$window_id}');
        var f = (function () {
            return function () {
                {if (isset($details.aldera_details.claimNumber))}
                (new EasyAjax('/argus/claims/dwh')).add('claim_number','{$details.aldera_details.claimNumber}').then(function (response) {
                    $('#claim-data-tab-4-{$window_id}').html(response);
                }).post();
                {else}
                    $('#claim-data-tab-4-{$window_id}').html('<h3>No DWH Data for that claim</h3>');
                {/if}
            }
        })();
        tabs.add('DWH Data',f,'claim-data-tab-4-{$window_id}');
        tabs.add('Event Data',null,'claim-data-tab-2-{$window_id}');
        tabs.add('Form Data',null,'claim-data-tab-1-{$window_id}');
        tabs.tabClick(0);
    })();
</script>