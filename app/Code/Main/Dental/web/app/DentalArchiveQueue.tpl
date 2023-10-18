{{#each data}}
    <div onclick='Argus.dental.consultation.open("{{form_id}}")' style='cursor: pointer'>
        <table style='width: 100%' cellspacing='1' cellpadding='0'>
            <tr>
                <td rowspan='2' colspan='10%' style='overflow: hidden; position: relative'>
                    <div style='position: relative; width: 70px; height: 60px'>
                    <img onload='Argus.tools.image.align(this)' src='/images/argus/placeholder-{{creator_gender}}.png'  />
                    </div>
                </td>
                <td width='30%'>
                    <div class='nc_desc'>
                        Member ID
                    </div>
                    <div class='nc_field'>
                        {{member_id}}
                    </div>                
                </td>
                <td width='30%'>
                    <div class='nc_desc'>
                        Name
                    </div>
                    <div class='nc_field'>
                        {{member_name}}
                    </div>                
                </td>
                <td width='30%'>
                    <div class='nc_desc'>
                        DOB
                    </div>
                    <div class='nc_field'>
                        {{date_of_birth}}
                    </div>                
                </td>
            </tr>
            <tr>
                <td>
                <div class='nc_cell'>
                    <div class='nc_desc'>
                        Date Submitted
                    </div>
                    <div class='nc_field'>
                        {{formatDate submitted "short"}}
                    </div>
                </div>
                </td>
                <td>
                    <div class='nc_desc'>
                        Last Activity
                    </div>
                    <div class='nc_field'>
                        {{last_activity}}
                    </div>                
                </td>
                <td>
                    <div class='nc_desc'>
                        Review By
                    </div>
                    <div class='nc_field'>
                        {{review_by}}
                    </div>                
                </td>
            </tr>        
        </table>
    </div>
{{/each}}