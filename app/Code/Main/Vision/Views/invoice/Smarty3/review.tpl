{assign var=invoices value=$noncon->availableInvoices()}
{assign var=location_ctr value=0}
<style type="text/css">
    .invoice-office {
        background-color: #666; color: ghostwhite;  font-size: 1em;
    }
    .invoice-office td {
        padding: 5px;
    }
    .invoice-office-member {
        background-color: lightcyan; font-size: .9em; font-family: monospace; 
    }
    .invoice-office-member td {
        padding: 0px;
    }
</style>
<form name="invoice_review_form" id="invoice_review_form_{$window_id}" onsubmit="return false">
    <div style="background-color: #333; position: relative; padding: 10px 5px 10px 5px; font-size: 1.2em; color: ghostwhite" id="invoice_header_{$window_id}">
        <div id="invoice_nav_{$window_id}" style="color: #333"></div>
    </div>
    <div style="overflow: auto" id="invoice_body_{$window_id}">
        <div id="invoice_review_tab_{$window_id}">
            <table style="width: 100%">
                <tr class='invoice-office'>
                    <td colspan='4'>
                        <select name='invoice-year' id='invoice-year-{$window_id}' style="padding: 2px; border: 1px solid #aaf; background-color: lightcyan; width: 175px" placeholder="Year...">
                            <option value=''></option>
                            <option value='2020'>2020</option>
                            <option value='2021'>2021</option>
                            <option value='2022'>2022</option>
                            <option value='2023'>2023</option>
                            <option value='2024'>2024</option>
                            <option value='2025'>2025</option>
                            <option value='2026'>2026</option>
                        </select>
                    </td>
                </tr>
                {foreach from=$invoices item=locations key=address}            
                    {assign var=location_ctr value=$location_ctr+1}
                    <tr class="invoice-office">
                        <td colspan="4" class="">
                            {$locations[0]['ipa']} - {$address} <a href='#' onclick='$(".location_{$location_ctr}").attr("checked",!$(".location_{$location_ctr}").attr("checked")).trigger("click"); return false'>Toggle</a>
                        </td>
                    </tr>
                    <tr class="invoice-office-member"><td colspan="4">&nbsp;</td></tr>
                    <tr class="invoice-office-member">
                        <td>
                            <table>
                                <tr>
                                    <td style="padding-left: 50px; width:75px; text-align: center"> &diam; </td>
                                    <td style="width: 100px; color: black; font-style: italic">Form ID</td>
                                    <td style="width: 150px; color: black; font-style: italic">Healthplan</td>
                                    <td style="width: 100px; color: black; font-style: italic">Event Date</td>
                                    <td style="width: 100px; color: black; font-style: italic">Member ID</td>
                                    <td style="color: black; font-style: italic">Name &amp; Demographics</td>
                                </tr>
                            </table> 
                        </td>
                    </tr>                
                    {foreach from=$locations item=location}
                        <tr class="invoice-office-member">
                            <td>
                                <table>
                                    <tr>
                                        <td style="padding-left: 50px; width:75px; text-align: center"><input type="checkbox" class="invoice_action_{$window_id} location_{$location_ctr}" value="{$location.form_id}" /></td>
                                        <td style="width: 100px; color: black; font-style: italic"><a href="#" onclick="Argus.vision.consultation.open('{$location.form_id}'); return false">{$location.id}</a></td>
                                        <td style="padding-right: 8px"><img title='Clear this form from the invoice list' src="/images/vision/clear_from_invoice.png" style="height: 20px; cursor: pointer" onclick="Argus.vision.invoice.remove('{$location.id}','{$window_id}')" />
                                        <td style="width: 150px">{$location.screening_client}</td>                        
                                        <td style="width: 100px; color: black; font-style: italic">{$location.event_date|date_format:'m/d/Y'}</td>
                                        <td style="width: 100px">{$location.member_id}</td>
                                        <td>{$location.member_name} [{if (isset($location.gender))}{$location.gender}-{/if}{if (isset($location.date_of_birth))}{$location.date_of_birth}{/if}]</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    {/foreach}
                    <tr class="invoice-office-member"><td colspan="4">&nbsp;</td></tr>
                {/foreach}
            </table>
        </div>
        <div id="invoice_list_tab_{$window_id}"></div>
    </div>
    <div  id="invoice_foot_{$window_id}" style="background-color: #333; position: relative; padding: 5px;">
        <input type="button" style="float: right;" id="invoice_review_submit_{$window_id}" value="  Review Invoice  " />
        <div style="clear: both"></div>
    </div>
</form>
<script type='text/javascript'>
    (function () {
        var win     = Desktop.window.list['{$window_id}'];
        var forms   = {   };
        win.resize  = function () {
            $('#invoice_body_{$window_id}').height(win.content.height() - $E('invoice_header_{$window_id}').offsetHeight - $E('invoice_foot_{$window_id}').offsetHeight);
            $('#invoice_list_tab_{$window_id}').height($('#invoice_body_{$window_id}').height());
        }
        $('.invoice_action_{$window_id}').on('click',function (evt) {
            forms[this.value] = this.checked; 
        });
        $('#invoice_review_submit_{$window_id}').on('click',function (evt) {
            let win = Desktop.semaphore.checkout(true);
            (new EasyAjax('/vision/invoice/edit')).add('window_id',win.id).add('forms',JSON.stringify(forms)).add('forms_text',JSON.stringify(forms)).add('action','review').then(function (response) {
                win.dock('L')._title('Create &amp; Edit Invoice')._scroll(true)._open(response);
            }).post();
        });
        $('#invoice-year-{$window_id}').on('change',function (evt) {
            let year = $(evt.target).val();
            if (year) {
                (new EasyAjax('/vision/invoice/review')).add('year',year).add('window_id','{$window_id}').then(function (response) {
                    Desktop.window.list['{$window_id}'].set(response);
                }).post();
            }
        }).val('{$noncon->getYear()|date_format:'Y'}');
        var xx = new EasyTab('invoice_nav_{$window_id}',140);
        var f = function () {
            (new EasyAjax('/vision/invoice/list')).add('row',50).add('page',1).add('window_id','{$window_id}').then(function (response) {
                $('#invoice_list_tab_{$window_id}').html(response);
            }).post(); 
        }
        xx.add('Non-Contracted Batching',null,'invoice_review_tab_{$window_id}',200)
        xx.add('Invoice List',f,'invoice_list_tab_{$window_id}')
        xx.tabClick(0);
    })();
</script>