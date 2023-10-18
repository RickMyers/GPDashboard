<style type='text/css'>
    .vision_admin_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 99.5%; height: 26px;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }
    .vision_admin_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 99.5%; margin-right: .1%; height: 355px; margin-top: 0px; overflow: auto;
    }
    .vision_admin_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 99.5%; height: 25px;
        color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }    
    .consultation_form {
        margin: .2%; overflow: auto; background-color: lightgoldenrodyellow;  border: 1px solid #333; height: 98%;
    }
    .narrow_width {
        width: 35%;
    }
    .medium_width {
        width: 25%
    }
    .wide_width {
        width: 50%
    }
    .full_width{
        width: 100%;
    }
    .nc_row {
       overflow: hidden; white-space: nowrap; display: inline-block
    }
    .nc_cell {
        padding: 1px; display: inline-block; background-color: rgba(202,202,202,.2); margin-right: 1px; margin-bottom: 1px; overflow: hidden;
    }
    .nc_desc {
        font-family: monospace; font-size: .7em; letter-spacing: 1px; color: #333
    }
    .nc_field {
        font-family: sans-serif; color: black; font-size: .8em; padding-left: 15px
    }

    .vision_pagination_control {
        padding: 2px 5px; font-size: .8em
    }    
</style>
<form nohref onsubmit="return false">
<div class='vision_admin_queue_header'>
    <!--img src="/images/vision/import.png" style="cursor: pointer; height: 20px; float: left" onclick="Argus.vision.member.importList()" title="Import Member List" /-->
    
    <select name="referral_reason" id="referral_reason" style="float: left; background-color: lightcyan; color: #333; width: 250px; padding: 2px; border: 1px solid #333; border-radius: 2px">
        <option value=""> </option>
        {foreach $forms->activeReferralReasons() item=reason}
            <option value="{$reason.referral_reason}">{$reason.referral_reason}</option> 
        {/foreach}
    </select>
    <a href='/vision/admin/export' target="_blank" style="float: right; margin-right: 5px">Export</a> Administration Required Q
</div>
<br />
<div class='vision_admin_queue_body' id="vision_admin_required_queue">
</div>

<br />
<div class='vision_admin_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='admin_required-from-row'></span>-<span id='admin_required-to-row'></span> of <span id='admin_required-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='admin_required-previous' id='admin_required-previous' style='' class='vision_pagination_control' value='<' />
                <input type='button' name='admin_required-first' id='admin_required-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='admin_required-last' id='admin_required-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='admin_required-next' id='admin_required-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='admin_required-page'></span> of <span id='admin_required-pages'></span>
            </td>
        </tr>
    </table>
</div>
</form>
<script type="text/javascript">
    Pagination.init('admin_required',function (page,rows) {
        Argus.vision.admin.refresh($E('vision_admin_required_queue'),'admin_required',page,rows);
    },1,15);    
    $('#referral_reason').on('change',function () {
        Argus.singleton.set('referral_reason',this.value);
        Argus.vision.admin.refresh($E('vision_admin_required_queue'),'admin_required',1,15);
    })
</script>

