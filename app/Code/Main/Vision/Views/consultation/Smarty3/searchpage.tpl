<div id="search-page-header-{$window_id}" style="background-color: #333; padding: 3px 0px 3px 0px">
    <form name="vision-search-page-form" id="vision-search-page-form-{$window_id}" onsubmit="return false">    
    <input type="text" name="search-page-search-field" id="search-page-search-field-{$window_id}" class="search-page-field"
           style="border: 1px solid #333; padding: 3px 10px 3px 10px; background-color: rgba(240,240,240,.2); color: ghostwhite; width: 290px; border-radius: 6px" value="{$search}"/>
           &nbsp;<input type="button" id="search-page-search-button-{$window_id}" name="search-page-search-button" spellcheck="false" value=" Search " />
    </form>
</div>
<div id="search-page-body-{$window_id}" style="overflow: auto">

</div>
<div style="text-align: center; background-color: #333;" id="search-page-footer-{$window_id}">
    <div style="float: right; color: ghostwhite">Page <span  id='vision-search-{$window_id}-page'></span> of <span id='vision-search-{$window_id}-pages'></span></div>
    <div style="float: left; color: ghostwhite">Rows <span  id='vision-search-{$window_id}-from-row'></span>-<span id='vision-search-{$window_id}-to-row'></span> of <span id='vision-search-{$window_id}-rows'></span></div>
    <table style="margin-left: auto; margin-right: auto;">
        <tr>
            <td><input type='button' name='vision-search-previous' id='vision-search-{$window_id}-previous' style=''  value='<' /></td>
            <td><input type='button' name='vision-search-first' id='vision-search-{$window_id}-first' style='' value='<<' /></td>
            <td>&nbsp;&nbsp;</td>
            <td><input type='button' name='vision-search-last' id='vision-search-{$window_id}-last' style=''  value='>>' /></td>
            <td><input type='button' name='vision-search-next' id='vision-search-{$window_id}-next' style='' value='>' /></td>
        </tr>
    </table>
</div>
    <style type="text/css">
        #search-page-body-{$window_id} > div:nth-child(odd) {
            background-color: rgba(202,202,202,.2);
        }
    </style>
<script type="text/javascript">
    (function () {
        var win = Desktop.window.list['{$window_id}'];
        win.resize = function () {
            $('#search-page-body-{$window_id}').height($(win.content).height() - $E('search-page-header-{$window_id}').offsetHeight - $E('search-page-footer-{$window_id}').offsetHeight);
        }
        win._resize();
    })();
    if (!Argus.vision.queue.search) {
        Argus.vision.queue.search = Handlebars.compile((Humble.template('vision/VisionArchiveSearch')));
    }
    $('#search-page-search-button-{$window_id}').on('click',function (evt) {
        if ($('#search-page-search-field-{$window_id}').val()) {
            Argus.vision.search.execute($('#search-page-search-field-{$window_id}').val(),'{$window_id}',1,20,'{$ipa}');
        }
    }).on('keydown',function (evt) {
        if (evt.keyCode === 13) {
            Argus.vision.search.execute($('#search-page-search-field-{$window_id}').val(),'{$window_id}',1,20,'{$ipa}');
        }
    });
    Pagination.init('vision-search-{$window_id}',function (page,rows) {
        Argus.vision.search.execute($('#search-page-search-field-{$window_id}',).val(),'{$window_id}',page,rows,'{$ipa}');
    },1,20); 
</script>
