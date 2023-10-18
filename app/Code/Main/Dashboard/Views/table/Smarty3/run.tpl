<style type="text/css">
    .query-cell-header {
        background-color: #333; font-weight: bold; color: ghostwhite; padding: 5px; text-transform: uppercase
    }
    .query-cell {
        white-space: nowrap; margin-right: 6px; border-right: 1px solid #eee; padding-left: 5px; padding-right: 5px
    }
    .query-icon-{$window_id} {
        height: 22px; cursor: pointer
    }
</style>
{assign var=results value=$query->run()}
<table>
    <tr>
        <td class="query-cell-header"> &diam; </td>
    {foreach from=$query->headers() item=header}
        <td class="query-cell-header">{$header}</td>
    {/foreach}
    </tr>
    {foreach from=$results item=row}    
    <tr style="border-bottom: 1px solid #eee; background-color: rgba(99,99,99,{cycle values=".1,.3"})">
        <td class="query-cell"><img src="/images/dashboard/edit_icon.png" class="query-icon-{$window_id}" row_id="{$row.id}" /> </td>
        {foreach from=$row item=field}
            <td class="query-cell">{$field}</td>
        {/foreach}
    </tr>
    {/foreach}        
</table>
<div style="font-size: 1.1em; font-weight: bolder; padding-top: 4px; border-top: 2px solid #333">
    Rows {$query->_fromRow()} to {$query->_toRow()} of {$query->_rowCount()}
    <div style="float: right"> Page {$query->_page()} of {$query->_pages()}</div>
</div>

<script type="text/javascript">
    $('.query-icon-{$window_id}').on('click',function (evt) {
        var win = Desktop.window.list['{$window_id}'];
        (new EasyAjax('/dashboard/table/edit')).add('window_id','{$window_id}').packageForm('table_select_and_edit_form_{$window_id}').add('id',evt.target.getAttribute('row_id')).then(function (response) {
            win.splashScreen(response);
        }).post();
    });
    (function () {
        var pages = [];
        for (var i=0; i<{$query->_pages()}; i++) {
            pages[pages.length] = {
                'text': i+1,
                'value': i+1
            }
        }
        EasyEdits.populateSelectBox('query_page_{$window_id}',pages);
    })();
</script>
