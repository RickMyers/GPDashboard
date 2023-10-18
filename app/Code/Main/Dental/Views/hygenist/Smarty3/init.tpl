<style type='text/css'>
    .hygenist_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .3%; width: 24%; height: 5%;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .3%
    }
    .hygenist_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .3%; width: 24%; margin-right: .3%; height: 84%; margin-top: 0px; overflow: hidden;
    }
    .hygenist_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .3%; width: 24%; height: 8%;
        color: navy; text-align: center; margin-bottom: 0px; margin-right: .3%
    }
    .hygenist_pagination_control {
        padding: 2px 5px;
    }
</style>

<div class='hygenist_queue_header'>
    Queued Calls
</div>
<div class='hygenist_queue_header'>
    On-Hold Contacts
</div>
<div class='hygenist_queue_header'>
    Completed Counseling
</div>
<div class='hygenist_queue_header'>
    Calls Completed
</div>
<br />
<div class='hygenist_queue_body' id="hygenist-queued-call-queue">
</div>
<div class='hygenist_queue_body' id="hygenist-onhold-call-queue">
</div>
<div class='hygenist_queue_body' id="hygenist-completed-counseling-call-queue">
</div>
<div class='hygenist_queue_body' id="hygenist-completed-call-queue">
</div>
<div class='hygenist_queue_footer' >
    <table width='100%'>
        <tr>
            <td>
                <span id='hqd-from-row'></span>-<span id='hqd-to-row'></span> of <span id='hqd-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='hqd-previous' id='hqd-previous' style='' class='hygenist_pagination_control' value='<' />
                <input type='button' name='hqd-first' id='hqd-first' style='' class='hygenist_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='hqd-last' id='hqd-last' style='' class='hygenist_pagination_control' value='>>' />
                <input type='button' name='hqd-next' id='hqd-next' style='' class='hygenist_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='hqd-page'></span> of <span id='hqd-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='hygenist_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='hoh-from-row'></span>-<span id='hoh-to-row'></span> of <span id='hoh-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='hoh-previous' id='hoh-previous' style='' class='hygenist_pagination_control' value='<' />
                <input type='button' name='hoh-first' id='hoh-first' style='' class='hygenist_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='hoh-last' id='hoh-last' style='' class='hygenist_pagination_control' value='>>' />
                <input type='button' name='hoh-next' id='hoh-next' style='' class='hygenist_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
               <span id='hoh-page'></span> of <span id='hoh-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='hygenist_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='hcc-from-row'></span>-<span id='hcc-to-row'></span> of <span id='hcc-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='hcc-previous' id='hcc-previous' style='' class='hygenist_pagination_control' value='<' />
                <input type='button' name='hcc-first' id='hcc-first' style='' class='hygenist_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='hcc-last' id='hcc-last' style='' class='hygenist_pagination_control' value='>>' />
                <input type='button' name='hcc-next' id='hcc-next' style='' class='hygenist_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
               <span id='hcc-page'></span> of <span id='hcc-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='hygenist_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='hcm-from-row'></span>-<span id='hcm-to-row'></span> of <span id='hcm-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='hcm-previous' id='hcm-previous' style='' class='hygenist_pagination_control' value='<' />
                <input type='button' name='hcm-first' id='hcm-first' style='' class='hygenist_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='hcm-last' id='hcm-last' style='' class='hygenist_pagination_control' value='>>' />
                <input type='button' name='hcm-next' id='hcm-next' style='' class='hygenist_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
               <span id='hcm-page'></span> of <span id='hcm-pages'></span>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('hqd',function (page,rows) {
       Argus.dental.hedis.hygenist.refresh($E('hygenist-queued-call-queue'),'hqd',page,rows);
    },1,14);
    Pagination.init('hoh',function (page,rows) {
       Argus.dental.hedis.hygenist.refresh($E('hygenist-onhold-call-queue'),'hoh',page,rows);
    },1,14);     
    Pagination.init('hcc',function (page,rows) {
       Argus.dental.hedis.hygenist.refresh($E('hygenist-completed-counseling-call-queue'),'hcc',page,rows);
    },1,14);    
    Pagination.init('hcm',function (page,rows) {
       Argus.dental.hedis.hygenist.refresh($E('hygenist-completed-call-queue'),'hcm',page,rows);
    },1,14);
</script>