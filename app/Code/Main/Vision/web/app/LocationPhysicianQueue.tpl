<style type="text/css">
    .nc_field {
        overflow: hidden; font-family: sans-serif; font-size: .85em; padding: 2px 2px 2px 10px; border-right: 1px solid rgba(202,202,202,.3); display: inline-block; margin: 0px
    }
</style>
{{#each data}}
    <div onclick='Argus.vision.consultation.open("{{tag}}")' style='position: relative; cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}}); white-space: nowrap; margin-bottom: 1px;'>
        <div class="nc_field" onclick="Argus.vision.ipa.sortField('technician_name')" style="position: relative; width: 3%; margin: 0px">
            <div title="Print Form" style="display: block; overflow: hidden; border-radius: 13px; width: 26px; cursor: pointer; height: 26px; border: 1px solid silver; padding-left: 3px;;  background-color: ghostwhite">
                <img onclick="Argus.vision.consultation.print('{{ id }}')" src="/images/vision/print.png" style="cursor: pointer; position: relative; top: 2px; width: 18px">
            </div>
        </div>
        <div class='nc_field' style="width: 8%">
            <span title="This is the encounter number">[{{ form_id }}]</span> {{form_type}} 
        </div>
        <div class='nc_field' style="width: 8%">		
            {{formatDate event_date "short"}}&nbsp;
        </div>
        <div class='nc_field' style="width: 7%">
            {{screening_client}}
        </div>
        <div class='nc_field' style="width: 15%">
            [{{ member_id }}] {{ member_name }}
        </div>	        
        <div class='nc_field'  style="width: 30%">
            {{ location_id_combo }} - {{ address_id_combo }}
        </div>				
        <div class='nc_field' style="width: 15%">
            [{{ physician_npi_combo }}] {{ primary_doctor_combo }}
        </div>	
        <div class='nc_field' style="width: 11%">
            {{technician_name}}&nbsp;
        </div>	        
        <div style="clear: both"></div>
    </div>
{{/each}}

