<div class='queue-row' style='color: #333; background-color: rgba(202,202,202,.1); font-weight: bold '>
	<div class='queue-cell' style='text-align: center; width: 12%; text-align: center; background-color: rgba(202,202,202,.2)'>
	Member ID
	</div>
	<div class='queue-cell' style='text-align: center; width: 13%; text-align: center; background-color: rgba(202,202,202,.2)'>
	Member Name
	</div>
	<div class='queue-cell' style='width: 12%; text-align: center; background-color: rgba(202,202,202,.2)'>
	Date Of Birth
	</div>
	<div class='queue-cell' style='width: 13%; text-align: center; background-color: rgba(202,202,202,.2)'>
	Event Date
	</div>
	<div class='queue-cell' style='width: 50%; text-align: center; background-color: rgba(202,202,202,.2)'>
	E-Mail
	</div>
</div>
{{#each data}}
<div class='queue-row' onclick='Argus.dental.consultation.open("{{id}}"); return false' style='cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
	<div class='queue-cell' style='text-align: center; width: 12%'>
	<a href='#' style='color: blue' > {{member_id}}</a>
	</div>
	<div class='queue-cell' style='text-align: center; width: 13%'>
	{{member_name}}
	</div>
	<div class='queue-cell' style='width: 12%; text-align: center'>
	{{#if patient_dob}}
		{{formatDate patient_dob "short"}}
	{{/if}}
	</div>
	<div class='queue-cell' style='width: 13%; text-align: center'>
	{{#if visit_date}}
		{{formatDate visit_date "short"}}
	{{/if}}
	</div>
	<div class='queue-cell' style='width: 50%'>
	{{email_address}}
	</div>
</div>
{{/each}}