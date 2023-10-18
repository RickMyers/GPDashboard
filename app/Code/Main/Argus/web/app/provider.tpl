<div>
    <input v-model="npi" type="text" placeholder="NPI to Lookup" style="background-color: lightcyan; padding: 2px; border: 1px solid #333; border-radius: 1px; width: 200px" /><button @click="fetch">Lookup</button>
    <hr />
    <!-- 1891272167 -->
    <div class="npi-lookup-row">
        <div class="npi-lookup-cell" style="width: 25%">
            <div class="npi-lookup-header">
                NPI Number
            </div>
            <div class="npi-lookup-data" v-html = "last_name">
                <b>{{ npi_display }}</b> &nbsp;
            </div>
        </div>
       <div class="npi-lookup-cell" style="width: 25%">
            <div class="npi-lookup-header">
                Provider Name
            </div>
            <div class="npi-lookup-data">
                {{ first_name }} {{ last_name }} &nbsp;
            </div>
        </div>
        <div class="npi-lookup-cell" style="width: 25%">
            <div class="npi-lookup-header">
                Provider Gender
            </div>
            <div class="npi-lookup-data">
                {{ gender }}&nbsp;
            </div>
        </div>
       <div class="npi-lookup-cell" style="width: 25%">
            <div class="npi-lookup-header">
                License/State
            </div>
            <div class="npi-lookup-data">
                {{ license }} / {{ state }}&nbsp;
            </div>
        </div>
      </div>
    <div class="npi-lookup-row">
        <div class="npi-lookup-cell" style="width: 25%">
            <div class="npi-lookup-header">
                Specialty Code
            </div>
            <div class="npi-lookup-data">
                {{ code }}&nbsp;
            </div>
        </div>
       <div class="npi-lookup-cell" style="width: 75%">
            <div class="npi-lookup-header">
                Specialty Description
            </div>
            <div class="npi-lookup-data">
                {{ specialty }}&nbsp;
            </div>
        </div>
     </div>
    <div class="npi-lookup-row">
        <div class="npi-lookup-cell" style="width: 75%">
            <div class="npi-lookup-header">
                Business Address
            </div>
            <div class="npi-lookup-data">
                {{ business_address }}&nbsp;
            </div>
        </div>
       <div class="npi-lookup-cell" style="width: 25%">
            <div class="npi-lookup-header">
                Business Phone
            </div>
            <div class="npi-lookup-data">
                {{ business_phone }}&nbsp;
            </div>
        </div>
     </div>
    <div class="npi-lookup-row">
        <div class="npi-lookup-cell" style="width: 75%">
            <div class="npi-lookup-header">
                Mailing Address
            </div>
            <div class="npi-lookup-data">
                {{ mailing_address }}&nbsp;
            </div>
        </div>
       <div class="npi-lookup-cell" style="width: 25%">
            <div class="npi-lookup-header">
                Mailing Phone
            </div>
            <div class="npi-lookup-data">
                {{ mailing_phone }}&nbsp;
            </div>
        </div>
         
    </div>    
</div>
