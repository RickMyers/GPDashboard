[
    {
        "text": "",
        "value": ""
    }
    {foreach from=$participants->fetch() item=participant}
    ,{
        "text": "{$participant.participant}",
        "value": "{$participant.id}"
    }
    {/foreach}
]