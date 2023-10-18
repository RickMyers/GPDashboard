[
    {
        "text": "",
        "value": ""
    }
    {foreach from=$groups->reset()->fetch() item=group}
    ,{
        "text": "{$group.group}",
        "value": "{$group.id}"
    }
    {/foreach}
]