<style type='text/css'>
    .pcp_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 49.50%; height: 22px;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }
    .pcp_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 49.50%; margin-right: .1%; height: 290px; margin-top: 0px; overflow: auto;
    }
    .pcp_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 49.50%; height: 25px;
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
    .pcp_pagination_control {
        padding: 2px 5px; font-size: .8em
    }    
</style>
<div class='pcp_queue_header'>
    Consultations
</div>
<div class='pcp_queue_header'>
    <div style="float: right; padding-right: 5px; color: #333; white-space: nowrap">
        
        <form name="pcp_reports_year_form" id="pcp_reports_year_form">
            Year:&nbsp;<select name="report_year" id="report_year" style="padding: 2px 5px; background-color: lightcyan">
                <option value="">  </option>
                <option value="2025"> 2025 </option>
                <option value="2024"> 2024 </option>
                <option value="2023"> 2023 </option>
                <option value="2022" selected="selected"> 2022 </option>
                <option value="2021" > 2021 </option>
                <option value="2020"> 2020 </option>
                <option value="2019"> 2019 </option>
            </select>
        </form>
    </div>
    Reports
</div>    
<br />
<div class='pcp_queue_body' id="pcp_consultations_queue">
</div>
<div class='pcp_queue_body' id="pcp_reports_queue">
</div>    
<div class='pcp_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='pcpqueue-from-row'></span>-<span id='pcpqueue-to-row'></span> of <span id='pcpqueue-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='pcpqueue-previous' id='pcpqueue-previous'  style='' class='pcp_pagination_control' value='<' />
                <input type='button' name='pcpqueue-first' id='pcpqueue-first' style='' class='pcp_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='pcpqueue-last' id='pcpqueue-last' style='' class='pcp_pagination_control' value='>>' />
                <input type='button' name='pcpqueue-next' id='pcpqueue-next' style='' class='pcp_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='pcpqueue-page'></span> of <span id='pcpqueue-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='pcp_queue_footer'>
    <table width='100%'>
        <tr>
            <td style="visibility: hidden">
                <span id='pcpreports-from-row'></span>-<span id='pcpreports-to-row'></span> of <span id='pcpreports-rows'></span>
            </td>
            <td align='center' style="visibility: hidden">
                <input type='button' name='pcpqueue-previous' id='pcpreports-previous'  style='' class='pcp_pagination_control' value='<' />
                <input type='button' name='pcpqueue-first' id='pcpreports-first' style='' class='pcp_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='pcpqueue-last' id='pcpreports-last' style='' class='pcp_pagination_control' value='>>' />
                <input type='button' name='pcpqueue-next' id='pcpreports-next' style='' class='pcp_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px; visibility: hidden'>
                <span id='pcpreports-page'></span> of <span id='pcpreports-pages'></span>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('pcpqueue',function (page,rows) {
        Argus.vision.pcp.refresh($E('pcp_consultations_queue'),'pcpqueue',page,rows);
    },1,14);
    (function () {
        var template = Handlebars.compile((Humble.template('vision/PCPReports')));
        (new EasyAjax('/vision/pcpreports/list')).then(function (response) {
            $('#pcp_reports_queue').html(template({ "data":  JSON.parse(response) }));
        }).get();
    })();
</script>
