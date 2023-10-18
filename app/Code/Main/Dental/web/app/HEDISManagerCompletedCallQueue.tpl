<div class='queue-row' style='color: #333; background-color: rgba(222,222,222,.1) '>
<div class='queue-cell' style='text-align: center; width: 25%; text-align: center; background-color: rgba(202,202,202,.2)'>
Member ID
</div>
<div class='queue-cell' style='width: 25%; text-align: center; background-color: rgba(202,202,202,.2)'>
First Name
</div>
<div class='queue-cell' style='width: 25%; text-align: center; background-color: rgba(202,202,202,.2)'>
Last Name
</div>
<div class='queue-cell' style='width: 25%; text-align: center; background-color: rgba(202,202,202,.2)'>
DOB
</div>
</div>
{{#each data}}
<div class='queue-row' style='cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
<div class='queue-cell'>
<a href='#' style='color: blue' onclick='Argus.dental.hedis.manager.review("{{member_id}}"); return false'> {{member_id}}</a>
</div>
<div class='queue-cell'>
{{first_name}}
</div>
<div class='queue-cell'>
{{last_name}}
</div>
<div class='queue-cell' style='margin-right: 0px'>
{{date_of_birth}}
</div>
</div>
{{/each}}