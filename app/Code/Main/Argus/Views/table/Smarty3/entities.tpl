[
    {
        "text": "",
        "value": ""
    }{foreach from=$entities->fetch() item=entity},
    {
        "text": "{$entity.entity}",
        "value": "{$entity.entity}"
    }
    {/foreach}
]