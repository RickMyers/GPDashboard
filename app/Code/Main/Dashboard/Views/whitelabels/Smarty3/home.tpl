<style type="text/css">
    .pagination_control {
        padding: 2px 5px; color: #333
    }    
</style>
<h3>White Label Options</h3>
<div id="white-labels-display-area">

</div>
<table width='100%'>
    <tr style="background-color: #333">
        <td style="padding: 5px 0px 5px 0px">
            <span id='whitelabeling-from-row'></span>-<span id='whitelabeling-to-row'></span> of <span id='whitelabeling-rows'></span>
        </td>
        <td style="padding: 5px 0px 5px 0px" align='center'>
            <input type='button' name='whitelabeling-previous' id='whitelabeling-previous' style='' class='pagination_control' value='<' />
            <input type='button' name='whitelabeling-first' id='whitelabeling-first' style='' class='pagination_control' value='<<' />
            &nbsp;&nbsp;
            <input type='button' name='whitelabeling-last' id='whitelabeling-last' style='' class='pagination_control' value='>>' />
            <input type='button' name='whitelabeling-next' id='whitelabeling-next' style='' class='pagination_control' value='>' />
        </td>
        <td style="padding: 5px 4px 5px 0px" align='right' >
           <span id='whitelabeling-page'></span> of <span id='whitelabeling-pages'></span>
        </td>
    </tr>
</table>
<script type="text/javascript">    
    Pagination.init('whitelabeling',function (page,rows) {
        (new EasyAjax('/dashboard/whitelabels/users')).add('page',page).add('rows',rows).then(function (response) {
            $('#white-labels-display-area').html(response);
            Pagination.set('whitelabeling',this.getPagination());
        }).post();
    },1,15);    
</script>
