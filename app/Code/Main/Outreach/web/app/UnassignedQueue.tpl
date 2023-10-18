{{#each data}}
    <div onclick='Argus.outreach.contact.open({{id}})' style='cursor: pointer; position: relative; background-color: rgba(222,222,222,{{zebra @index}})'>
        <div class="outreach-cell" style="width: 25%">
            <div class='outreach-desc'>
                Member ID
            </div>
            <div class='outreach-field'>
                {{member_number}}&nbsp;
            </div>   
        </div>
        <div class="outreach-cell" style="width: 45%">
            <div class='outreach-desc'>
                Name
            </div>
            <div class='outreach-field'>
                {{member_name}}&nbsp;
            </div>   
        </div>
        <div class="outreach-cell" style="width: 30%">
            <div class='outreach-desc'>
                Phone #
            </div>
            <div class='outreach-field'>
                <b>{{member_phone}}</b>&nbsp;
            </div>   
        </div>
        <div style="clear: both"></div>
        <div class="outreach-cell">
            <div class='outreach-desc'>
                Address
            </div>
            <div class='outreach-field'>
                {{member_address}}&nbsp;
            </div>   
        </div>
    </div>
{{/each}}
