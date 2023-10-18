<form name="new-entity-form" id="new-entity-form" onsubmit="return false">
    <br />
    <fieldset><legend style='color: ghostwhite'>New Entity Instruction</legend>
        Please fill out the information to create a new Entity.<br /><br />
        You need to specify an administrator, but you can add more administrators later<br /><br />
    </fieldset>
        <ul>
        <input type="text" name="entity" id="new_entity_name" /><br />
        Entity Name

        <br /><br />
        <select name="entity_type_id" id="new_entity_type">
            <option value=""> </option>
            {foreach from=$types->fetch() item=type}
                <option value="{$type.id}"> {$type.type} </option>
            {/foreach}
        </select><br />
        Entity Type<br /><br />
        <select name="user_id" id="new_entity_administrator">
            <option value=""> </option>
            {foreach from=$roles->getUsersByRoleName('Local Administrator') item=user}
                <option value="{$user.user_id}">{$user.last_name}, {$user.first_name}</option>
            {/foreach}
        </select><br /><br />
        <input type="button" id="new_entity_submit" name="new_entity_submit" value=" Create New Entity " /><br />
    </ul>
</form>
<script type="text/javascript">
    new EasyEdits('/edits/argus/newentity','new-entity-form');
</script>
