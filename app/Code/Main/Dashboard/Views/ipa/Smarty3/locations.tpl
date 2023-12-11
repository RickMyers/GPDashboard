[
    {
        "text": "Select Location (Optional)",
        "value": ""
    }
    {foreach from=$locations->fetch() item=location}
    ,{
        "text": "{$location.location}",
        "value": "{$location.id}"
    }
    {/foreach}
]
