{{#each data}}
    <div onclick='Argus.vision.event.assign("{{id}}")' style='cursor: pointer; background-color: rgba(222,222,222,{{zebra @index}})'>
        <table style='width: 100%' cellspacing='1' cellpadding='0'>
            <tr>

			
                <td width='20%'>
                    <div class='nc_desc'>
                        Event ID
                    </div>
                    <div class='nc_field'>
                        <b>{{id}}&nbsp;</b>
                    </div>                
                </td>
                <td width='20%'>
                    <div class='nc_desc'>
                        Location NPI
                    </div>
                    <div class='nc_field'>
                        {{location_npi}}&nbsp;
                    </div>                
                </td>
                <td width='20%'>
                    <div class='nc_desc'>
                        Event Start
                    </div>
                    <div class='nc_field'>
                        {{formatDate start_date "short"}} @ {{start_time}}&nbsp;
                    </div>                
                </td>
                <td width='20%'>
                    <div class='nc_desc'>
                        Event End
                    </div>
                    <div class='nc_field'>
			{{formatDate end_date "short"}} @ {{end_time}}&nbsp;
                    </div>                
                </td>
                <td width='20%'>
                    <div class='nc_desc'>
                        Contact Name
                    </div>
                    <div class='nc_field'>
			{{contact_name}}&nbsp;
                    </div>                
                </td>

            </tr>
            <tr>
                <td colspan="2">
                <div class='nc_cell'>
                    <div class='nc_desc'>
                        Business Name
                    </div>
                    <div class='nc_field'>
			{{business_name}}&nbsp;
                    </div>
                </div>
                </td>
                <td colspan="3" >
                    <div class='nc_desc' style="text-align: center;">
                        Event Location
                    </div>
                    <div class='nc_field' style="margin:0 auto; text-align: center; border-spacing-right:10px">
			{{screening_location}}&nbsp;
                    </div>                
                </td>
            </tr>  
        </table>
    </div>
{{/each}}