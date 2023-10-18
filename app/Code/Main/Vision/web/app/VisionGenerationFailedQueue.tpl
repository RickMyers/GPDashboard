{{#each data}}
    <div onclick='Argus.vision.member.info("{{ id }}")' style='cursor: pointer; position: relative; background-color: rgba(222,222,222,{{zebra @index}})'>
        <table style='width: 100%' cellspacing='1' cellpadding='0'>
            <tr style="margin-bottom: 1px">
                <td width='20%'>
                    <div class='nc_desc'>
                        &nbsp;
                    </div>
                    <div class='nc_field'>
                        <img src="/images/vision/cancel.png" style="height: 16px; cursor: pointer" onclick="Argus.vision.member.missing.remove(event,{{ id }})" />
                    </div>                
                </td>
                <td width='10%'>
                    <div class='nc_desc'>
                        Event ID
                    </div>
                    <div class='nc_field'>
                        {{event_id}}&nbsp;
                    </div>                
                </td>
                <td width='20%'>
                    <div class='nc_desc'>
                        Client
                    </div>
                    <div class='nc_field'>
                        {{client}}&nbsp;
                    </div>                
                </td>

                <td width='20%'>
                    <div class='nc_desc'>
                        Member ID
                    </div>
                    <div class='nc_field'>
                        {{member_number}}&nbsp;
                    </div>                
                </td>
                <td width='30%'>
                    <div class='nc_desc'>
                        Member Name
                    </div>
                    <div class='nc_field'>
                        {{last_name}}, {{first_name}}&nbsp;
                    </div>                
                </td>
            </tr>
        </table>
    </div>
{{/each}}