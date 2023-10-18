{{#each data}}
    <div onclick='Argus.vision.consultation.open("{{tag}}")' style='cursor: pointer; position: relative; background-color: rgba(222,222,222,{{zebra @index}})'>
        <table style='width: 100%' cellspacing='1' cellpadding='0'>
            <tr>
                <td width='30%'>
                    <div class='nc_desc'>
                        Member ID
                    </div>
                    <div class='nc_field'>
                        {{member_id}}&nbsp;
                    </div>                
                </td>
                <td colspan="2">
                    <div class='nc_desc'>
                        Name
                    </div>
                    <div class='nc_field'>
                        {{member_name}}&nbsp;
                    </div>                
                </td>
                <td width='30%'>
                    <div class='nc_desc'>
                        DOB
                    </div>
                    <div class='nc_field'>
			{{#if date_of_birth}}
                        {{date_of_birth}}
			{{else}}
				&nbsp;
			{{/if}}
                    </div>                
                </td>
            </tr>
            <tr>
                <td>
                <div class='nc_cell'>
                    <div class='nc_desc'>
                        Health Plan
                    </div>
                    <div class='nc_field'>
			{{screening_client}}&nbsp;
                    </div>
                </div>
                </td>
                <td colspan="2">
                    <div class='nc_desc'>
                        Location
                    </div>
                    <div class='nc_field' style='overflow: hidden; white-space: nowrap'>
			{{event_address}}&nbsp;
                    </div>                
                </td>
                <td>
                    <div class='nc_desc'>
                        Date
                    </div>
                    <div class='nc_field'>
			{{event_date}}&nbsp;
                    </div>                
                </td>
            </tr>        
        </table>
    </div>
{{/each}}