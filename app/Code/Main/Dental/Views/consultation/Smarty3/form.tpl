{*debug*}
<style type="text/css">
    .block {
        display: inline-block; color: #333
    }
    .field-block {
        white-space: nowrap; margin-right: 2px; margin-bottom: 2px; display: inline-block
    }
    .form-row {
        overflow: hidden; width: 100%; clear: both; white-space: nowrap
    }
    .form-field {
        background-color: #dfdfdf; border: 1px solid transparent; padding: 3px; border-radius: 3px; border-bottom-color: #999
    }
    .form-field:focus {
        background-color: lightcyan; border-bottom-color: #333
    }
    .diagnosis_codes_header {
        text-align: center; font-weight: bolder; text-decoration: underline
    }
    .diagnosis_codes_cell {
        overflow: hidden;
    }
</style>
<div id="dental-form-tabs">
    
</div>
<div id="dental-form-images-tab">
    <div style="display: none; position: absolute; top: 0px; left: 0px; z-index: 100" id="scan-upload-layer-{$window_id}">
        <table style='width: 100%; height: 100%;'>
            <tr>
                <td style='background-color: rgba(77,77,77,.3)'>
                    <div style='width: 500px; padding: 10px; border-radius: 10px; border: 1px solid #aaf; background-color: ghostwhite; margin-left: auto; margin-right: auto'>
                        <form name='dental-attach-scan-form' id='dental-attach-scan-form-{$window_id}' onsubmit='return false'>
                            <fieldset style='padding: 10px'>
                                <legend>Instructions</legend>
                                Please use the file selection box below to select an image to attach to this form, and then click 'Attach', otherwise click 'Cancel' to close this window<br /><br />
                                <input type='file' multiple="true" name='form-scan-image' id='form-scan-image-{$window_id}' style='background-color: lightcyan; padding: 3px; border: 1px solid #aaf; border-radius: 3px; width: 300px' placeholder='Scanned Image' /><br /><br />
                                <input type='button' value='Attach' style='float: right' onclick='Argus.vision.scan.attach("{$form_id}","{$window_id}")' />
                                <input type='button' value='Cancel' onclick="$('#scan-upload-layer-{$window_id}').css('display','none')" />
                            </fieldset>
                        </form>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div>
    <div style='clear: both'></div>

        <div id='form-scan-list-{$window_id}'>
        </div>
        <div style=''>
            <input type='button' id='add-scan-button-{$window_id}' value='Add Scan' />
        </div>        
    </div>                            
</div>
<div id="dental-form-tab">
    <form name="dental-consultation-form" id="dental-consultation-form-{$window_id}" onsubmit="return false">
        <input type="hidden" name="pcp_staff_signature" id="pcp_staff_signature-{$window_id}" value="" />
        <input type="hidden" name="od_signature" id="od_signature1-{$window_id}" value="" />
        <div style="width: 885px; padding-left: 10px; padding-right: 10px; margin-left: 10px">


        </div>

    <br /><br /><br />
</div>
<script type='text/javascript'>
    //First we create a new form in a form table, getting the "ID"
    //All fields will be stored in mongo
    //Every change to a field will cause a save on the server
    //On form load, we go get all field values and set them here ON LOAD WE HAVE THE WINDOW ID SO WE CAN RECREATE THE PROPER IDS!

    //IF YOU HAVE EDIT AUTHORITY, THEN YOU CAN CONTINUE TO EDIT THIS FORM, OTHERWISE IGNORE MODIFICATIONS
    //
    //CAN EDIT IF (even in browse mode):
    //  IF FORM STATUS == 'NEW' AND YOU ARE CREATOR
    //  IF FORM STATUS IS SUBMITTED AND YOU ARE THE RECIPIENT
    //  IF FORM STATIS IS REVIEWED AND YOU ARE CREATOR (going to resubmit it)
    //
    {assign var=next_status value=''}
    {if ( (($status == 'N') && ($role->getUserId() == $data['created_by']))  || (($status == 'S') && ($doctor)) || (($status=='R') && ($role->getUserId() == $data['created_by'])))}
    $('#dental-consultation-form-{$window_id}').on('change',function (evt) {
        var ao = new EasyAjax('/dental/consultation/save');
        ao.add('id','{$form_id}');
        ao.add(evt.target.name,ao.getValue(evt.target,'dental-consultation-form-{$window_id}'));
        ao.then(function (response) {
        }).post();
    });
    {/if}
    $('#date_of_birth-{$window_id}').datepicker();
    $('#form_date-{$window_id}').datepicker();
    var f = (function (win_id) {
        var win = Desktop.window.list[win_id];
        return function () {
            win._scroll(false);
            $('#scan-upload-layer-{$window_id}').css('display','block').css('height','100%').css('width','100%');
        };
    })('{$window_id}');

    $('#action-button-{$window_id}').on('click',function () {
        (new EasyAjax('/vision/consultation/status')).add('id','{$form_id}').add('status','{$next_status}').then(function (response) {
            Desktop.window.list['{$window_id}']._close();
        }).post();
    });
    (new EasyAjax('/vision/retina/scans')).add('form_id','{$form_id}').add('window_id','{$window_id}').then(function (response) {
        $('#form-scan-list-{$window_id}').html(response);
    }).post();
    {if ($browse)}
        {foreach from=$data item=value key=field}
            Argus.tools.value.set('dental-consultation-form-{$window_id}','{$field}-{$window_id}','{$field}',"{$value}")
        {/foreach}
    {/if}
    var tabs = new EasyTab('dental-form-tabs');
    tabs.add('Form',null,'dental-form-tab',120);
    tabs.add('Images',null,'dental-form-images-tab',120);
    tabs.tabClick(0);
</script>