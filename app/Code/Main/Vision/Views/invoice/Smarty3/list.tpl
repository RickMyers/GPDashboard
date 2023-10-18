<style type="text/css">
    .invoice-row {
        white-space: nowrap; overflow: hidden; display: inline-block;
    }
    .invoice-cell {
        display: inline-block
    }
    .invoice-cell-normal {
        font-family: monospace; font-size: .9em; overflow: hidden; padding-right: 2px; padding-left: 5px; clear: both;
    }
    .invoice-cell-header {
        border-bottom: 1px solid #333; font-family: sans-serif; font-weight: bold; font-size: .95em; padding-right: 2px; padding-left: 5px; clear: both;
    }    
</style>
<table style="width: 100%; height: 100%;">
    <tr style="height: 5px; background-color: #333">
        <td>

        </td>
    </tr>
    <tr>
        <td style="vertical-align: top; padding-top: 10px; overflow: auto">
            <div class="invoice-row">
                <div class="invoice-cell invoice-cell-header" style="width: 40px; text-align: center">ID</div>
                <div class="invoice-cell invoice-cell-header" style="width: 120px">Name</div>
                <div class="invoice-cell invoice-cell-header" style="width: 150px">Company</div>
                <div class="invoice-cell invoice-cell-header" style="width: 300px">Address</div>
                <div class="invoice-cell invoice-cell-header" style="width: 100px">Phone</div>
                <div class="invoice-cell invoice-cell-header" style="width: 160px">Email</div>
                <div class="invoice-cell invoice-cell-header" style="width: 40px">Paid</div>
            </div>
        {foreach from=$invoices->fetch() item=invoice}
            <div class="invoice-row" style="background-color: rgba(202,202,202,{cycle values=".1,.4"})">
                <div invoice_id="{$invoice.id}" class="invoice-cell invoice-cell-normal invoice-id-cell" style="width: 40px; text-align: center; color: blue; cursor: pointer">{$invoice.id}</div>
                <div class="invoice-cell invoice-cell-normal" style="width: 120px">{$invoice.name}</div>
                <div class="invoice-cell invoice-cell-normal" style="width: 150px">{$invoice.company}</div>
                <div class="invoice-cell invoice-cell-normal" style="width: 300px">{$invoice.address}, {$invoice.city}, {$invoice.state}, {$invoice.zip_code}</div>
                <div class="invoice-cell invoice-cell-normal" style="width: 100px">{$invoice.phone}</div>
                <div class="invoice-cell invoice-cell-normal" style="width: 160px">{$invoice.email}</div>
                <div class="invoice-cell invoice-cell-normal" style="width: 40px">{$invoice.paid}</div>
            </div>
        {/foreach}
            </div>
        </td>
    </tr>
    <tr style="height: 30px;">
        <td>
            <div style="text-align: center; border-top: 1px solid #333; padding-top: 5px">
                <div style="float: left; color: #333; padding-left: 5px">
                    Rows <span id="">{$invoices->_fromRow()}</span> to <span id="">{$invoices->_toRow()}</span> of <span id="">{$invoices->_rowCount()}</span>
                </div>
                <div style="float: right; color: #333; padding-right: 5px;">
                    Page <span id="">{$invoices->_page()}</span> of <span id="">{$invoices->_pages()}</span>
                </div>

                <div style="display: inline-block; margin-left: auto; margin-right: auto">
                    <input id="invoice_prev_page" type="button" value="  <  " />
                    <input id="invoice_first_page" type="button" value="  <<  " />
                    <input id="invoice_last_page" type="button" value="  >>  " />
                    <input id="invoice_next_page" type="button" value="  >  " />
                </div>
            </div>
            &nbsp;
        </td>
    </tr>
</table>
<script type="text/javascript">
    $('.invoice-id-cell').on("click",function (evt) {
        let win = Desktop.semaphore.checkout(true);
        (new EasyAjax('/vision/invoice/view')).add('window_id',win.id).add('invoice_id',this.getAttribute('invoice_id')).add('action','view').then(function (response) {
            win.dock('L')._title('View Invoice')._scroll(true)._open(response);
        }).post();        
    });
    (function () {
        var page = {$invoices->_page()};
        var pages = {$invoices->_pages()}
        function fetchPage(whichOne) {
            if (whichOne > pages) {
                whichOne = 1;
            }
            if (whichOne < 1) {
                whichOne = pages;
            }
            (new EasyAjax('/vision/invoice/list')).add('window_id','{$window_id}').add('page',whichOne).add('invoice_id','').then(function (response) {
                $('#invoice_list_tab_{$window_id}').html(response);
            }).post();
        }
        $("#invoice_prev_page").on("click",function () {
            fetchPage(--page);
        });
        $("#invoice_first_page").on("click",function () {
            fetchPage(1);
        });
        $("#invoice_next_page").on("click",function () {
            fetchPage(++page);
        });
        $("#invoice_last_page").on("click",function () {
            fetchPage(pages);
        });
    })();
</script>