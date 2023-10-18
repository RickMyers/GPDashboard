{{#each data}}
    <div onclick='Argus.vision.consultation.open("{{tag}}")' style='cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
        <table style='width: 100%' cellspacing='1' cellpadding='0'>
            <tr>
                <td rowspan='2' colspan='10%' style='overflow: hidden; position: relative'>
                    <div style='position: relative; width: 50px; height: 40px'>
                    <img onload='Argus.tools.image.align(this)' src='{{avatar}}' onerror="this.src='/images/argus/placeholder-{{creator_gender}}.png'"  />
                    </div>
			<div class='nc_desc'>
				{{#if technician_name}}
					{{technician_name}}
				{{else}}
					&nbsp;
				{{/if}}
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
                <td width='20%'>
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
				{{ date_of_birth }}
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
		<td width="*">
                    <div class='nc_desc'>
			&nbsp;
                    </div>
                    <div class='nc_field'>
			<a style="color: blue; font-size: 1.4em" onclick="window.event.stopPropagation(); " href="/vision/consultation/print?id={{form_id}}" target="_blank">Print</a>
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
                    <div class='nc_desc' style="text-align: center;">
                        Event Location
                    </div>
                    <div class='nc_field' style="margin:0 auto; text-align: center; border-spacing-right:10px">
			{{#if event_address }}
				{{event_address}}
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
		<td width="*">
                    <div class='nc_desc'>
			&nbsp;
                    </div>
                    <div class='nc_field'>
			<a href="#" style="color: blue; font-size: 1.2em" onclick="Argus.vision.consultation.return('{{ id }}')">Return</a>
                    </div>                

		</td>
            </tr>  
        </table>
    </div>
{{/each}}