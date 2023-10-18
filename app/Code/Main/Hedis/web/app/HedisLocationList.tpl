Office List <a href="#" style="float: right; color: blue; margin-right: 5px" onclick="Argus.hedis.vision.location.add(); return false;">New Office</a>
{{#each data}}
    <div id="ipa_location_{{id}}" class="option-layer" onclick='Argus.hedis.vision.address.list("{{id}}")' style='cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
	<img title="Edit" src="/images/hedis/edit.png" onclick="Argus.hedis.vision.location.edit(event,{{id}}); return false" style="float: left; margin-right: 5px; cursor: pointer; height: 14px" />
	<img title="Delete" src="/images/hedis/delete.png" onclick="Argus.hedis.vision.location.remove(event,{{id}}); return false" style="float: left; margin-right: 5px; cursor: pointer; height: 14px" />
	{{location}}
    </div>
{{/each}}