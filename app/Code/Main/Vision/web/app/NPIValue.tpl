 <table id='npitable' style='width: 100%; height: 100%' cellspacing='1' cellpadding='0' class='tablewhiteborder'>
	<tbody>
		<tr>
			<th class='tableborderstyle thcenterer' >NPI #</th>
			<th class='tableborderstyle thcenterer' >Event Location</th>
			<th class='tableborderstyle thcenterer' >Created On</th>
		</tr>
		{{#each data}} 
			<tr>
				<td class='tableborderstyle' style='height:30px'>{{npi_id}}</td>
				<td class='tableborderstyle' style='height:30px'>{{location}}</td>
				<td class='tableborderstyle' style='height:30px'>{{created_on}}</td>
			</tr>
		{{/each}}
	</tbody>
</table>