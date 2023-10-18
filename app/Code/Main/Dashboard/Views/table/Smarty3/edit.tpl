<table style="width: 100%; height: 100%;">
    <tr>
        <td>
            <div style="width: 60%; height: 80%; margin-left: auto; margin-right: auto; overflow: auto; color: #333; background-color: ghostwhite; padding: 10px; border-radius: 10px">
                <form name="query_edit_row_form" id="query_edit_row_form_{$window_id}" onsubmit="return false">
                    <fieldset>
                        <legend>{$query->getNamespace()}/{$query->getEntity()}:ID={$query->getId()}</legend>
                        <table>
                        {foreach from=$results key=col item=val}
                            {if ($col != '_id')}
                            <tr>
                                <td>{$col}</td>
                                <td><input type="text" name="{$col}" id="{$col}_{$window_id}" value="{$val}" style="background-color: lightcyan; color: #333; padding: 2px; border: 1px solid #aaf; border-radius: 2px"/></td>
                            </tr>
                            {/if}
                        {/foreach}     
                        </table>
                    </fieldset>
                    <hr />
                    <input type="button" name="query_edit_row_save" id="query_edit_row_save_{$window_id}" value="   SAVE   " style="float: right;" />
                    <input type="button" onclick="Desktop.window.list['{$window_id}'].splashScreen(); return false" value="  CLOSE  " />
                </form>
            </div>
        </td>
    </tr>    
</table>
<script type="text/javascript">
    $('#query_edit_row_save_{$window_id}').on('click',function (evt) {
        if (confirm("Save this data?")) {
            var fields = { };
            var form = $E('query_edit_row_form_{$window_id}');
            for (var i=0; i<form.elements.length; i++) {
                if (form.elements[i].type && form.elements[i].type == 'text') {
                    fields[form.elements[i].name] = form.elements[i].value;
                }
            }
            (new EasyAjax('/dashboard/table/save')).add('namespace','{$query->getNamespace()}').add('entity','{$query->getEntity()}').add('id','{$query->getId()}').add('fields',JSON.stringify(fields)).then(function (response) {
                Desktop.window.list['{$window_id}'].splashScreen();
            }).post();
        }
    });
</script>

