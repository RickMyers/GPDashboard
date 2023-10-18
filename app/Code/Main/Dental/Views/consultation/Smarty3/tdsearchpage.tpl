<div id="search-page-header-{$window_id}" style="background-color: #333; padding: 3px 0px 3px 0px">
    <form name="dental-tdsearch-page-form" id="dental-tdsearch-page-form-{$window_id}" onsubmit="return false">    
    <input type="text" name="search-page-tdsearch-field" id="search-page-tdsearch-field-{$window_id}" class="search-page-field"
           style="border: 1px solid #333; padding: 3px 10px 3px 10px; background-color: rgba(240,240,240,.2); color: ghostwhite; width: 290px; border-radius: 6px" value="{$text}"/>
           &nbsp;<input type="button" id="search-page-tdsearch-button-{$window_id}" name="search-page-tdsearch-button" spellcheck="false" value=" Search " />
    </form>
</div>
<div id="search-page-body-{$window_id}" style="overflow: auto">

</div>
<div style="text-align: center; background-color: #333;" id="search-page-footer-{$window_id}">
    <div style="float: right; color: ghostwhite">Page <span  id='dental-tdsearch-{$window_id}-page'></span> of <span id='dental-tdsearch-{$window_id}-pages'></span></div>
    <div style="float: left; color: ghostwhite">Rows <span  id='dental-tdsearch-{$window_id}-from-row'></span>-<span id='dental-tdsearch-{$window_id}-to-row'></span> of <span id='dental-tdsearch-{$window_id}-rows'></span></div>
    <table style="margin-left: auto; margin-right: auto;">
        <tr>
            <td><input type='button' name='dental-tdsearch-previous' id='dental-tdsearch-{$window_id}-previous' style=''  value='<' /></td>
            <td><input type='button' name='dental-tdsearch-first' id='dental-tdsearch-{$window_id}-first' style='' value='<<' /></td>
            <td>&nbsp;&nbsp;</td>
            <td><input type='button' name='dental-tdsearch-last' id='dental-tdsearch-{$window_id}-last' style=''  value='>>' /></td>
            <td><input type='button' name='dental-tdsearch-next' id='dental-tdsearch-{$window_id}-next' style='' value='>' /></td>
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
            $('#search-page-body-{$window_id}').height($(win.content).height() - $E('search-page-header-{$window_id}').offsetHeight - $E('search-page-footer-{$window_id}').offsetHeight-8);
        }
        win._resize();
    })();
    if (!Argus.dental.hedis.search) {
        Argus.dental.consultation.searchresults = Handlebars.compile((Humble.template('dental/TeledentistryConsultationSearch')));
    }
    $('#search-page-tdsearch-button-{$window_id}').on('click',function (evt) {
        if ($('#search-page-tdsearch-button-{$window_id}').val()) {
            (new EasyAjax('/dental/consultation/tdsearch')).add('window_id','{$window_id}').add('text',$('#search-page-tdsearch-field-{$window_id}').val()).then(function (response) {
                var raw = {
                    "data": JSON.parse(response)
                };
                Pagination.set('dental-tdsearch-{$window_id}',this.getPagination());
                $('#search-page-body-{$window_id}').html(Argus.dental.consultation.searchresults(raw));
            }).get();
        }
    });
    Pagination.init('dental-tdsearch-{$window_id}',function (page,rows) {
        (new EasyAjax('/dental/consultation/tdsearch')).add('window_id','{$window_id}').add('page',page).add('rows',rows).add('text',$('#search-page-tdsearch-field-{$window_id}').val()).then(function (response) {
            var raw = {
                "data": JSON.parse(response)
            };
            Pagination.set('dental-tdsearch-{$window_id}',this.getPagination());
            $('#search-page-body-{$window_id}').html(Argus.dental.consultation.searchresults(raw));
        }).post();
    },1,20); 
</script>
