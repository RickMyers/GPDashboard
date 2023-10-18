<style type="text/css">
    .selection-area {
        width: 21%; margin-right: 1%; border: 1px solid ghostwhite; padding: 10px;
        height: 600px; display: inline-block; overflow: auto; border-radius: 10px;
    }
    .option-layer {
        padding: 2px 5px; cursor: pointer; margin-bottom: 1px
    }
</style>

<div id="client_list" class="selection-area">
    <a href="#" onclick="Argus.hedis.vision.client.add(); return false" style="color: blue; float: right; margin-right: 5px">Add Client</a>
    <div style="position: static; margin-bottom: 2px;">Client:</div>
    {foreach from=$clients->fetch() item=client}
        <div id="vision_client_{$client.id}" style="background-color: rgba(202,202,202,{cycle values=".15,.3"})" class="option-layer" onclick="Argus.hedis.vision.ipa.list({$client.id})">{$client.client}</div>
    {/foreach}        
</div>
<div id="ipa_list" class="selection-area">

</div>
<div id="location_list" class="selection-area">

</div>    
<div id="address_list" class="selection-area" style="width: 32%">

</div>    
    
