<table cellpadding='10' id='batchtable' style='width:100%; height:100%; float: left; padding-left: 15px;' class= 'tablewhiteborder'>
	<tbody>
		<tr>
		<th class='tableborderstyle thcenterer'>Member Name</th>
		<th class='tableborderstyle thcenterer'>Member ID</th>
		<th style='width:90px' class='tableborderstyle thcenterer'>Date</th>
		<th class='tableborderstyle thcenterer'>Location</th>
		<th class='tableborderstyle thcenterer'>View Form</th>
		<th class='tableborderstyle thcenterer'>Save to PDF</th>
		</tr>
		{{#each data}}
			<tr style='background-color: rgba(222,222,222,{{zebra @index}})'>
				<td class='tableborderstyle' >{{member_name}}</td>
				<td class='tableborderstyle'>{{member_id}}</td>
				<td class='tableborderstyle'>{{event_date}}</td>
				<td class='tableborderstyle'>{{event_address}}</td>
				<td class='tableborderstyle'><a onclick='Argus.vision.consultation.open({{tag}})'>VIEW</a></td>
				<td class='tableborderstyle'><a onclick='Argus.vision.batchtest(\"{{member_id}}\",\"{{event_date}}\",\"{{event_address}}\",\"\" )'>SAVE</a></td>
			</tr>
		{{/each}}
	</tbody>
</table> 