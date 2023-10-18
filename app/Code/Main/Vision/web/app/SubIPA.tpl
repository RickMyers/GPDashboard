<table id='ipasubtable' style='width: 100%; height: 100%' cellspacing='1' cellpadding='0'>
	<tbody>
		<tr>
			<th class='tableborderstyle thcenterer' style='display:none;'>ID</th>
			<th class='tableborderstyle thcenterer' style='width:800px'>Sub Name</th>
			<th class='tableborderstyle thcenterer' style='display:none;'>Sub ID</th> 
			<th class='tableborderstyle thcenterer' style='display:none;' >Parent ID</th>
			<th class='tableborderstyle thcenterer' style='padding-left: 10px; padding-right: 10px;'>Enabled?</th>
		</tr>  
		{{#each data}} 
			<tr> 
				<td class='tableborderstyle' style='display:none;'> {{id}}</td>
				<td class='tableborderstyle'>{{The_Name}}</td>
				<td class='tableborderstyle' style='display:none;'>{{the_sub_id}}</td>
				<td class='tableborderstyle' style='display:none;'>{{ipa_parent_id}}</td>
				<td class='tableborderstyle' >{{#ifOther The_Name }}<input type='checkbox' {{#ifisone is_enabled}} checked='checked' {{/ifisone}} id='sub-{{@index}}' onclick=\"disabler('sub-{{@index}}','ipasubtable', {{id}} )\" /> {{/ifOther}} </td>
			</tr>
		{{/each}}
	</tbody>
 </table>