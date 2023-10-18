<div style="min-width: 1000px; width: 80%">
{assign var=entity_id value=$entity->getId()}
{if ($entity_id)}
    {foreach from=$entity->information($entity_id) item=data}
        <div>
            <div class="entity-cell half">
                <div class="entity-cell-header">
                    Entity name
                </div>
                <div class="entity-cell-field" style="font-size: 1.5em; font-weight: bolder">
                    <b>{$data.entity}</b>
                </div>
            </div>        
            <div class="entity-cell half">
                <div class="entity-cell-header">
                    Entity Type
                </div>
                <div class="entity-cell-field" style="font-size: 1.5em; font-weight: bolder">
                    {$data.type}
                </div>
            </div>        
        </div>
        <div>
            <form>
                <fieldset><legend>Relations</legend>
                    <div class="entity-cell full">
                        <div class="entity-cell-header">
                            Parent Entity
                        </div>
                        <div class="entity-cell-field">
                            <select name="parent_entity_id" id="parent_entity_id" style="color: #333">
                                <option value=""> </option>
                                {foreach from=$entities->information() item=parent}
                                    <option value="{$parent.id}" title="{$parent.description}"> {$parent.entity} </option>
                                {/foreach}
                             </select>
                        </div>
                    </div>
                    <div class="entity-cell full">
                        <div class="entity-cell-header">
                            Current Relationships
                        </div>
                        <div class="entity-cell-field">
                            <ul>
                        {foreach from=$relationships->information() item=relationship}
                            <li>
                                {$relationship.entity_name}
                            </li>

                        {foreachelse}
                        
                            <li>
                                No established relationships
                            </li>
                        {/foreach}
                            </ul>    
                        </div>
                    </div>                             
                </fieldset>
            </form>
        </div>
        <script type="text/javascript">
            $("#parent_entity_id").chosen({ allow_single_deselect: true, no_results_text: "No matching entities found!" })
        </script>
    {/foreach}
{else}
    <form name="new_entity_contact_data_form" id="new_entity_contact_data_form" onsubmit="return false">
        <fieldset><legend>Entity Information</legend>
            <div id="new-entity-basic-data">
                <div class="entity-cell threequarter">
                    <div class="entity-cell-header">
                        Entity name
                    </div>
                    <div class="entity-cell-field">
                        <input type="text" class="text-input-field" name="new_contact_name" id="new_contact_name" />
                    </div>
                </div>

                <div class="entity-cell quarter">
                    <div class="entity-cell-header">
                        Entity Type
                    </div>
                    <div class="entity-cell-field">
                        <select name="new_entity_type" id="new_entity_type"  class="text-input-field">
                            <option value=""></option>
                            {foreach from=$entity_types->fetch() item=entity_type}
                                <option value="{$entity_type.id}"> {$entity_type.type} </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
            </div>
        </fieldset>
    </form>
{/if}
            
{if ($entity_id)}
    <form>            
    {foreach from=$addresses->information($entity_id) item=address}
        <fieldset><legend>{$address.type}</legend>
            <div class="entity-cell third">
                <div class="entity-cell-header">
                    Street Address
                </div>
                <div class="entity-cell-field">
                    {$address.address}
                </div>                
            </div>
            <div class="entity-cell fifth">
                <div class="entity-cell-header">
                    City
                </div>
                <div class="entity-cell-field">
                    {$address.city}
                </div>                
            </div> 
            <div class="entity-cell fifth">
                <div class="entity-cell-header">
                    State
                </div>
                <div class="entity-cell-field">
                    {$address.state}
                </div>                
            </div>
            <div class="entity-cell fifth">
                <div class="entity-cell-header">
                    ZIP Code
                </div>
                <div class="entity-cell-field">
                    {$address.zip_code}
                </div>                
            </div>                
        </fieldset>
    {/foreach}
    </form>
{/if}


<div id="new-entity-address-data">
    
</div>

{if ($entity_id)}
{/if}
<!-- list phone-numbers here -->

<div id="new-entity-phone-data">
    
</div>

{if ($entity_id)}
{/if}

<div id="new-entity-email-data">
    
</div>
</div>
<!--
 CONTACT MANAGEMENT HERE
-->

