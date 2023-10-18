<style type="text/css">
    .claim-fields {
        border-top: 1px solid #333; padding-top: 5px;
    }
    .claim-field-cell {
        float: left; margin-right: 5px; margin-bottom: 3px; background-color: rgba(202,202,202,.1);
    }
    .claim-field-header {
        font-family: monospace; letter-spacing: 1px; font-size: .85em; white-space: nowrap;
    }
    .claim-field-data {
        font-family: sans-serif; padding-left: 10px; 
    }
</style>
{foreach from=$claim->extendedClaimData() item=encounter key=index}
    <b>Record #{$index+1}</b>
    <div class="claim-fields" style="background-color: rgba(202,202,202,{cycle values=".1,.3"}")>
        {foreach from=$encounter item=value key=field}
            <div class="claim-field-cell">
                <div class="claim-field-header">{$field}&nbsp;</div>
                <div class="claim-field-data">{$value}&nbsp;</div>
            </div>
        {/foreach}
    </div>
    <div style="clear:both"></div>
    <br /><br />
{/foreach}
