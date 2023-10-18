<style type="text/css">
.claim-batching-row {
	white-space: nowrap; overflow: hidden
}
.claim-batching-cell {
	display: inline-block;
}
.claim-header-cell {
	background-color: #333; padding: 5px; font-family: sans-serif; font-size: 1em; color: ghostwhite; margin-left: 0px
}
.claim-data-cell {
	margin-left: 5px; overflow: hidden
}
</style>
<form name="claims-batching-form" id="claims-batching-form" onsubmit="return false">
	<div class="claim-batching-row">
		<div class="claim-batching-cell claim-header-cell" style="width: 30px; text-align: center">
			&diams;
		</div>
		<div class="claim-batching-cell claim-header-cell" style="width: 7%">
			Claim Date
		</div>
		<div class="claim-batching-cell claim-header-cell" style="width: 10%">
			Health Plan
		</div>
		<div class="claim-batching-cell claim-header-cell" style="width: 15%">
			IPA
		</div>
		<div class="claim-batching-cell claim-header-cell" style="width: 15%">
			Provider
		</div>
		<div class="claim-batching-cell claim-header-cell" style="width: 10%">
			Event ID
		</div>
		<div class="claim-batching-cell claim-header-cell" style="width: 10%">
			Form Type
		</div>
		<div class="claim-batching-cell claim-header-cell" style="width: 15%">
			Member
		</div>
		<div class="claim-batching-cell claim-header-cell" style="width: 7%">
			Member ID
		</div>		
		<div class="claim-batching-cell claim-header-cell" style="width: 7%">
			Form ID
		</div>		
		
	</div>

{{#each data}}

	<div class="claim-batching-row" style="background-color: rgba(222,222,222,{{zebra @index}})">
		<div class="claim-batching-cell claim-data-cell" >
			<input type="checkbox" value="{{ id }}"  />
		</div>
		<div class="claim-batching-cell claim-data-cell" style="width: 7%">
			{{ formatDate event_date "short" }}
		</div>
		<div class="claim-batching-cell claim-data-cell" style="width: 10%">
			{{ screening_client }}
		</div>
		<div class="claim-batching-cell claim-data-cell" style="width: 15%">
			{{ ipa_id_combo }}
		</div>
		<div class="claim-batching-cell claim-data-cell" style="width: 15%">
			{{ doctor }}
		</div>
		<div class="claim-batching-cell claim-data-cell" style="width: 10%">
			{{ event_id }}
		</div>
		<div class="claim-batching-cell claim-data-cell" style="width: 10%">
			{{ form_type }}
		</div>
		<div class="claim-batching-cell claim-data-cell" style="width: 15%">
			{{ member_name }}
		</div>
		<div class="claim-batching-cell claim-data-cell" style="width: 7%">
			{{ member_id }}
		</div>
		<div class="claim-batching-cell claim-data-cell" style="width: 7%; color: blue">
			<a href="#" onclick="Argus.vision.consultation.open('{{tag}}')" >{{ id }}</a>
		</div>				
		
	</div>
{{/each}}
<hr />
<button onclick="Argus.claims.batching.all()" style="color: #333; margin-left: 5px;">Select All</button>
<button onclick="Argus.claims.batching.run()" style="color: #333; float: right; margin-right: 5px;">Batch Claims</button>
</form>
<script type="text/javascript">

</script>