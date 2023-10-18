{{#each data}}
    <div onclick='Argus.vision.pcpreports.open("{{ report }}","{{ resource }}")' style='margin-bottom: 2px; cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
        <div style='padding: 5px' class=''>
		<img style='float: left; margin-right: 5px; height: 36px' src="/images/vision/report.png" />
		<span style='font-size: .9em; letter-spacing: 1px; font-weight: bolder' class=''> Report Name</span>
		<span style='' class=''> - {{ report }}</span><br />
		<span style='font-size: .9em; letter-spacing: 1px; font-weight: bolder' class=''> Description</span>
		<span style='class=''> - {{ description }}</span>
	</div>
    </div>
{{/each}}