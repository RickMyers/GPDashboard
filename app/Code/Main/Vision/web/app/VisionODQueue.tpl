{{#each data}}
    <div onclick='Argus.vision.consultation.open("{{tag}}")' style='cursor: pointer; position: relative; background-color: rgba(222,222,222,{{zebra @index}})'>
	<div title="Print Form" style="display: block; position: absolute; top: 0px; left: 0px; overflow: hidden; border-radius: 10px; width: 20px; cursor: pointer; height: 20px; border: 1px solid silver; padding-left: 3px;;  background-color: ghostwhite">
		<img onclick="Argus.vision.consultation.print('{{tag}}')" src="/images/vision/print.png" style="cursor: pointer; position: relative; top: -2px; width: 12px" />
	</div>
        <table style='width: 100%' cellspacing='1' cellpadding='0'>
            <tr style="margin-bottom: 1px">
                <td rowspan='2' width='12%' style='overflow: hidden; box-sizing: border-box; position: relative; padding-right: 2px'>
                    <div style='position: relative; width: 100%; height: 60px; text-align: center'>
                    <img title="Scheduled @  {{ event_time }}" onload='Argus.tools.image.align(this)' src='{{avatar}}' onerror="this.src='/images/argus/placeholder-{{creator_gender}}.png'" style='margin-left: auto; width: 100%; margin-right: auto' />
                    </div>
			<div title="Print Form" style="display: block; position: absolute; top: 0px; left: 0px; overflow: hidden; border-radius: 10px; width: 20px; cursor: pointer; height: 20px; border: 1px solid silver; padding-left: 3px;;  background-color: ghostwhite">
				<img onclick="Argus.vision.consultation.print('{{tag}}')" src="/images/vision/print.png" style="cursor: pointer; position: relative; top: -2px; width: 12px" />
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
                <td width='15%'>
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
                <td width='25%'>
                    <div class='nc_desc'>
                        Form ID/Event ID
                    </div>
                    <div class='nc_field'>
			{{ id }}/ {{#if event_id}}{{ event_id }}{{ else }}N/A{{/if}}
                    </div>                
                </td>
            </tr>
            <tr>
                <td>
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
                </td>
                <td>
                    <div class='nc_desc'>
                        Last Activity
                    </div>
                    <div class='nc_field'>
			{{#if last_activity }}
				<span title='{{last_activity}}'>{{last_action}}</span>
			{{else}}
				&nbsp;
			{{/if}}
                    </div>                
                </td>
                <td colspan="2">
                    <div class='nc_desc'>
                        Technician
                    </div>
                    <div class='nc_field'>
			{{#if technician_name}}
				{{technician_name}}
			{{else}}
				&nbsp;
			{{/if}}
                    </div>                
                </td>
            </tr>        
        </table>
    </div>
{{/each}}