<table id='ipatable' style='width: 100%; height: 100%' cellspacing='1' cellpadding='0'>
	<tbody>
		<tr>
			<th class='tableborderstyle thcenterer' style='display:none;'>ID</th>
			<th class='tableborderstyle thcenterer' style='width:800px' >Name</th>
			<th class='tableborderstyle thcenterer' style='display:none;' >IPA ID</th>
			<th class='tableborderstyle thcenterer' style='padding-left: 10px; padding-right: 10px;' >Enabled?</th>
		</tr>
		{{#each data}}
			<tr>
				<td class='tableborderstyle' style='display:none;'>{{id}}</td>
				<td class='tableborderstyle'>{{ipa_name}}</td>
				<td class='tableborderstyle' style='display:none;'>{{ipa_id}}</td>
				<td class='tableborderstyle' >{{#ifOther ipa_name}}<input type='checkbox' {{#ifisone is_enabled}} checked='checked' {{/ifisone}} id='ipa-{{@index}}' onclick=\"disabler('ipa-{{@index}}', 'ipatable', {{id}})\"   /> {{/ifOther}} </td>
			</tr>
		{{/each}}
	</tbody>
 </table>