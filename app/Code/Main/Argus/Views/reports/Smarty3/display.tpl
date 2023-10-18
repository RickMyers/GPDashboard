{assign var=results value=$report->display()}
{assign var=graph_section value=$report->getGraphs()}
{assign var=headers value=$report->getHeaders()}
{assign var=model value=$report->getModel()}
{assign var=ctr  value=0}
<style type="text/css">
    .report_header_cell {
        background-color: #333; color: ghostwhite; text-align: center
    }
    .report_data_cell {
        border-right: 1px solid silver; padding-left: 5px; white-space: nowrap
    }
</style>
{*debug*}
{foreach from=$graph_section item=graphs}
    {foreach from=$graphs item=graph}
        {$report->executeResource($graph)}
    {/foreach}
{/foreach}
<table style="width: 100%; border-bottom: 1px solid #333">
    <tr>
{foreach from=$headers item=header}
        <th class="report_header_cell">{$header}</th>
{/foreach}
    </tr>
    
{foreach from=$results item=row}
    {assign var=ctr value=$ctr+1}
    <tr style="background-color: rgba(202,202,202,{cycle values=".1,.3"})">
        {foreach from=$row item=field}
        <td class="report_data_cell">{$field}</td>
        {/foreach}
    </tr>
{/foreach}
    
</table>
<div style="text-align: right; padding-right: 10px; font-weight: bold;">
    Showing {$ctr} Rows
</div>
<br /><br /><br />

