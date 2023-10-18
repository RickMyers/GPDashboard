<style type="text/css">
.request-list-item   { width: 100% }
.request-list-row    { white-space: nowrap; margin-bottom: 1px }
.request-list-cell   { display: inline-block;  margin-right: 1px }
.request-list-header { font-family: monospace; letter-spacing: 1px; font-size: .95em; overflow: hidden}
.request-list-data   { font-family: sans-serif; font-size: 1em; padding-left: 10px; overflow: hidden}
</style>
{{#each data }}
<div onclick='Argus.dashboard.request.show("{{id}}")' class="request-list-item" style='cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
	<div class="request-list-row">
		<div class="request-list-cell" style="width: 20%">
			<div class="request-list-header">
				Module
			</div>
			<div class="request-list-data">
				{{ module }}&nbsp;
			</div>
		</div>
		<div class="request-list-cell" style="width: 20%">
			<div class="request-list-header">
			Feature
			</div>
			<div class="request-list-data">
			   {{ feature }}&nbsp;
			</div>
		</div>
		<div class="request-list-cell" style="width: 20%">
			<div class="request-list-header">
			Submitter
			</div>
			<div class="request-list-data">
				{{ submitter }}&nbsp;
			</div>
		</div>
		<div class="request-list-cell" style="width: 15%">
			<div class="request-list-header">
			Submitted
			</div>
			<div class="request-list-data">
				{{ formatDate submitted "short"}}&nbsp;
			</div>
		</div>
		<div class="request-list-cell" style="width: 10%">
			<div class="request-list-header">
				Status
			</div>
			<div class="request-list-data">
				{{ state }}&nbsp;
			</div>
		</div>	
		<div class="request-list-cell" style="width: 15%">
			<div class="request-list-header">
				Priority
			</div>
			<div class="request-list-data">
				{{ priority }}&nbsp;
			</div>
		</div>
	</div>
	<div class="request-list-row">
		<div class="request-list-cell" style="width: 75%">
			<div class="request-list-header">
				Subject
			</div>
			<div class="request-list-data">
				{{ subject }}&nbsp;
			</div>
		</div>
		<div class="request-list-cell" style="width: 25%">
			<div class="request-list-header">
				Attachment
			</div>
			<div class="request-list-data">
				{{ attachment }}&nbsp;
			</div>
		</div>
	</div>
</div>	
{{/each}}