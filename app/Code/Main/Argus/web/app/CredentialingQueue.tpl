{{#each data}}
    <a href='/argus/provider/register?form_id={{form_id}}' target="_blank" style='cursor: pointer; border: 0px; position: relative'>
        <table style='width: 100%' cellspacing='1' cellpadding='0'>
            <tr>
                <td rowspan='2' colspan='10%' style='overflow: hidden; position: relative'>
                    <div style='position: relative; width: 70px; height: 60px'>
                    <img onload='Argus.tools.image.align(this)' src='/images/argus/avatars/{{creator}}.jpg' onerror="this.src='/images/argus/placeholder-{{providers_gender}}.png'"  />
                    </div>
                </td>
                <td width='30%'>
                    <div class='nc_desc'>
                        Applicant
                    </div>
                    <div class='nc_field'>
                        {{name}}&nbsp;
                    </div>                
                </td>
                <td width='30%'>
                    <div class='nc_desc'>
                        Reviewer
                    </div>
                    <div class='nc_field'>
                        {{reviewer_first_name}} {{reviewer_last_name}}&nbsp;
                    </div>                
                </td>
                <td width='30%'>
                    <div class='nc_desc'>
                        Submitted
                    </div>
                    <div class='nc_field'>
			{{#if date_submitted}}
                        {{date_submitted}}
			{{else}}
				&nbsp;
			{{/if}}
                    </div>                
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <div class='nc_desc'>
                        E-Mail
                    </div>
                    <div class='nc_field'>
			{{email}}&nbsp;
                    </div>                
                </td>
            </tr>
        </table>
    </a>
{{/each}}