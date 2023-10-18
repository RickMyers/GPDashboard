{{#each data}}
    <div onclick="Argus.online.application.view('{{id}}'); return false" style='cursor: pointer; position: relative; background-color: rgba(222,222,222,{{zebra @index}}); padding: 2px 1px'>
        <table style='width: 100%' cellspacing='1' cellpadding='0'>
            <tr>
                <td width='18%' style='overflow: hidden'>
                    <div class='nc_desc'>
                        App&nbspID
                    </div>
                    <div class='nc_field'>
                        {{application_id}}&nbsp; 
                    </div>                
                </td>
                <td width='18%' style='overflow: hidden'>
                    <div class='nc_desc'>
                        Broker
                    </div>
                    <div class='nc_field'>
                        {{broker}}&nbsp; 
                    </div>                
                </td>
                <td width='6%' style='overflow: hidden'>
                    <div class='nc_desc'>
                        ##
                    </div>
                    <div class='nc_field'>
                        {{number_of_members}}&nbsp;
                    </div>                
                </td>
                <td width='20%' style='overflow: hidden'>
                    <div class='nc_desc'>
                        Last Name
                    </div>
                    <div class='nc_field'>
                        {{last_name}}&nbsp;
                    </div>                
                </td>
                <td width='19%' style='overflow: hidden'>
                    <div class='nc_desc'>
                        Last Action
                    </div>
                    <div class='nc_field'>
                        {{last_action}}&nbsp;
                    </div>                
                </td>
                <td width='19%' style='overflow: hidden'>
                    <div class='nc_desc'>
                        Effective
                    </div>
                    <div class='nc_field'>
			{{#if requested_effective_date}}
                        {{formatDate requested_effective_date "short"}}
			{{else}}
				&nbsp;
			{{/if}}
                    </div>                
                </td>
            </tr>
        </table>
    </div>
{{/each}}