<h3>List of current Entity Types</h3>
<ul>
{foreach from=$types->fetch() item=type}
    <li><img src="/images/argus/redx.png" style="height: 10px; margin-right: 4px; position: relative; top: -2px;  cursor: pointer" onclick="Argus.configuration.entity.remove.type('{$type.id}',\"{$type.type}\")" />{$type.type} - {$type.description}</li>
{/foreach}
    <li>
        <form name="new-entity-type-form" id="new-entity-type-form" onsubmit="return false">
            <input type="text" name="entity_type" id="entity_type" placeholder="New Type" /> -
            <input type="text" name="entity_type" id="entity_type_description" placeholder="New Type Description" />&nbsp;
            <input type="button" name="entity_type_submit" id="entity_type_submit" value=" Add " />
        </form>
    </li>
</ul>
<script type="text/javascript">
    new EasyEdits('/edits/argus/newentitytype','new-entity-type-form');
</script>
