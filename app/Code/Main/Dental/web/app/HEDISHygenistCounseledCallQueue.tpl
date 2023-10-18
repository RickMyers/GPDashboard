<div class='queue-row' style='color: #333; background-color: rgba(202,202,202,.1) '>
<div class='queue-cell' style='text-align: center; width: 25%; text-align: center; background-color: rgba(202,202,202,.2)'>
Member ID
</div>
<div class='queue-cell' style='width: 50%; text-align: center; background-color: rgba(202,202,202,.2)'>
Name
</div>
<div class='queue-cell' style='width: 25%; text-align: center; background-color: rgba(202,202,202,.2)'>
DOB
</div>
</div>
{{#each data}}
<div class='queue-row' onclick='Argus.dental.hedis.hygenist.member("{{member_id}}"); return false' style='cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
<div class='queue-cell' style='text-align: center; width: 25%'>
<a href='#' style='color: blue' >{{member_id}}</a>
</div>
<div class='queue-cell' style='width:50%'>
{{last_name}}, {{first_name}}
</div>
<div class='queue-cell' style='width: 26%'>
{{date_of_birth}}
</div>
</div>
{{/each}}