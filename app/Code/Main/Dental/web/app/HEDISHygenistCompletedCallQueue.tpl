<div class='queue-row' style='color: #333; background-color: rgba(222,222,222,.1) '>
<div class='queue-cell' style='text-align: center; width: 8%; text-align: center; background-color: rgba(202,202,202,.2)'>
M
</div>
<div class='queue-cell' style='text-align: center; width: 8%; text-align: center; background-color: rgba(202,202,202,.2)'>
A
</div>

<div class='queue-cell' style='width: 56%; text-align: center; background-color: rgba(202,202,202,.2)'>
Address
</div>
<div class='queue-cell' style='width: 25%; text-align: center; background-color: rgba(202,202,202,.2)'>
Zip Code
</div>
</div>
{{#each data}}
<div class='queue-row' onclick='Argus.dental.hedis.hygenist.review("{{contact_id}}"); return false' style='cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
<div class='queue-cell' style='text-align: center; width: 8%'>
<a href='#' style='color: blue' > {{members}}</a>
</div>
<div class='queue-cell' style='text-align: center; width: 8%'>
{{number_of_attempts}}
</div>
<div class='queue-cell' style='width: 56%'>
{{address}}
</div>
<div class='queue-cell' style='width: 26%'>
{{zip_code}}
</div>
</div>
{{/each}}