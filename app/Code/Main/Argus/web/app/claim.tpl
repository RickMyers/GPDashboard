
<div>
    <input v-model="PatientControlNumber" type="text" placeholder="Claim Number Lookup" style="background-color: lightcyan; padding: 2px; border: 1px solid #333; border-radius: 1px; width: 200px" /><button @click="fetch">Lookup</button>
    <hr />
    <!-- CLM_WMD_201002102032 -->
    <div class="claim-lookup-row">
        <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Claim Number
            </div>
            <div class="claim-lookup-data" >
                {{ claimNumber }}
            </div>
        </div>
       <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Claim Type
            </div>
            <div class="claim-lookup-data">
                {{ claimType }} &nbsp;
            </div>
        </div>
        <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Claim Status
            </div>
            <div class="claim-lookup-data">
                {{ claimStatus }}&nbsp;
            </div>
        </div>
       <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Service Date Range
            </div>
            <div class="claim-lookup-data">
                {{ serviceDateRange }}&nbsp;
            </div>
        </div>
       <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Status Date
            </div>
            <div class="claim-lookup-data">
                {{ statusDate }}&nbsp;
            </div>
        </div>            
    </div>
    <div class="claim-lookup-row">
        <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Total Billed Amount
            </div>
            <div class="claim-lookup-data">
                {{ totalBilledAmount }}&nbsp;
            </div>
        </div>
       <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Total Paid Amount
            </div>
            <div class="claim-lookup-data">
                {{ totalPaidAmount }}&nbsp;
            </div>
        </div>
       <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Authorization Number
            </div>
            <div class="claim-lookup-data">
                {{ authorizationNumber }}&nbsp;
            </div>
        </div>
       <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Authorization Used
            </div>
            <div class="claim-lookup-data">
                {{ authorizationUsed }}&nbsp;
            </div>
        </div>
       <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Paid Date
            </div>
            <div class="claim-lookup-data">
                {{ paidDate }}&nbsp;
            </div>
        </div>            
    </div>
    <div class="claim-lookup-row">
        <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Provider Name
            </div>
            <div class="claim-lookup-data">
                {{ providerFirstName }} {{ providerLastName }}&nbsp;
            </div>
        </div>
       <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Provider NPI
            </div>
            <div class="claim-lookup-data">
                {{ providerNPI }}&nbsp;
            </div>
        </div>
        <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Member Name
            </div>
            <div class="claim-lookup-data">
                {{ memberFirstName }} {{ memberLastName }}&nbsp;
            </div>
        </div>
       <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Member ID
            </div>
            <div class="claim-lookup-data">
                {{ memberID }}&nbsp;
            </div>
        </div>
        <div class="claim-lookup-cell" style="width: 20%">
            <div class="claim-lookup-header">
                Group GID
            </div>
            <div class="claim-lookup-data">
                {{ groupGID }}&nbsp;
            </div>
        </div>
    </div>    
</div>

