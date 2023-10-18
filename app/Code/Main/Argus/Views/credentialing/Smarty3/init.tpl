<style type='text/css'>
    .credentialing_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.5%; height: 22px;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }
    .credentialing_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.5%; margin-right: .1%; height: 290px; margin-top: 0px; overflow: hidden;
    }
    .credentialing_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.5%; height: 25px;
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

    .credentialing_pagination_control {
        padding: 2px 5px; font-size: .8em
    }    
</style>
<div class='credentialing_queue_header'>
    In Progres-Q
</div>
<div class='credentialing_queue_header'>
    Submitted-Q
</div>
<div class='credentialing_queue_header'>
    Completed-Q
</div>    
<br />
<div class='credentialing_queue_body' id="credentialing_inbound_queue">
</div>
<div class='credentialing_queue_body' id="credentialing_processing_queue">
</div>
<div class='credentialing_queue_body' id="credentialing_archive_queue">
</div>    
<div class='credentialing_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='icq-from-row'></span>-<span id='icq-to-row'></span> of <span id='icq-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='icq-previous' id='icq-previous' style='' class='credentialing_pagination_control' value='<' />
                <input type='button' name='icq-first' id='icq-first' style='' class='credentialing_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='icq-last' id='icq-last' style='' class='credentialing_pagination_control' value='>>' />
                <input type='button' name='icq-next' id='icq-next' style='' class='credentialing_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='icq-page'></span> of <span id='icq-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='credentialing_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='pcq-from-row'></span>-<span id='pcq-to-row'></span> of <span id='pcq-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='pcq-previous' id='pcq-previous'  style='' class='credentialing_pagination_control' value='<' />
                <input type='button' name='pcq-first' id='pcq-first' style='' class='credentialing_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='pcq-last' id='pcq-last' style='' class='credentialing_pagination_control' value='>>' />
                <input type='button' name='pcq-next' id='pcq-next' style='' class='credentialing_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='pcq-page'></span> of <span id='pcq-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='credentialing_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='acq-from-row'></span>-<span id='acq-to-row'></span> of <span id='acq-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='acq-previous' id='acq-previous'  style='' class='credentialing_pagination_control' value='<' />
                <input type='button' name='acq-first' id='acq-first' style='' class='credentialing_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='acq-last' id='acq-last' style='' class='credentialing_pagination_control' value='>>' />
                <input type='button' name='acq-next' id='acq-next' style='' class='credentialing_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='acq-page'></span> of <span id='acq-pages'></span>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('credentialing-inbound',function (page,rows) {
       Argus.credentialing.refresh($E('credentialing_inbound_queue'),'icq',page,rows);
    },1,14);
    Pagination.init('credentialing-processing',function (page,rows) {
       Argus.credentialing.refresh($E('credentialing_processing_queue'),'pcq',page,rows);
    },1,14);    
    Pagination.init('credentialing-archive',function (page,rows) {
       Argus.credentialing.refresh($E('credentialing_archive_queue'),'acq',page,rows);
    },1,14);
</script>