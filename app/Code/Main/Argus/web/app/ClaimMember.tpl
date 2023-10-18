<table style="width: 100%; height: 100%">
	<tr>
		<td>
			<div style="background-color: ghostwhite; color: #333; width: 600px; margin-left: auto; margin-right: auto; padding: 10px; border-radius: 10px">
				<form nohref onsubmit="return false">
				<fieldset style="padding: 10px; border-radius: 10px"><legend title='{{date_of_birth.date}}'> {{last_name}}, {{first_name}} ({{ gender }})</legend>
					Health Plan: {{group_id}}<br /><br />
					<table>
						<tr><td align='right'>DOB: </td><td>&nbsp;&nbsp;&nbsp; {{formatDate date_of_birth.date "short"}}</td></tr>
						<tr><td valign='top' align='right'>Address: </td><td>&nbsp;&nbsp;&nbsp; {{address_full}}<br />&nbsp;&nbsp;&nbsp; {{city}}, {{state}}, {{zip_code}}</td></tr>
						<tr><td align='right'>Phone: </td><td>&nbsp;&nbsp;&nbsp; {{phone_number}}</td></tr>
						<tr><td align='right'>E-Mail: </td><td>&nbsp;&nbsp;&nbsp; {{email_address}}</td></tr>
						<tr><td colspan='2'>&nbsp; </td></tr>
						<tr><td colspan='2'><input type='button' value='  Close  ' onclick="$('#desktop-lightbox').css('display','none').html(' ')"/>   </td></tr>
						<tr><td colspan='2'>&nbsp; </td></tr>
					</table>
				</fieldset>
				</form>			
			</div>
		</td>
	</tr>
</table>