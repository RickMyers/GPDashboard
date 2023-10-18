<style type='text/css'>
    .teledentistry_archive_queue_header {
        border: 1px solid ghostwhite; margin-left: .3%; height: 8%; padding-top: 4px;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; 
    }
    .teledentistry_archive_queue_body {
         border: 1px solid ghostwhite; margin-left: .3%; height: 80%; margin-top: 0px; overflow: hidden; margin-bottom: 3px
    }
    .teledentistry_archive_queue_footer {
         border: 1px solid ghostwhite; margin-left: .3%; height: 10%; padding-top: 4px;
        color: navy; text-align: center; margin-bottom: 0px;
    }
    .teledentistry_archive_pagination_control {
        padding: 2px 5px;
    }
</style>
<div class='teledentistry_archive_queue_header'>
    Archived Teledentistry Consultations
</div>

<div class='teledentistry_archive_queue_body' id="teledentistry-archive-queue">
</div>

<div class='teledentistry_archive_queue_footer' >
    <table width='100%'>
        <tr>
            <td>
                <span id='archiveq-from-row'></span>-<span id='archiveq-to-row'></span> of <span id='archiveq-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='archiveq-previous' id='archiveq-previous' style='' class='teledentistry_archive_pagination_control' value='<' />
                <input type='button' name='archiveq-first' id='archiveq-first' style='' class='teledentistry_archive_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='archiveq-last' id='archiveq-last' style='' class='teledentistry_archive_pagination_control' value='>>' />
                <input type='button' name='archiveq-next' id='archiveq-next' style='' class='teledentistry_archive_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='archiveq-page'></span> of <span id='archiveq-pages'></span>
            </td>
        </tr>
    </table>
</div>

<script type="text/javascript">
    Pagination.init('archiveq',function (page,rows) {
       //Argus.dental.hedis.hygenist.refresh($E('teledentistry-archive-queue'),'archiveq',page,rows);
    },1,14);
</script>