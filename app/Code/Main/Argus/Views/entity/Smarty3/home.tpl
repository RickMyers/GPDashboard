<style type="text/css">
    .text-input-field {
        width: 90%; padding: 2px; background-color: lightcyan; border: 1px solid rgba(202,202,202,.7); color: #333
    }
    .full {
        width: 100%
    }
    .threequarter {
            width: 74.5%; display: inline-block; border-right: 1px solid rgba(202,202,202,.7)
    }
    .half {
        width: 49.7%; display: inline-block; border-right: 1px solid rgba(202,202,202,.7)
    }
    .third {
        width: 33%; display: inline-block; border-right: 1px solid rgba(202,202,202,.7)
    }
    .quarter {
        width: 24.7%; display: inline-block; border-right: 1px solid rgba(202,202,202,.7)
    }
    .fifth {
        width: 19.5%; display: inline-block; border-right: 1px solid rgba(202,202,202,.7)
    }
    .sixth {
        width: 16%; display: inline-block; border-right: 1px solid rgba(202,202,202,.7)
    }
    .seventh {
        width: 13.5%; display: inline-block; border-right: 1px solid rgba(202,202,202,.7)
    }    
    .entity-cell {
        display: inline-block; background-color: rgba(202,202,202,.2)
    }
    .entity-cell-header {
        font-family: monospace; font-size: .9em; padding-left: 5px
    }
    .entity-cell-field {
        padding-left: 25px; padding-top: 5px; font-family: sans-serif; font-size: .9em
    }
</style>

<div id="argus-entity-tabs" style="color: #333"></div>

<!-- ################################################################################################### -->

<div id="argus-entity-types-tab" style="color: ghostwhite"></div>

<!-- ################################################################################################### -->

<div id="argus-new-entity-tab" style="color: ghostwhite"></div>

<!-- ################################################################################################### -->

<div id="argus-entity-relationships-tab">
    <br />
    <form name="existing_entity_search_form" id="existing_entity_search_form" onsubmit="return false" style="color: #333">
        Entity: <select name="existing_entity_id" id="existing_entity_id" style="color: #333">
            <option value=""> </option>
            {foreach from=$entities->information() item=entity}
                <option value="{$entity.id}" title="{$entity.description}"> {$entity.entity} </option>
            {/foreach}
        </select>
    </form>
    <hr />
    <div id="argus-new-entity-display">

    </div>    
</div>

<!-- ################################################################################################### -->

<script type="text/javascript">
    var tabs = new EasyTab('argus-entity-tabs',155);
    tabs.add('Entity Types',null,'argus-entity-types-tab');
    tabs.add('New Entity',function () {
        (new EasyAjax('/argus/entity/form')).then(function (response) {
            $('#argus-new-entity-tab').html(response);
        }).get();
    },'argus-new-entity-tab');
    tabs.add('Relationships',function () {
        $("#existing_entity_id").chosen({ allow_single_deselect: true, no_results_text: "No matching entities found!" }).on("change",function (evt) {
            if (evt.target.id) {
                (new EasyAjax('/argus/entity/display')).add('id',$(evt.target).val()).then(function (response) {
                    $('#argus-new-entity-display').html(response);
                }).post();     
            }
        }); 
    },'argus-entity-relationships-tab');
    tabs.tabClick(0);
    (new EasyAjax('/argus/entity/display')).add('id','').then(function (response) {
        $('#argus-new-entity-display').html(response);
    }).post();
    (new EasyAjax('/argus/entity/types')).then(function (response) {
        $('#argus-entity-types-tab').html(response);
    }).get();
</script>