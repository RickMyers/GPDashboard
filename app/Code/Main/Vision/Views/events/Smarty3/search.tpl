<div id="event-list-header" style="background-color: #333; padding: 3px 0px 3px 0px">
    <form name="event-list-page-form" id="event-list-page-form" onsubmit="return false">    
    <input type="text" name="event-list-search-field" id="event-list-search-field" class="event-list-field"
           style="border: 1px solid #333; padding: 3px 10px 3px 10px; background-color: rgba(240,240,240,.2); color: ghostwhite; width: 290px; border-radius: 6px" value=""/>
           &nbsp;<input type="button" id="event-list-search-button" name="event-list-search-button" spellcheck="false" value=" Search " />
    </form>
</div>
<div id="event-list-body" style="overflow: auto">

</div>
<div style="text-align: center; background-color: #333;" id="event-list-footer">
    <div style="float: right; color: ghostwhite">Page <span  id='event-list-page'></span> of <span id='event-list-pages'></span></div>
    <div style="float: left; color: ghostwhite">Rows <span  id='event-list-from-row'></span>-<span id='event-list-to-row'></span> of <span id='event-list-rows'></span></div>
    <table style="margin-left: auto; margin-right: auto;">
        <tr>
            <td><input type='button' name='event-list-previous' id='event-list-previous' style=''  value='<' /></td>
            <td><input type='button' name='event-list-first' id='event-list-first' style='' value='<<' /></td>
            <td>&nbsp;&nbsp;</td>
            <td><input type='button' name='event-list-last' id='event-list-last' style=''  value='>>' /></td>
            <td><input type='button' name='event-list-next' id='event-list-next' style='' value='>' /></td>
        </tr>
    </table>
</div>
    <style type="text/css">
        #event-list-body > div:nth-child(odd) {
            background-color: rgba(202,202,202,.2);
        }
    </style>
<script type="text/javascript">
    (function () {
        var win = Desktop.window.list['{$window_id}'];
        win.resize = function () {
            $('#event-list-body').height($(win.content).height() - $E('event-list-header').offsetHeight - $E('event-list-footer').offsetHeight);
        }
        win._resize();
    })();
    $('#event-list-search-button').on('click',function (evt) {
        if ($('#event-list-search-field').val()) {
            Argus.vision.event.list($('#event-list-body').get(),'{$window_id}',1,20);
        }
    });
    Pagination.init('event-list',function (page,rows) {
        Argus.vision.event.list($('#event-list-body').get(),page,rows);
    },1,20); 
</script>

