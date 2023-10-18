Address List <a href="#" style="float: right; color: blue; margin-right: 5px" onclick="Argus.hedis.vision.address.add(); return false;">New Address</a>
{{#each data}}
    <div id="ipa_location_address_{{id}}" class="option-layer" onclick='Argus.hedis.vision.address.edit("{{id}}")' style='cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
	<img title="Edit" src="/images/hedis/edit.png" onclick="Argus.hedis.vision.address.edit(event,{{id}}); return false" style="float: left; margin-right: 5px; cursor: pointer; height: 14px" />
	<img title="Delete" src="/images/hedis/delete.png" onclick="Argus.hedis.vision.address.remove(event,{{id}}); return false" style="float: left; margin-right: 5px; cursor: pointer; height: 14px" />
	{{address}}
    </div>
{{/each}}