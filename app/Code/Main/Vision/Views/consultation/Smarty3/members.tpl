<div id="member-search-header" style="background-color: #333; padding: 3px 0px 3px 0px">
    <form name="vision-member-search-form" id="vision-member-search-form" onsubmit="return false">    
    <input type="text" name="member-search-field" id="member-search-field" class="member-search-field"
           style="border: 1px solid #333; padding: 3px 10px 3px 10px; background-color: rgba(240,240,240,.2); color: ghostwhite; width: 290px; border-radius: 6px" value="{$search}"/>
           &nbsp;<input type="button" id="member-search-button" name="member-search-button" spellcheck="false" value=" Search " />
    </form>
</div>
<div id="member-search-body" style="overflow: auto">

</div>
<div style="text-align: center; background-color: #333;" id="member-search-footer">
    <div style="float: right; color: ghostwhite">Page <span  id='vision-member-search-page'></span> of <span id='vision-member-search-pages'></span></div>
    <div style="float: left; color: ghostwhite">Rows <span  id='vision-member-search-from-row'></span>-<span id='vision-member-search-to-row'></span> of <span id='vision-member-search-rows'></span></div>
    <table style="margin-left: auto; margin-right: auto;">
        <tr>
            <td><input type='button' name='vision-member-search-previous' id='vision-member-search-previous' style=''  value='<' /></td>
            <td><input type='button' name='vision-member-search-first' id='vision-member-search-first' style='' value='<<' /></td>
            <td>&nbsp;&nbsp;</td>
            <td><input type='button' name='vision-member-search-last' id='vision-member-search-last' style=''  value='>>' /></td>
            <td><input type='button' name='vision-member-search-next' id='vision-member-search-next' style='' value='>' /></td>
        </tr>
    </table>
</div>
    <style type="text/css">
        #member-search-body > div:nth-child(odd) {
            background-color: rgba(202,202,202,.2);
        }
    </style>
<script type="text/javascript">
    var win_id = Desktop.whoami('member-search-footer');
    (function (win_id) {
        var win = Desktop.window.list[win_id];
        win.resize = function () {
            $('#member-search-body').height($(win.content).height() - $E('member-search-header').offsetHeight - $E('member-search-footer').offsetHeight);
        }
        win._resize();
    })(win_id);
    if (!Argus.vision.queue.member) {
        Argus.vision.queue.member = Handlebars.compile((Humble.template('vision/VisionMemberSearch')));
    }
    $('#member-search-button').on('click',function (evt) {
        if ($('#member-search-field').val()) {
            Argus.vision.search.member(1,30);
        }
    }).on('keydown',function (evt) {
        if (evt.keyCode === 13) {
            Argus.vision.search.member(1,30);
        }
    });
    Pagination.init('vision-member-search',function (page,rows) {
        Argus.vision.search.member(page,rows);
    },1,30); 
</script>

