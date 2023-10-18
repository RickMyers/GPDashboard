<style type="text/css">
    .admin_required_row {
        white-space: nowrap; overflow: hidden; height: 35px;
    }
    .admin_required_cell {
        box-sizing: border-box; display: inline-block; margin-bottom: 1px; margin-right: 1px
    }
</style>
{{#each data}}
    <div onclick='Argus.vision.consultation.open("{{tag}}")' style='cursor: pointer; position: relative; background-color: rgba(222,222,222,{{zebra @index}})'>
        <div class="admin_required_cell" style="float: left;">
            <div style='position: relative; height: 70px; width: 70px; overflow: hidden; text-align: center'>
                <img onload='Argus.tools.image.align(this)' src='{{avatar}}' onerror="this.src='/images/argus/placeholder-{{creator_gender}}.png'" style='margin-left: auto; height: 100%; margin-right: auto' />
            </div>
            <div title="Print Form" style="display: block; position: absolute; top: 0px; left: 0px; overflow: hidden; border-radius: 10px; width: 20px; cursor: pointer; height: 20px; border: 1px solid silver; padding-left: 3px;;  background-color: ghostwhite">
                <img onclick="Argus.vision.consultation.print('{{form_id}}')" src="/images/vision/print.png" style="cursor: pointer; position: relative; top: -2px; width: 12px" />
            </div>
        </div>
        <div class="admin_required_row">
            <div class="admin_required_cell" style="width: 10%">
                <div class='nc_desc'>
                    Form/Event
                </div>
                <div class='nc_field'>
                    {{ id }}/ {{#if event_id}}{{ event_id }}{{ else }}N/A{{/if}}
                </div>                
            </div>
            <div class="admin_required_cell" style="width: 10%">
                <div class='nc_desc'>
                    Client
                </div>
                <div class='nc_field'>
                    {{screening_client}}&nbsp;
                </div>                
            </div>
            <div class="admin_required_cell" style="width: 10%">
                <div class='nc_desc'>
                    Member ID
                </div>
                <div class='nc_field'>
                    {{member_id}}&nbsp;
                </div>                
            </div>
            <div class="admin_required_cell" style="width: 20%">
                <div class='nc_desc'>
                    Name
                </div>
                <div class='nc_field'>
                    {{member_name}}&nbsp;
                </div>                
            </div>
            <div class="admin_required_cell" style="width: 10%">        
                <div class='nc_desc'>
                    Gender
                </div>
                <div class='nc_field'>
                    {{gender}}&nbsp;
                </div>                
            </div> 
            <div class="admin_required_cell" style="width: 10%">
                <div class='nc_desc'>
                    DOB
                </div>
                <div class='nc_field'>
                    {{date-of_birth}}&nbsp;
                </div>                
            </div>               
            <div class="admin_required_cell" style="width: 30%">
                <div class='nc_desc'>
                    Member Address
                </div>
                <div class='nc_field'>
                    {{member_address}}&nbsp;
                </div>                
                </td>
            </div>
        </div>    
        <div class="admin_required_row">    
            <div class="admin_required_cell" style="width: 10%">
                <div class='nc_desc'>
                    Submitted
                </div>
                <div class='nc_field'>
                    {{#if submitted}}
                            {{formatDate submitted "short"}}
                    {{else}}
                            &nbsp;
                    {{/if}}
                </div>
            </div>
            <div class="admin_required_cell" style="width: 20%">
                <div class='nc_desc'>
                    PCP
                </div>
                <div class='nc_field'>
                    Dr. {{primary_doctor_combo}};
                </div>                
            </div>            
            <div class="admin_required_cell" style="width: 30%">
                <div class='nc_desc'>
                    Encounter Location
                </div>
                <div class='nc_field'>
                    {{address_id_combo}}&nbsp;
                </div>                
            </div>                  
            <div class="admin_required_cell" style="width: 40%">
                <div class='nc_desc'>
                    Referral Reason
                </div>
                <div class='nc_field' style='font-weight: bold;'>
                    {{#if referral_reason }}
                            {{referral_reason}}
                    {{else}}
                            &nbsp;
                    {{/if}}
                </div>                
            </div>
        </div>
        
    </div>
    <div style="clear:both"></div>                
{{/each}}