<div style="width: 600px; border: 1px solid ghostwhite; border-radius: 10px; height: 400px; overflow: auto; padding: 10px; box-sizing: content-box">
    <div style="background-color: #333; color: ghostwhite; padding: 2px 0px; font-weight: bold; margin-bottom: 2px">
        <div style="display: inline-block; width: 32%; overflow: hidden">
            Organization Name
        </div>
        <div style="display: inline-block; width: 16%; overflow: hidden">
            Type
        </div>        
        <div style="display: inline-block; width: 49%; overflow: hidden">
            Description
        </div>   
    </div>
{foreach from=$organizations->fetchInformation() item=organization}
    <div style="background-color: rgba(202,202,202,{cycle values=".2,.4"}); padding: 2px 0px">
        <div style="display: inline-block; width: 32%; overflow: hidden">
            <a href="#" onclick="Argus.configuration.organizations.entity.open('{$organization.id}'); return false" title="Click to view the entities under this organization">{$organization.organization}</a>
        </div>
        <div style="display: inline-block; width: 16%; overflow: hidden">
            {$organization.type}
        </div>        
        <div style="display: inline-block; width: 49%; overflow: hidden">
            {$organization.description}
        </div>   
    </div>
{/foreach}    
</div>
<form name="new-organization-form" id="new-organization-form" onsubmit="return false">
    <div style="padding: 10px; width: 600px;">
        <table width="100%">
            <tr>
                <td width="30%"><input type="text" name="organization" id="new_organization_name" style="width: 100%" value="" /></td>
                <td width="20%"><select name="type" id="new_organization_type" style="width: 100%; color: #333">
                        <option value=""></option>
                        {foreach from=$organization_types->fetch() item=type}
                            <option value="{$type.id}">{$type.type}</option>
                        {/foreach}
                    </select></td>
                <td width="40%"><input type="text" name="description" id="new_organization_description"  style="width: 100%" value="" /></td>
                <td width="10%" style="text-align: center"><input type="button" name="new-organization-submit" id="new_organization_submit" value=" Add " /></td>
            </tr>
            <tr>
                <td class="organization-field-desc">New Organization Name</td>
                <td class="organization-field-desc">Organization Type</td>
                <td class="organization-field-desc">Description</td>
                <td>&nbsp;</td>
            </tr>        
        </table>
    </div>
</form>
                    
<script type="text/javascript">
    new EasyEdits('/edits/argus/neworganization','new-organization-form');
</script>