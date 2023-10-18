IPA List <a href="#" style="float: right; color: blue; margin-right: 5px" onclick="Argus.hedis.vision.ipa.add(); return false;">New IPA</a>
{{#each data}}
    <div id="client_ipa_{{ipa_id}}" class="option-layer" onclick='Argus.hedis.vision.location.list("{{ipa_id}}")' style='position: relative; cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
	<img title="Edit" src="/images/hedis/edit.png" onclick="Argus.hedis.vision.ipa.edit(event,{{ipa_id}}); return false" style="float: left; margin-right: 5px; cursor: pointer; height: 14px" />
	<img title="Delete" src="/images/hedis/delete.png" onclick="Argus.hedis.vision.ipa.remove(event,{{ipa_id}}); return false" style="float: left; margin-right: 5px; cursor: pointer; height: 14px" />
	{{ipa}}
    </div>
{{/each}}