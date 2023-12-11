{*
    This edit page has 4 different modes:
    
    1) Review - the invoice is mocked up with forms/members shown on it, but the invoice isn't actually created, and members/forms are not assigned.
                The reviewer can close the invoice without changing anything, and add or remove forms from the invoice.  The invoice isn't actually
                created until the review agrees with the invoice and then clicks the "create" button.
    2) Edit   - the invoice was created and now the creator of the invoice can populate the necessary fields.
    3) Print  - This is the final stage of the invoice that can then be printed as a PDF and emailed to the recipient. In print mode, there are no
                fields able to be edited.
    4) View   - This is for after an invoice has been created.  It can no longer be changed, but can be marked as paid
*}
{assign var=default_amount value=18} {* THIS IS THE AMOUNT WE ARE GOING TO CHARGE PER ENCOUNTER *}
{assign var=id value=$header->getId()}
{if (($action=='edit') || ($action=='print'))}
    {assign var=members value=$forms->invoiceFormData()}
    {assign var=heading value=$header->load()}
{else if ($action=='review')}
    {assign var=members value=$forms->memberData($forms_text)} 
{else if ($action=='view')}
    {assign var=heading value=$header->load()}
    {assign var=members value=$forms->invoiceFormData()}
{/if}
{assign var=invoice_total value=0}
<style type="text/css">
    .invoice_member_header {
        color: ghostwhite; font-size: 1.1em; font-family: sans-serif; padding: 5px; text-align: center
    }
    .invoice_member_cell {
        color: #44546A; font-family: monospace; font-size: 1em;
    }
    .edit_invoice_field {
        color: #333; background-color: lightcyan; padding: 0px ; font-size: .9em; font-family: monospace; border: 1px inset silver; border-radius: 1px;
    }
    .invoice_member_footer {
    }
</style>
<form name="invoice_edit_form" id="invoice_edit_form_{$window_id}" onsubmit="return false">
    <input type="hidden" name="invoice_id" id="invoice_id_{$window_id}" value="{$id}" />
    {if ($action!='view')}
    <input type="hidden" name="forms_json" id="forms_json_{$window_id}" value='{$forms_text}' />
    {/if}
    {if ($action!='print')}
        <div style="background-color: #333; position: relative; padding: 10px 5px 10px 5px; font-size: 1.2em; color: ghostwhite" id="invoice_header_{$window_id}">
            {if ($action=='review')}
            <input type="button" style="float: right; color: #333" id="invoice_create_submit_{$window_id}" value="  Create &amp; Edit Invoice  " />
            <div style="clear: both"></div>
            {else}
                &nbsp;
            {/if}
        </div>
    {/if}
    <div style="overflow: auto" id="invoice_body_{$window_id}">
        <div style="width: 820px; border: 1px solid #333; margin-left: auto; margin-right: auto; margin-top: 20px; margin-bottom: 20px; padding: 10px">
            <img src="/images/dashboard/aflac_logo.png" style='margin-bottom: 10px'/>
            <div style="padding: 20px 60px; font-weight: bold; color: white; background-color: #44546A; width: 25%; text-align: center; margin-bottom: 30px">
                INVOICE
            </div>
            <div style="border-bottom: 1px solid black; font-family: monospace; font-size: 1.0em; padding-bottom: 10px; display: inline-block; padding-right: 20px; padding-left: 10px; width: 35%">
                <div>4211 West Boy Scout Blvd, Suite 295</div>
                <div>Tampa, FL, 33607</div>
                <div>Ph: 877.710.5174</div>
                <div>Fax: 813.425.1951</div>
            </div>
            <div style="border-bottom: 1px solid black;padding-top: 50px; display: inline-block; font-size: .95em; font-weight: bolder; color: #44546A; width: 50%; padding-bottom: 11px">
                {if ($action=='edit')}
                    <div style='padding-left: 10px'>INVOICE DATE: <input type="text" class="edit_invoice_field invoice_fields_{$window_id}" name="invoice_date" id="invoice_date_{$window_id}" placeholder='XX.XX.XXXX' style='display: inline-block; width: 100px' /></div>
                {else if ($action=='review')}
                    <div style='padding-left: 10px'>INVOICE DATE: XX.XX.XXXX</div>
                {else if (($action=='print') || ($action=='view'))}
                    <div style='padding-left: 10px'>INVOICE DATE: {$header->getInvoiceDate()|date_format:'m/d/Y'}</div>
                {/if}
            </div>
            
            <div style="font-family: sans-serif; font-size: 1.1em; padding-bottom: 10px; display: inline-block; padding-right: 20px; padding-left: 10px; width: 35%; font-weight: bold; color: #44546A;">
                <div>TO:</div>
                {if ($action=='edit')}
                    <div><input type="text" style="width: 215px" class="edit_invoice_field invoice_fields_{$window_id}" name="name" id="name_{$window_id}" class="invoice_fields_{$window_id}" placeholder="NAME" /></div>
                    <div><input type="text" style="width: 215px" class="edit_invoice_field invoice_fields_{$window_id}" name="company_name" id="company_name_{$window_id}" class="invoice_fields_{$window_id}" placeholder="COMPANY NAME" /></div>
                    <div><input type="text" style="width: 215px" class="edit_invoice_field invoice_fields_{$window_id}" name="address" id="address_{$window_id}" class="invoice_fields_{$window_id}" placeholder="ADDRESS" /></div>
                    <div>
                        <input type="text"  style="width: 100px; display: inline-block" class="edit_invoice_field invoice_fields_{$window_id}" name="city" id="city_{$window_id}" class="invoice_fields_{$window_id}" placeholder="CITY" 
                        /><input type="text" style="width: 40px; display: inline-block" class="edit_invoice_field invoice_fields_{$window_id}" name="state" id="state_{$window_id}" class="invoice_fields_{$window_id}" placeholder="STATE" 
                        /><input type="text" style="width: 75px; display: inline-block" class="edit_invoice_field invoice_fields_{$window_id}" name="zip_code" id="zip_code_{$window_id}" class="invoice_fields_{$window_id}" placeholder="ZIP CODE" />
                    </div>
                    <div><input type="text" style="width: 215px" class="edit_invoice_field  invoice_fields_{$window_id}" name="phone" id="phone_{$window_id}" class="invoice_fields_{$window_id}" placeholder="PHONE" /></div>
                    <div><input type="text" style="width: 215px" class="edit_invoice_field  invoice_fields_{$window_id}" name="email" id="email_{$window_id}" class="invoice_fields_{$window_id}" placeholder="EMAIL" /></div>
                {else if (($action=='print') || ($action=='view'))}
                    <div>{$header->getName()}</div>
                    <div>{$header->getCompanyName()}</div>
                    <div>{$header->getAddress()}</div>
                    <div>{$header->getCity()}, {$header->getState()}, {$header->getZipCode}</div>
                    <div>{$header->getPhone()}</div>
                    <div>{$header->getEmail()}</div>
                {else if ($action=='review')}
                    <div>NAME</div>
                    <div>COMPANY NAME</div>
                    <div>ADDRESS</div>
                    <div>CITY, STATE, ZIP</div>
                    <div>Phone</div>
                    <div>EMAIL</div>
                {/if}
            </div>
            <div style="padding-top: 50px; display: inline-block; font-size: .95em; font-weight: bolder; color: #44546A; width: 50%">
                <div style='padding-left: 10px'>RE: Retinal Image Reviews</div>
            </div> 
            <div style='clear: both'></div>
            <div>
                <table style='width: 100%' cellspacing="0" cellpadding="0">
                    <tr style="background-color: #44546A">
                        <td class="invoice_member_header">Item #</td>
                        <td class="invoice_member_header">DOS</td>
                        <td class="invoice_member_header">HEALTH PLAN</td>
                        <td class="invoice_member_header">MEMBER ID</td>
                        <td class="invoice_member_header">MEMBER NAME</td>
                        <td class="invoice_member_header">AMOUNT</td>
                    </tr>
                    {foreach from=$members key=index item=member}
                    <tr style="border-top: 1px solid #44546A">
                        <td class="invoice_member_cell" style="text-align: center">{$index+1}</td>
                        <td class="invoice_member_cell" style="text-align: center">{$member.event_date|date_format:"m/d/Y"}</td>
                        <td class="invoice_member_cell">{$member.screening_client}</td>
                        <td class="invoice_member_cell">{$member.member_id}</td>
                        <td class="invoice_member_cell">{$member.member_name}</td>
                        {if (!isset($member.amount))}
                            {assign var=invoice_total value=$invoice_total+$default_amount}
                        {else if ($action=='review')}
                            {assign var=invoice_total value=$invoice_total+$default_amount}
                        {else}
                            {if (isset($member.amount))}{assign var=invoice_total value=$invoice_total+$member.amount}{/if}
                        {/if}
                        <td class="invoice_member_cell" style="text-align: center">{if ($action=='edit')}$<input type='text' invoice_form_id='{$member.id}' class='edit_invoice_field edit_invoice_amount_field_{$window_id}' style='text-align: center; width: 30px' value='18.0' placeholder='0.0' {if (isset($member.amount))}value='{$member.amount}'/>{/if}{else}{if (isset($member.amount))}${$member.amount}{else}$18.0{/if}{/if}</td>
                    </tr>
                    {/foreach}
                    <tr style="border-top: 2px solid #44546A; border-bottom: 2px solid #44546A">
                        <td colspan="4">
                            &nbsp;
                        </td>
                        <td class="invoice_member_cell">
                            Total:
                        </td>
                        <td class="invoice_member_cell" style="text-align: center; font-weight: bold">
                            $<span id="invoice_total_{$window_id}">{$invoice_total}</span>
                        </td>
                    </tr>
                </table>
                <div style="font-family: sans-serif; margin-top: 20px; color: #333; font-size: 1em">
                    Make all checks payable to:<br />
                    Aflac Benefits Solutions, Inc<br />
                    ATTN: Aflac Benefits Solutions, Inc, Accounts Receivable<br />
                    Payment is due within 15 days.<br />
                </div>
                <div style="margin-top: 20px; text-align: center; font-size: 1em; font-family: sans-serif; color: #333">
                    If you have any questions concerning this invoice, contact HEDIS representative@ 1.877.710.5174<br /><br />
                    HEDIS@aflacbenefitssolutions.com<br /><br />
                    <br />
                    <span style="color: #44546A; font-weight: bolder">Thank you for your business!</span>
                </div>
            </div>            
        </div>

    </div>
    {if ($action!='print')}
    <div  id="invoice_foot_{$window_id}" style="background-color: #333; position: relative; padding: 5px;">
        {if (($action=='edit') || ($action=='view'))}
        <input type="button" style="float: left;"  id="invoice_paid_submit_{$window_id}"  value="  Mark Paid  " />
        <input type="button" style="float: right;" id="invoice_print_submit_{$window_id}" value="  Print Invoice  " />
        <div style="clear: both"></div>
        {else}
            &nbsp;
        {/if}
    </div>
    {/if}
</form>
<script type='text/javascript'>
    (function () {
        function calculateInvoiceTotal() {
            let total = 0;
            $('.edit_invoice_amount_field_{$window_id}').each(function (n,element) {
                total += +(element.value ? element.value : 0);
                $('#invoice_total_{$window_id}').html(total)
            });
        }
        var win = Desktop.window.list['{$window_id}'];
        win.resize = function () {
            $('#invoice_body_{$window_id}').height(win.content.height() - $E('invoice_header_{$window_id}').offsetHeight - $E('invoice_foot_{$window_id}').offsetHeight);
        };
        $('.edit_invoice_amount_field_{$window_id}').on('change',function (evt) {
            (new EasyAjax('/vision/invoice/update')).add('invoice_row_id',+this.getAttribute('invoice_form_id')).add('amount',+this.value).then(function (response) {
                calculateInvoiceTotal();
            }).post();
        });
        $('#invoice_create_submit_{$window_id}').on('click',function (evt) {
            let me = win;
            if (confirm('Are you ready to create the invoice?')) {
                (new EasyAjax('/vision/invoice/create')).add('forms',$('#forms_json_{$window_id}').add('action','edit').val()).then(function (response) {
                    let win = me;
                    $('#invoice_id_{$window_id}').val(+response);
                    (new EasyAjax('/vision/invoice/edit')).add('action','edit').add('invoice_id',+response).add('window_id','{$window_id}').then(function (response) {
                        win.set(response)._resize();
                    }).post();
                }).post();
            }
        });
        $('#invoice_print_submit_{$window_id}').on('click',function (evt) {
            window.open('/vision/invoice/print?invoice_id='+$('#invoice_id_{$window_id}').val()+'&action=print');
        });
        $('.invoice_fields_{$window_id}').on('change',function (evt) {
            (new EasyAjax('/vision/invoice/save')).add('invoice_id',$('#invoice_id_{$window_id}').val()).add(this.name,this.value).then(function (response) {
                
            }).post();
        });
        $('#invoice_paid_submit_{$window_id}').on('click',function (evt) {
            if (confirm('\nAre you sure you want to mark this invoice as paid?\n\nIf so, all forms will be released to the respective PCP portals.\n')) {
                (new EasyAjax('/vision/invoice/paid')).add('invoice_id',$('#invoice_id_{$window_id}').val()).then(function (response) {
                    win._close();
                }).post();
            }
        });
        {if ($action=='edit')}
            calculateInvoiceTotal();
        {/if}
    })();
</script>
