{assign var=service_data value=$services->fetch()}
<style type="text/css">
    .service_cell {
        display: inline-block; margin-left: 1px; margin-bottom: 1px;
    }
    .service_header_cell {
        font-weight: bold; color: #333; text-align: center; font-size: .9em;
    }
    .service_data_cell {
        font-family: monospace; font-size: .8em; letter-spacing: 1px; padding-left: 10px
    }
</style>
<div class="service_cell service_header_cell" style="width: 40%"> &nbsp; </div>
<div class="service_cell service_header_cell" style="width: 10%"> Procedure Code </div>
<div class="service_cell service_header_cell" style="width: 30%"> Description </div>
<div class="service_cell service_header_cell" style="width: 8%"> Amount </div>
<div class="service_cell service_header_cell" style="width: 8%"> Service Date </div>
{foreach from=$service_data item=service}
        <div class="service_cell service_data_cell" style="width: 40%"> &nbsp; </div>        
        <div class="service_cell service_data_cell" style="width: 10%"> {$service.service} </div>
        <div class="service_cell service_data_cell" style="width: 30%"> TBD </div>
        <div class="service_cell service_data_cell" style="width: 8%"> {$service.amount} </div>
        <div class="service_cell service_data_cell" style="width: 8%"> {$service.date|date_format:'m/d/Y'} </div>
{foreachelse}
    <div style="padding: 10px">
        No services found for that claim
    </div>
{/foreach}

<div style="clear: both"></div>


