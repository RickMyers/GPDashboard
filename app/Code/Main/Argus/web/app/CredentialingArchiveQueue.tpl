{{#each data}}
    <div onclick='Argus.vision.consultation.open("{{form_id}}")' style='cursor: pointer; position: relative'>
	<a href='#' style='position: absolute; top: 0px; left: 0px; z-index: 9; color: red' onclick="return false">XXX</a>
        <table style='width: 100%' cellspacing='1' cellpadding='0'>
            <tr>
                <td rowspan='2' colspan='10%' style='overflow: hidden; position: relative'>
                    <div style='position: relative; width: 70px; height: 60px'>
                    <img onload='Argus.tools.image.align(this)' src='/images/argus/avatars/{{creator}}.jpg' onerror="this.src='/images/argus/placeholder-{{creator_gender}}.png'"  />
                    </div>
                </td>
                <td width='30%'>
                    <div class='nc_desc'>
                        Member ID
                    </div>
                    <div class='nc_field'>
                        {{member_id}}&nbsp;
                    </div>                
                </td>
                <td width='30%'>
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
                        Date Submitted
                    </div>
                    <div class='nc_field'>
			{{#if submitted}}
				{{formatDate submitted "short"}}
			{{else}}
				&nbsp;
			{{/if}}
                    </div>
                </div>
                </td>
                <td>
                    <div class='nc_desc'>
                        Last Activity
                    </div>
                    <div class='nc_field'>
			{{#if last_activity }}
				{{last_activity}}
			{{else}}
				&nbsp;
			{{/if}}
                    </div>                
                </td>
                <td>
                    <div class='nc_desc'>
                        Review By
                    </div>
                    <div class='nc_field'>
			{{#if review_by}}
				{{review_by}}
			{{else}}
				&nbsp;
			{{/if}}
                    </div>                
                </td>
            </tr>        
        </table>
    </div>
{{/each}}