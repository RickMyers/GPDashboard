<div id="admin-search-page-header-{$window_id}" style="background-color: #333; padding: 3px 0px 3px 0px">
    <form name="vision-admin-search-page-form" id="vision-admin-search-page-form-{$window_id}" onsubmit="return false">    
    <input type="text" name="admin-search-page-search-field" id="admin-search-page-search-field-{$window_id}" class="admin-search-page-field"
           style="border: 1px solid #333; padding: 3px 10px 3px 10px; background-color: rgba(240,240,240,.2); color: ghostwhite; width: 290px; border-radius: 6px" value="{$search}"/>
           &nbsp;<input type="button" id="admin-search-page-search-button-{$window_id}" name="admin-search-page-search-button" spellcheck="false" value=" Search " />
    </form>
</div>
<div id="admin-search-page-body-{$window_id}" style="overflow: auto">

</div>
<div style="text-align: center; background-color: #333;" id="admin-search-page-footer-{$window_id}">
    <div style="float: right; color: ghostwhite">Page <span  id='vision-admin-search-{$window_id}-page'></span> of <span id='vision-admin-search-{$window_id}-pages'></span></div>
    <div style="float: left; color: ghostwhite">Rows <span  id='vision-admin-search-{$window_id}-from-row'></span>-<span id='vision-admin-search-{$window_id}-to-row'></span> of <span id='vision-admin-search-{$window_id}-rows'></span></div>
    <table style="margin-left: auto; margin-right: auto;">
        <tr>
            <td><input type='button' name='vision-admin-search-previous' id='vision-admin-search-{$window_id}-previous' style=''  value='<' /></td>
            <td><input type='button' name='vision-admin-search-first' id='vision-admin-search-{$window_id}-first' style='' value='<<' /></td>
            <td>&nbsp;&nbsp;</td>
            <td><input type='button' name='vision-admin-search-last' id='vision-admin-search-{$window_id}-last' style=''  value='>>' /></td>
            <td><input type='button' name='vision-admin-search-next' id='vision-admin-search-{$window_id}-next' style='' value='>' /></td>
        </tr>
    </table>
</div>
    <style type="text/css">
        #admin-search-page-body-{$window_id} > div:nth-child(odd) {
            background-color: rgba(202,202,202,.2);
        }
    </style>
<script type="text/javascript">
    (function () {
        var win = Desktop.window.list['{$window_id}'];
        win.resize = function () {
            $('#admin-search-page-body-{$window_id}').height($(win.content).height() - $E('admin-search-page-header-{$window_id}').offsetHeight - $E('admin-search-page-footer-{$window_id}').offsetHeight);
        }
        win._resize();
    })();
    if (!Argus.vision.admin.queue.search) {
        Argus.vision.admin.queue.search = Handlebars.compile((Humble.template('vision/VisionArchiveSearch')));
    }
    $('#admin-search-page-search-button-{$window_id}').on('click',function (evt) {
        if ($('#admin-search-page-search-field-{$window_id}').val()) {
            Argus.vision.admin.search.execute($('#admin-search-page-search-field-{$window_id}').val(),'{$window_id}',1,20);
        }
    }).on('keydown',function (evt) {
        if (evt.keyCode === 13) {
            Argus.vision.admin.search.execute($('#admin-search-page-search-field-{$window_id}').val(),'{$window_id}',1,20);
        }
    });
    Pagination.init('vision-admin-search-{$window_id}',function (page,rows) {
        Argus.vision.admin.search.execute($('#admin-search-page-search-field-{$window_id}').val(),'{$window_id}',page,rows);
    },1,20); 
</script>

