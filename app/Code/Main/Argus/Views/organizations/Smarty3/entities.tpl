<div style="width: 600px; border: 1px solid ghostwhite; border-radius: 10px; height: 400px; overflow: auto; padding: 10px; box-sizing: content-box">
    <div style="font-size: 1.2em; font-weight: bolder">
        {$organization->getOrganization()}
    </div>    
    <div style="background-color: #333; color: ghostwhite; padding: 2px 0px; font-weight: bold; margin-bottom: 2px">
        <div style="display: inline-block; width: 32%; overflow: hidden">
            Entity Name
        </div>
        <div style="display: inline-block; width: 16%; overflow: hidden">
            Type
        </div>        
        <div style="display: inline-block; width: 49%; overflow: hidden">
            Description
        </div>   
    </div>
{foreach from=$entities->fetchInformation() item=entity}
    <div style="background-color: rgba(202,202,202,{cycle values=".2,.4"}); padding: 2px 0px">
        <div style="display: inline-block; width: 32%; overflow: hidden">
            {$entity.entity}
        </div>
        <div style="display: inline-block; width: 16%; overflow: hidden">
            {$entity.type}
        </div>        
        <div style="display: inline-block; width: 49%; overflow: hidden">
            {$entity.description}
        </div>   
    </div>
{/foreach}    
</div>
<form name="new-entity-form" id="new-entity-form" onsubmit="return false">
    <input type="hidden" name="organization_id" id="organization_id" value='{$organization->getId()}'/>
    <div style="padding: 10px; width: 600px;">
        <table width="100%">
            <tr>
                <td width="30%"><input type="text" name="entity" id="new_entity_name" style="width: 100%" value="" /></td>
                <td width="20%"><select name="type" id="new_entity_type" style="width: 100%; color: #333">
                        <option value=""></option>
                        {foreach from=$entity_types->fetch() item=type}
                            <option value="{$type.id}">{$type.type}</option>
                        {/foreach}
                    </select></td>
                <td width="40%"><input type="text" name="description" id="new_entity_description"  style="width: 100%" value="" /></td>
                <td width="10%" style="text-align: center"><input type="button" name="new-entity-submit" id="new_entity_submit" value=" Add " /></td>
            </tr>
            <tr>
                <td class="entity-field-desc">New Entity Name</td>
                <td class="entity-field-desc">Entity Type</td>
                <td class="entity-field-desc">Description</td>
                <td>&nbsp;</td>
            </tr>        
        </table>
    </div>
</form>
                    
<script type="text/javascript">
    new EasyEdits('/edits/argus/newentity','new-entity-form');
</script>
