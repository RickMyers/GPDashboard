<style type="text/css">
	.nc_search_cell {
		display: inline-block; vertical-align: top; margin-right: 0px; 
	}
	.nc_search_desc {
		font-family: monospace; letter-spacing: 1px; padding: 2px; font-size: .85em
	}
	.nc_search_field {
		overflow: hidden; font-family: sans-serif; font-size: .85em; padding: 2px 2px 2px 10px
	}
</style>
{{#each data}}
    <div onclick='Argus.vision.consultation.open("{{tag}}")' style='position: relative; cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}}); white-space: nowrap; overflow: hidden; margin-bottom: 1px'>
		<div style="position: relative; width: 80px; float: left; margin-right: 1px">
			<img onload='Argus.tools.image.align(this)' src='{{avatar}}' onerror="this.src='/images/argus/placeholder-{{creator_gender}}.png'" style='width: 100%; height: 100%' />
			<div style="position: absolute; top: 0px; width: 80px">
				<div title="Return to Reviewer" style="float: right; display: block; overflow: hidden; border-radius: 10px; cursor: pointer;  width: 20px; height: 20px; border: 1px solid silver; padding-left: 3px; background-color: ghostwhite">
					<img src="/images/vision/return.png" style="position: relative; top: -2px; width: 12px" onclick="Argus.vision.consultation.return('{{ id }}')">
				</div>
				<div title="Print Form" style="display: block; overflow: hidden; border-radius: 10px; width: 20px; cursor: pointer; height: 20px; border: 1px solid silver; padding-left: 3px;;  background-color: ghostwhite">
					<img onclick="Argus.vision.consultation.print('{{ id }}')" src="/images/vision/print.png" style="cursor: pointer; position: relative; top: -2px; width: 12px">
				</div>
			</div>						
			<div style="position: absolute; bottom: 0px; color: red; text-align: center">
				{{#if technician_name}}
					{{technician_name}}
				{{else}}
					&nbsp;
				{{/if}}
			</div>
        </div>
		<div class='nc_search_cell' style="width: 10%">
			<div class='nc_search_desc'>
				Client
			</div>
			<div class='nc_search_field'>
				{{screening_client}}&nbsp;
			</div>    
		</div>	
		<div class='nc_search_cell' style="width: 10%">
			<div class='nc_search_desc'>
				Event#/Appt
			</div>
			<div class='nc_search_field'>
				{{#if event_id}}
					{{ event_id }}
					{{#if event_time}}
					- {{format_time event_time }}
					{{else}}
					- N/A
					{{/if}}
				{{else}}
				N/A
				{{/if}}
			</div>
		</div>		
		<div class='nc_search_cell' style="width: 20%">		
			<div class='nc_search_desc'>
				Name
			</div>
			<div class='nc_search_field' style='font-weight: bolder'>
				{{member_name}}&nbsp;
			</div>
		</div>
		<div class='nc_search_cell' style="width: 15%">
			<div class='nc_search_desc'>
				DOB
			</div>
			<div class='nc_search_field'>
				{{#if date_of_birth}}
					{{ date_of_birth }}
				{{else}}
					&nbsp;
				{{/if}}
			</div>
		</div>
		<div class='nc_search_cell' style="width: 10%">
			<div class='nc_search_desc'>
				Member ID
			</div>
			<div class='nc_search_field'>
				{{member_id}}&nbsp;
			</div>    
		</div>
		<div class='nc_search_cell' style="width: 5%">
			<div class='nc_search_desc'>
				Status
			</div>
			<div class='nc_search_field'>
				{{ status }}
			</div>
		</div>
		<div class='nc_search_cell' style="width: 10%">
			<div class='nc_search_desc'>
				Claim Status
			</div>
			<div class='nc_search_field'>
				{{ claim_status }}
			</div>
		</div>				
		<div class='nc_search_cell' style="width: 9%">
			<div class='nc_search_desc'>
				Encounter #
			</div>
			<div class='nc_search_field'>
				{{ id }}
			</div>  
	    </div>		
		<div style="clear: right"></div>
		<div class='nc_search_cell' style="width: 10%">
			<div class='nc_search_desc'>
				Form Type
			</div>
			<div class='nc_search_field'>
				{{#if form_type}}
					{{ucfirst form_type}}
				{{else}}
					&nbsp;
				{{/if}}
			</div>
		</div>
		<div class='nc_search_cell' style="width: 10%">		
			<div class='nc_search_desc'>
				Event Date
			</div>

			<div class='nc_search_field'>
				{{#if event_date}}
					{{formatDate event_date "short"}}
				{{else}}
					&nbsp;
				{{/if}}
			</div>
		</div>	
		<div class='nc_search_cell' style="width: 20%">
			<div class='nc_search_desc'>
				O.D.
			</div>
			<div class='nc_search_field'>
			{{#if reviewer_name}}
				Dr. {{ reviewer_name }}
			{{ else }}
				&nbsp;
			{{/if}}
			</div>
		</div>			
		<div class='nc_search_cell' style="width: 15%">
			<div class='nc_search_desc'>
				Date Submitted
			</div>
			<div class='nc_search_field'>
			{{#if submitted}}
				{{formatDate submitted "short"}}
			{{else}}
				&nbsp;
			{{/if}}
			</div>
		</div>
	
		<div class='nc_search_cell'  style="width: 35%">
            <div class='nc_search_desc'>
				Event Location
            </div>
            <div class='nc_search_field'>
				{{#if address_id_combo }}
					{{address_id_combo}}
				{{else}}
					&nbsp;
				{{/if}}
			</div>
		</div>
		<div style="clear: both"></div>
    </div>
{{/each}}