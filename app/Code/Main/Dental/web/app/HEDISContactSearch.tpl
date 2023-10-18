<div class='queue-row' style='color: #333; background-color: rgba(202,202,202,.1) '>
	<div class='queue-cell' style='text-align: center; width: 12%; text-align: center; background-color: rgba(202,202,202,.2)'>
	Member ID
	</div>
	<div class='queue-cell' style='text-align: center; width: 13%; text-align: center; background-color: rgba(202,202,202,.2)'>
	Name
	</div>
	<div class='queue-cell' style='width: 12%; text-align: center; background-color: rgba(202,202,202,.2)'>
	Date Of Birth
	</div>
	<div class='queue-cell' style='width: 13%; text-align: center; background-color: rgba(202,202,202,.2)'>
	Assignee
	</div>
	<div class='queue-cell' style='width: 50%; text-align: center; background-color: rgba(202,202,202,.2)'>
	Address
	</div>
</div>
{{#each data}}
<div class='queue-row' onclick='Argus.dental.hedis.hygenist.open("{{contact_id}}"); return false' style='cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
	<div class='queue-cell' style='text-align: center; width: 12%'>
	<a href='#' style='color: blue' > {{member_id}}</a>
	</div>
	<div class='queue-cell' style='text-align: center; width: 13%'>
	{{first_name}} {{last_name}}
	</div>
	<div class='queue-cell' style='width: 12%'>
	{{date_of_birth}}
	</div>
	<div class='queue-cell' style='width: 13%'>
	{{assignee}}
	</div>
	<div class='queue-cell' style='width: 50%'>
	{{address}}, {{city}}
	</div>
</div>
{{/each}}