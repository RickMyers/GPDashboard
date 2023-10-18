<style type='text/css'>
    .dental_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.9%; height: 22px;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }
    .dental_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.9%; margin-right: .1%; height: 290px; margin-top: 0px; overflow: auto;
    }
    .dental_queue_footer {
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

    .dental_pagination_control {
        padding: 2px 5px; font-size: .8em
    }
</style>
<div class='dental_queue_header'>
<img src="/images/dental/mouthwatch.png" title="Create a new mouthwatch consultation" style="float: right; margin-right: 5px; height: 20px; cursor: pointer"  onclick='Argus.dental.consultation.create()'/>
    New Queue</div>
<div class='dental_queue_header'>
    In Progress Queue
</div>
<div class='dental_queue_header'>
    Completed Queue
</div>
<br />
<div class='dental_queue_body' id="dental_new_queue">
</div>
<div class='dental_queue_body' id="dental_inprogress_queue">
</div>
<div class='dental_queue_body' id="dental_completed_queue">
</div>
<div class='dental_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='dental_new-from-row'></span>-<span id='dental_new-to-row'></span> of <span id='dental_new-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='dental_new-previous' id='dental_new-previous' style='' class='dental_pagination_control' value='<' />
                <input type='button' name='dental_new-first' id='dental_new-first' style='' class='dental_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='dental_new-last' id='dental_new-last' style='' class='dental_pagination_control' value='>>' />
                <input type='button' name='dental_new-next' id='dental_new-next' style='' class='dental_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='dental_new-page'></span> of <span id='dental_new-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='dental_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='dental_inprogress-from-row'></span>-<span id='dental_inprogress-to-row'></span> of <span id='dental_inprogress-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='dental_inprogress-previous' id='dental_inprogress-previous' style='' class='dental_pagination_control' value='<' />
                <input type='button' name='dental_inprogress-first' id='dental_inprogress-first' style='' class='dental_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='dental_inprogress-last' id='dental_inprogress-last' style='' class='dental_pagination_control' value='>>' />
                <input type='button' name='dental_inprogress-next' id='dental_inprogress-next' style='' class='dental_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='dental_inprogress-page'></span> of <span id='dental_inprogress-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='dental_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='dental_completed-from-row'></span>-<span id='dental_completed-to-row'></span> of <span id='dental_completed-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='dental_completed-previous' id='dental_completed-previous' style='' class='dental_pagination_control' value='<' />
                <input type='button' name='dental_completed-first' id='dental_completed-first' style='' class='dental_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='dental_completed-last' id='dental_completed-last' style='' class='dental_pagination_control' value='>>' />
                <input type='button' name='dental_completed-next' id='dental_completed-next' style='' class='dental_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='dental_completed-page'></span> of <span id='dental_completed-pages'></span>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('dental_new',function (page,rows) {
       Argus.dental.queue.page('dental_new',page,rows);
    },1,14);
    Pagination.init('dental_inprogress',function (page,rows) {
       Argus.dental.queue.page('dental_inprogress',page,rows);
    },1,14);
    Pagination.init('dental_completed',function (page,rows) {
       Argus.dental.queue.page('dental_completed',page,rows);
    },1,14);
    Argus.dashboard.socket.on('dentalConsultationStatusChange',Argus.dental.queue.init)
</script>