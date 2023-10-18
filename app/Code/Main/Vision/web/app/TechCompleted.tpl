
{{#each data}}
    <div onclick='Argus.vision.consultation.open("{{tag}}")' style='cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
        <table style='width: 100%' cellspacing='1' cellpadding='0'>
            <tr>
                <td rowspan='2' colspan='10%' style='overflow: hidden; position: relative'>
                    <div style='position: relative; width: 80px;'>
			<img style="width: 100%" onload='Argus.tools.image.align(this)' src='{{avatar}}' onerror="this.src='/images/argus/placeholder-{{creator_gender}}.png'"  />
			<div style='position: absolute; top: 0px; width: 80px'>
				<div title="Return to Reviewer" style="float: right; display: block; overflow: hidden; border-radius: 10px; cursor: pointer;  width: 20px; height: 20px; border: 1px solid silver; padding-left: 3px; background-color: ghostwhite">
					<img src="/images/vision/return.png" style="position: relative; top: -2px; width: 12px" onclick="Argus.vision.consultation.return('{{ id }}')" />
				</div>
				<div title="Print Form" style="display: block; overflow: hidden; border-radius: 10px; width: 20px; cursor: pointer; height: 20px; border: 1px solid silver; padding-left: 3px;;  background-color: ghostwhite">
					<img onclick="Argus.vision.consultation.print('{{form_id}}')" src="/images/vision/print.png" style="cursor: pointer; position: relative; top: -2px; width: 12px" />
				</div>
			</div>						
			<div style="position: absolute; bottom: 0px; color: red">
				<center>
				{{#if technician_name}}
					{{technician_name}}
				{{else}}
					&nbsp;
				{{/if}}
				</center>
			</div>
                    </div>

                </td>
                <td width='20%'>
                    <div class='nc_desc'>
                        Member ID
                    </div>
                    <div class='nc_field'>
                        {{member_id}}&nbsp;
                    </div>                
                </td>
                <td width='30%'>
                    <div class='nc_desc'>
                        Name
                    </div>
                    <div class='nc_field'>
                        {{member_name}}&nbsp;
                    </div>                
                </td>
                <td width='20%'>
                    <div class='nc_desc'>
                        DOB
                    </div>
                    <div class='nc_field'>
			{{#if date_of_birth}}
				{{date_of_birth}}
			{{else}}
				&nbsp;
			{{/if}}
                    </div>                
                </td>
                <td width='20%'>
                    <div class='nc_desc'>
                        Event Date
                    </div>
                    <div class='nc_field'>
			{{#if event_date}}
				{{formatDate event_date "short"}}
			{{else}}
				&nbsp;
			{{/if}}
                    </div>               
                </td>
            </tr>
            <tr>
                <td>
                <div class='nc_cell'>
                    <div class='nc_desc'>
                        Date Submitted
                    </div>
                    <div class='nc_field'>
			{{#if submitted}}
				{{formatDate submitted "short"}}
			{{else}}
				&nbsp;
			{{/if}}
                    </div>
                </div>
                </td>
                <td colspan="2" >
                    <div class='nc_desc' >
                        Event Location
                    </div>
                    <div class='nc_field' >
			{{#if address_id_combo }}
				{{address_id_combo}}
			{{else}}
				&nbsp;
			{{/if}}
                    </div>                
                </td>
                
		<td>
                    <div class='nc_desc'>
                        Encounter #
                    </div>
                    <div class='nc_field'>
			{{ id }}
                    </div>  
		</td>
            </tr>  
        </table>
    </div>
{{/each}}
