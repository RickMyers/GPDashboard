<style type='text/css'>
    .vision_secondary_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.9%; height: 22px;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }
    .vision_secondary_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.9%; margin-right: .1%; height: 355px; margin-top: 0px; overflow: auto;
    }
    .vision_secondary_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.9%; height: 25px;
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

<div class='vision_secondary_queue_header'>
    <img src="/images/vision/import.png" style="cursor: pointer; height: 20px; float: left" onclick="Argus.vision.member.importList()" title="Import Member List" />
    <a href='#' onclick="Argus.vision.invoice.review(); return false" style="float: right; margin-right: 5px">Invoice</a> Non Contracted Patients
</div>
<div class='vision_secondary_queue_header'>
    <a href='/vision/admin/claimexport' target="_blank" style="float: right; margin-right: 5px">Export</a>Failed Claims Queue
</div>
<div class='vision_secondary_queue_header'>
    Referral Required
</div>
<br />
<div class='vision_secondary_queue_body' id="vision_non_contracted_queue">
</div>
<div class='vision_secondary_queue_body' id="vision_failed_claims_queue">
</div>
<div class='vision_secondary_queue_body' id="vision_referral_required_queue">
</div>
<br />
<div class='vision_secondary_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='non_contracted-from-row'></span>-<span id='non_contracted-to-row'></span> of <span id='non_contracted-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='non_contracted-previous' id='non_contracted-previous' style='' class='vision_pagination_control' value='<' />
                <input type='button' name='non_contracted-first' id='non_contracted-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='non_contracted-last' id='non_contracted-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='non_contracted-next' id='non_contracted-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='non_contracted-page'></span> of <span id='non_contracted-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='vision_secondary_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='failed_claims-from-row'></span>-<span id='failed_claims-to-row'></span> of <span id='failed_claims-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='failed_claims-previous' id='failed_claims-previous' style='' class='vision_pagination_control' value='<' />
                <input type='button' name='failed_claims-first' id='failed_claims-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='failed_claims-last' id='failed_claims-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='failed_claims-next' id='failed_claims-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='failed_claims-page'></span> of <span id='failed_claims-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='vision_secondary_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='referral_required-from-row'></span>-<span id='referral_required-to-row'></span> of <span id='referral_required-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='referral_required-previous' id='referral_required-previous' style='' class='vision_pagination_control' value='<' />
                <input type='button' name='referral_required-first' id='referral_required-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='referral_required-last' id='referral_required-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='referral_required-next' id='referral_required-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='referral_required-page'></span> of <span id='referral_required-pages'></span>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('non_contracted',function (page,rows) {
       Argus.vision.secondaryqueues.refresh($E('vision_non_contracted_queue'),'non_contracted',page,rows);
    },1,15);    
    Pagination.init('failed_claims',function (page,rows) {
       Argus.vision.secondaryqueues.refresh($E('vision_failed_claims_queue'),'failed_claims',page,rows);
    },1,15);     
    Pagination.init('referral_required',function (page,rows) {
       Argus.vision.secondaryqueues.refresh($E('vision_referral_required_queue'),'referral_required',page,rows);
    },1,15); 
</script>

