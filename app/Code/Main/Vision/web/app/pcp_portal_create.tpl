<div class="pcp-portal-form">
    <fieldset><legend>Instructions</legend>
        This form creates a portal for a PCP.  It is useful for when the automatic process fails to create the portal.<br />
        <div class="pcp-portal-cell">
            <div class="pcp-portal-field">
                <input type="text"  v-model="first_name" class="pcp-portal-input" />
            </div>
            <div class="pcp-portal-descriptor">
                PCP First Name
            </div>
        </div>
        <div class="pcp-portal-cell">    
            <div class="pcp-portal-field">
                <input type="text"  v-model="last_name" class="pcp-portal-input" />
            </div>
            <div class="pcp-portal-descriptor">
                PCP Last Name
            </div>
        </div>
        <div class="pcp-portal-cell">    
            <div class="pcp-portal-field">
                <input type="text"  v-model="npi" class="pcp-portal-input" />
            </div>
            <div class="pcp-portal-descriptor">
                PCP NPI
            </div>
        </div>
        <div class="pcp-portal-cell">    
            <div class="pcp-portal-field">
                <br />
                <button @click="createPcpPortal()" > Create Portal </button>
            </div>
        </div>    
    </fieldset>
</div>