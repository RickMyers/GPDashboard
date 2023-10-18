<div class='queue-row' style='color: #333; background-color: rgba(222,222,222,.1) '>
<div class='queue-cell' style='text-align: center; width: 12%; text-align: center; background-color: rgba(202,202,202,.2)'>
#
</div>
<div class='queue-cell' style='width: 60%; text-align: center; background-color: rgba(202,202,202,.2)'>
Address
</div>
<div class='queue-cell' style='width: 25%; text-align: center; background-color: rgba(202,202,202,.2)'>
City
</div>
</div>
{{#each data}}
<div class='queue-row' onclick='Argus.dental.hedis.manager.open("{{contact_id}}"); return false' style='cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
<div class='queue-cell' style='text-align: center; width: 12%'>
<a href='#' style='color: blue' > {{members}}</a>
</div>
<div class='queue-cell' style='width: 60%'>
{{address}}
</div>
<div class='queue-cell' style='width: 20%'>
{{city}}
</div>
</div>
{{/each}}